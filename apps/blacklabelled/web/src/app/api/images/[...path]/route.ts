import { NextRequest } from "next/server";
import { readFile } from "fs/promises";
import path from "path";

const DATA_IMAGES_DIR = path.resolve(
  process.cwd(),
  "..",
  "data",
  "images"
);

const MIME_MAP: Record<string, string> = {
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".svg": "image/svg+xml",
};

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ path: string[] }> }
) {
  const { path: segments } = await params;
  const filePath = path.join(DATA_IMAGES_DIR, ...segments);

  // Prevent directory traversal
  if (!filePath.startsWith(DATA_IMAGES_DIR)) {
    return new Response("Forbidden", { status: 403 });
  }

  try {
    const data = await readFile(filePath);
    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_MAP[ext] || "application/octet-stream";

    return new Response(data, {
      headers: {
        "Content-Type": contentType,
        "Cache-Control": "public, max-age=31536000, immutable",
      },
    });
  } catch {
    return new Response("Not Found", { status: 404 });
  }
}
