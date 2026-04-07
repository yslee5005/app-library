# PROMPT — App Library 공통 패키지 추출

> Ralph 자율 실행용 프롬프트
> 목표: Abba 앱에서 재사용 가능한 컴포넌트를 packages/로 추출

---

## 실행 규칙

1. 각 패키지는 독립적으로 `flutter analyze` 통과해야 함
2. 패키지 이름 prefix: `app_lib_`
3. 모든 패키지에 `pubspec.yaml`, `lib/`, `README.md` 포함
4. Supabase 테이블 필요 시 `packages/{name}/sql/` 에 스키마 예시
5. 기존 패키지 확장 시 기존 코드 깨지지 않게 주의

---

## 패키지 1: packages/core/ 확장 — NetworkChecker

`packages/core/lib/src/network/network_checker.dart` 추가:

```dart
import 'dart:io';

/// Simple network connectivity check using DNS lookup.
class NetworkChecker {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
  }
}
```

`packages/core/lib/core.dart` 에 export 추가.

---

## 패키지 2: packages/ui_kit/ 확장 — PremiumGate + StreakBadge

### 2-1. PremiumGate 위젯

`packages/ui_kit/lib/src/premium_gate.dart`:

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// Generic premium content gate with blur effect.
/// Wrap any content — when [isLocked], shows blur + unlock CTA.
class PremiumGate extends StatelessWidget {
  final Widget content;
  final bool isLocked;
  final String title;
  final String? icon; // emoji
  final String unlockLabel; // "Unlock with Premium"
  final VoidCallback onUnlock;

  const PremiumGate({
    super.key,
    required this.content,
    required this.isLocked,
    required this.title,
    this.icon,
    required this.unlockLabel,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) Text(icon!, style: const TextStyle(fontSize: 24)),
                  if (icon != null) const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              content,
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Text(icon!, style: const TextStyle(fontSize: 24)),
                if (icon != null) const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: content,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.3),
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: onUnlock,
                        icon: const Text('💎'),
                        label: Text(unlockLabel),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2-2. StreakBadge 위젯

`packages/ui_kit/lib/src/streak_badge.dart`:

```dart
import 'package:flutter/material.dart';

/// Gamification streak badge with customizable icon levels.
class StreakBadge extends StatelessWidget {
  final int days;
  final List<StreakLevel> levels;
  final TextStyle? daysStyle;
  final TextStyle? labelStyle;

  const StreakBadge({
    super.key,
    required this.days,
    this.levels = defaultLevels,
    this.daysStyle,
    this.labelStyle,
  });

  static const defaultLevels = [
    StreakLevel(threshold: 1, icon: '🌱'),
    StreakLevel(threshold: 8, icon: '🌿'),
    StreakLevel(threshold: 15, icon: '🌷'),
    StreakLevel(threshold: 31, icon: '🌸'),
    StreakLevel(threshold: 60, icon: '🌳'),
  ];

  String get icon {
    var result = levels.first.icon;
    for (final level in levels) {
      if (days >= level.threshold) result = level.icon;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 8),
        Text('$days', style: daysStyle ?? Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class StreakLevel {
  final int threshold;
  final String icon;

  const StreakLevel({required this.threshold, required this.icon});
}
```

### 2-3. InfiniteScrollList 확인 및 보강

`packages/pagination/` 에 이미 있으면 건너뛰기.
없으면 추가:

```dart
class InfiniteScrollList<T> extends StatefulWidget {
  final Future<List<T>> Function(String? cursor, int limit) onLoadMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? loadingIndicator;
  final Widget? emptyWidget;
  final int pageSize;

  // ScrollController 자동 관리, 끝에 도달 시 loadMore 호출
}
```

---

## 패키지 3: packages/subscriptions/ 신규 — 구독 관리

`packages/subscriptions/` 신규 생성:

```
packages/subscriptions/
├── pubspec.yaml
├── lib/
│   ├── subscriptions.dart          # barrel export
│   └── src/
│       ├── subscription_service.dart    # abstract interface
│       ├── subscription_status.dart     # enum
│       ├── mock_subscription_service.dart
│       └── revenuecat_subscription_service.dart
├── sql/
│   └── subscriptions_schema.sql    # Supabase 테이블 예시
└── README.md
```

인터페이스:
```dart
enum SubscriptionStatus { free, premium, trial }

abstract class SubscriptionService {
  Future<void> initialize();
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<bool> purchasePlan(String planId);
  Future<void> restorePurchases();
  Future<bool> get isPremium;
  Stream<SubscriptionStatus> get statusStream;
}
```

---

## 패키지 4: packages/gamification/ 신규 — 스트릭 + 마일스톤

`packages/gamification/` 신규 생성:

```
packages/gamification/
├── pubspec.yaml
├── lib/
│   ├── gamification.dart
│   └── src/
│       ├── streak.dart              # Streak 모델
│       ├── milestone.dart           # Milestone 모델
│       ├── streak_calculator.dart   # 날짜 기반 계산 유틸
│       ├── gamification_service.dart # abstract interface
│       └── mock_gamification_service.dart
├── sql/
│   └── gamification_schema.sql
└── README.md
```

```dart
class Streak {
  final int current;
  final int best;
  final DateTime? lastActivityDate;
}

class Milestone {
  final String type;    // 'first_activity', '7_day_streak', etc.
  final DateTime achievedAt;
}

class StreakCalculator {
  /// Returns updated streak after activity today
  static Streak recordActivity(Streak current, {bool graceRecovery = false}) {
    // diff == 0: already recorded today
    // diff == 1: consecutive
    // diff == 2 && graceRecovery: grace recovery
    // diff > 2: reset
  }
}

abstract class GamificationService {
  Future<Streak> getStreak();
  Future<void> recordActivity();
  Future<List<String>> checkMilestones();
}
```

---

## 패키지 5: packages/feed/ 신규 — 소셜 피드

`packages/feed/` 신규 생성:

```
packages/feed/
├── pubspec.yaml
├── lib/
│   ├── feed.dart
│   └── src/
│       ├── feed_item.dart           # 기본 피드 아이템 모델
│       ├── feed_comment.dart        # 댓글 모델
│       ├── feed_repository.dart     # abstract interface
│       └── mock_feed_repository.dart
├── sql/
│   └── feed_schema.sql
└── README.md
```

```dart
class FeedItem {
  final String id;
  final String userId;
  final String? displayName;
  final String category;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final List<FeedComment> comments;
}

abstract class FeedRepository {
  Future<List<FeedItem>> getFeed({String? category, String? cursor, int limit = 20});
  Future<FeedItem> createPost({required String content, String? displayName, required String category});
  Future<void> deletePost(String postId);
  Future<bool> toggleLike(String postId);
  Future<bool> toggleSave(String postId);
  Future<List<FeedComment>> getComments(String postId);
  Future<FeedComment> createComment({required String postId, required String content, String? parentId});
  Future<void> deleteComment(String commentId);
  Future<void> reportPost(String postId, String reason);
}
```

---

## 완료 조건

- [ ] 각 패키지 `flutter analyze` 통과
- [ ] 기존 packages/ 코드 깨지지 않음
- [ ] 새 패키지 pubspec.yaml + lib/ + README.md 포함
- [ ] SQL 스키마 예시 포함 (Supabase 패턴)
- [ ] barrel export (패키지명.dart) 작성
