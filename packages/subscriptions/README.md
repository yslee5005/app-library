# app_lib_subscriptions

RevenueCat-backed subscription management for all apps in the library.

## What's Inside

| File | Purpose |
|------|---------|
| `SubscriptionStatus` | `free` / `premium` / `trial` enum |
| `SubscriptionService` | Abstract interface — `initialize`, `purchaseMonthly`, `purchaseYearly`, `restorePurchases`, status stream |
| `MockSubscriptionService` | In-memory stub for development and tests |
| `RevenueCatSubscriptionService` | Production implementation on `purchases_flutter` 10.x |

## Wiring an App

```yaml
# pubspec.yaml
dependencies:
  app_lib_subscriptions:
    path: ../../packages/subscriptions
```

```dart
// main.dart — after Supabase auth + appLogger are ready
import 'package:app_lib_subscriptions/subscriptions.dart';

final overrides = [
  subscriptionServiceProvider.overrideWithValue(
    RevenueCatSubscriptionService(apiKey: AppConfig.revenueCatApiKey),
  ),
];
// Call .initialize(user.id) after sign-in completes.
```

```dart
// views
final isPremium = ref.watch(isPremiumProvider);
final status = ref.watch(subscriptionStatusProvider);  // Stream

await ref.read(subscriptionServiceProvider).purchaseMonthly();
await ref.read(subscriptionServiceProvider).purchaseYearly();
await ref.read(subscriptionServiceProvider).restorePurchases();
```

Each app is expected to declare its own `subscriptionServiceProvider` (Riverpod) — the provider shape is app-specific, the service implementation is shared.

## Dashboard Setup

1. Create a project in [RevenueCat Dashboard](https://app.revenuecat.com/)
2. Add the iOS and Android app bundle IDs
3. Create an entitlement called `premium` (or override via `entitlementId` constructor arg)
4. Create monthly / annual offerings and attach products to the default offering
5. Put platform API keys into the app's `.env` as `REVENUECAT_API_KEY` (one per platform if needed)

## Optional Supabase Sync

`sql/subscriptions_schema.sql` has a `public.subscriptions` table for RevenueCat webhook → Supabase sync. Useful when you want to read entitlement from the database instead of the SDK (consistent pattern across apps). See RevenueCat webhook docs to wire this up through a Supabase Edge Function.

## Pricing Reminder

RevenueCat is free up to **$2,500 MTR**, then 1% on the portion above. Apple/Google store fees (15–30%) are charged separately by the platforms and are unavoidable regardless of the IAP library you choose.
