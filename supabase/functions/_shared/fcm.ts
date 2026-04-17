/**
 * Shared FCM HTTP v1 API helper for Supabase Edge Functions.
 *
 * Required Supabase secret:
 *   FIREBASE_SERVICE_ACCOUNT — JSON string of Firebase service account key
 *
 * Usage:
 *   import { getAccessToken, sendFcmNotification } from "../_shared/fcm.ts";
 */

// --- JWT / OAuth2 helpers ---------------------------------------------------

/** Base64url-encode a Uint8Array (no padding). */
function base64url(data: Uint8Array): string {
  const binString = Array.from(data, (byte) =>
    String.fromCharCode(byte)
  ).join("");
  return btoa(binString)
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
}

/** Base64url-encode a UTF-8 string. */
function base64urlEncode(str: string): string {
  return base64url(new TextEncoder().encode(str));
}

/**
 * Import a PKCS#8 PEM private key for RS256 signing.
 * Firebase service account keys ship as PKCS#8 PEM.
 */
async function importPrivateKey(pem: string): Promise<CryptoKey> {
  const pemContents = pem
    .replace(/-----BEGIN PRIVATE KEY-----/g, "")
    .replace(/-----END PRIVATE KEY-----/g, "")
    .replace(/\s/g, "");

  const binaryString = atob(pemContents);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }

  return crypto.subtle.importKey(
    "pkcs8",
    bytes.buffer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );
}

/**
 * Create a signed JWT for Google OAuth2 service-account auth.
 * Scope: https://www.googleapis.com/auth/firebase.messaging
 */
async function createSignedJwt(
  serviceAccount: ServiceAccount
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = base64urlEncode(
    JSON.stringify({ alg: "RS256", typ: "JWT" })
  );
  const payload = base64urlEncode(
    JSON.stringify({
      iss: serviceAccount.client_email,
      sub: serviceAccount.client_email,
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600, // 1 hour
      scope: "https://www.googleapis.com/auth/firebase.messaging",
    })
  );

  const signingInput = `${header}.${payload}`;
  const key = await importPrivateKey(serviceAccount.private_key);
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(signingInput)
  );

  return `${signingInput}.${base64url(new Uint8Array(signature))}`;
}

// --- Types ------------------------------------------------------------------

interface ServiceAccount {
  project_id: string;
  client_email: string;
  private_key: string;
}

interface AccessTokenCache {
  token: string;
  expiresAt: number;
}

interface FcmData {
  [key: string]: string;
}

interface SendResult {
  success: boolean;
  error?: string;
  /** true when the token is permanently invalid (should be deactivated). */
  tokenInvalid?: boolean;
}

// --- Module-level cache (lives for the duration of the Edge Function) --------

let cachedToken: AccessTokenCache | null = null;

// --- Public API -------------------------------------------------------------

/**
 * Get a fresh (or cached) OAuth2 access token for FCM HTTP v1 API.
 * Reads `FIREBASE_SERVICE_ACCOUNT` from Deno env.
 */
export async function getAccessToken(): Promise<string> {
  // Return cached token if still valid (with 5-min buffer).
  if (cachedToken && Date.now() < cachedToken.expiresAt - 5 * 60 * 1000) {
    return cachedToken.token;
  }

  const raw = Deno.env.get("FIREBASE_SERVICE_ACCOUNT");
  if (!raw) {
    throw new Error("FIREBASE_SERVICE_ACCOUNT secret is not set");
  }

  const serviceAccount: ServiceAccount = JSON.parse(raw);
  const jwt = await createSignedJwt(serviceAccount);

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`OAuth2 token exchange failed: ${res.status} ${text}`);
  }

  const json = await res.json();
  cachedToken = {
    token: json.access_token,
    expiresAt: Date.now() + json.expires_in * 1000,
  };

  return cachedToken.token;
}

/**
 * Return the Firebase project ID from the service account secret.
 */
export function getProjectId(): string {
  const raw = Deno.env.get("FIREBASE_SERVICE_ACCOUNT");
  if (!raw) {
    throw new Error("FIREBASE_SERVICE_ACCOUNT secret is not set");
  }
  const sa: ServiceAccount = JSON.parse(raw);
  return sa.project_id;
}

/**
 * Send a single FCM push notification via HTTP v1 API.
 *
 * Returns `{ success: true }` on success.
 * Returns `{ success: false, tokenInvalid: true }` if the token is
 * unregistered / invalid (caller should deactivate it in user_devices).
 */
export async function sendFcmNotification(
  token: string,
  title: string,
  body: string,
  data?: FcmData
): Promise<SendResult> {
  const accessToken = await getAccessToken();
  const projectId = getProjectId();

  const message: Record<string, unknown> = {
    message: {
      token,
      notification: { title, body },
      ...(data && { data }),
      // APNs high-priority for iOS
      apns: {
        payload: { aps: { sound: "default" } },
      },
      // Android high-priority
      android: {
        priority: "high",
        notification: { sound: "default" },
      },
    },
  };

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(message),
    }
  );

  if (res.ok) {
    return { success: true };
  }

  const errorBody = await res.text();

  // 404 / UNREGISTERED / INVALID_ARGUMENT — token is dead.
  if (
    res.status === 404 ||
    errorBody.includes("UNREGISTERED") ||
    errorBody.includes("INVALID_ARGUMENT")
  ) {
    console.warn(
      `FCM token invalid (status=${res.status}), marking for cleanup: ${token.slice(0, 20)}...`
    );
    return { success: false, error: errorBody, tokenInvalid: true };
  }

  console.error(`FCM send failed (status=${res.status}): ${errorBody}`);
  return { success: false, error: errorBody };
}

/**
 * Deactivate an FCM token in user_devices so we stop sending to it.
 * Uses the Supabase service_role client passed in.
 */
export async function deactivateToken(
  supabaseClient: {
    from: (table: string) => {
      update: (data: Record<string, unknown>) => {
        eq: (col: string, val: string) => {
          eq: (col: string, val: string) => Promise<{ error: unknown }>;
        };
      };
    };
  },
  appId: string,
  fcmToken: string
): Promise<void> {
  const { error } = await supabaseClient
    .from("user_devices")
    .update({ is_active: false, updated_at: new Date().toISOString() })
    .eq("app_id", appId)
    .eq("fcm_token", fcmToken);

  if (error) {
    console.error("Failed to deactivate token:", error);
  }
}
