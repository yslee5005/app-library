# app_lib_subscriptions

Subscription management package for App Library.

## Features

- `SubscriptionStatus` enum: `free`, `premium`, `trial`
- `SubscriptionService` abstract interface
- `MockSubscriptionService` for development/testing
- `RevenueCatSubscriptionService` stub for production

## Usage

```dart
import 'package:app_lib_subscriptions/subscriptions.dart';

final service = MockSubscriptionService();
await service.initialize();

final status = await service.getSubscriptionStatus();
final isPremium = await service.isPremium;
```

## SQL Schema

See `sql/subscriptions_schema.sql` for the Supabase table definition.
