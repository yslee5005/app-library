# PROMPT — 커뮤니티 인스타그램 스타일 + 마이페이지

> Ralph 자율 실행용 프롬프트

---

## 실행 규칙

1. 각 파일 수정 전 반드시 Read로 읽기
2. ARB 키 추가 시 5개 언어 모두 동시 추가
3. 수정 후 `flutter analyze` 검증
4. 모든 수정 완료 후 `flutter test` 통과 확인

---

## 필수 읽기

- `apps/abba/lib/features/community/view/community_view.dart`
- `apps/abba/lib/features/community/view/write_post_view.dart`
- `apps/abba/lib/features/settings/view/settings_view.dart`
- `apps/abba/lib/router/app_router.dart`
- `apps/abba/lib/providers/providers.dart`
- `apps/abba/lib/services/community_repository.dart`
- `apps/abba/lib/services/prayer_repository.dart`
- `apps/abba/lib/models/post.dart`
- `apps/abba/lib/widgets/abba_tab_bar.dart`

---

## 변경 1: 커뮤니티 피드 인스타그램 스타일 (community_view.dart 전면 리라이트)

### 레이아웃 변경

현재: 카드 기반 (그림자, 둥근 모서리, 마진)
변경: 풀 너비, 카드 없음, 얇은 구분선만

### 포스트 아이템 구조 (인스타 스타일)

```
[아바타 36px] [이름 bold] [간증 pill] [시간 gray] [...메뉴]
────────────────────────────────────────
본문 텍스트 (18pt, 전체 너비)
최대 3줄 + "더 보기" 링크
────────────────────────────────────────
❤️ 23    💬 5                      🔖
────────────────────────────────────────
"김집사 외 4명이 좋아합니다" (선택적)
"댓글 5개 모두 보기" (탭 → 댓글 바텀시트)
────────────────────────────────────────
얇은 Divider
```

### 구현 세부:

1. **Container → 풀 너비**: margin 제거, boxShadow 제거, borderRadius 제거
2. **구분선**: `Divider(height: 1, color: AbbaColors.muted.withValues(alpha: 0.2))`
3. **좋아요 더블탭**: 포스트 본문에 `GestureDetector.onDoubleTap` → ❤️ 애니메이션
4. **"더 보기" 링크**: `maxLines: 3`일 때 텍스트 끝에 "더 보기" 터치 가능
5. **좋아요 요약**: "김집사 외 N명이 좋아합니다" 텍스트
6. **댓글 미리보기**: 첫 번째 댓글 1줄 + "댓글 N개 모두 보기" 링크

### 댓글 바텀시트 (신규)

"댓글 N개 모두 보기" 탭 시 → `showModalBottomSheet` (DraggableScrollableSheet)

바텀시트 구조:
```
── 핸들 바 ──
"댓글" 타이틀
────────────
댓글 리스트 (ListView, 스크롤)
  [아바타] [이름 bold] [내용] [시간]
  [리플라이 들여쓰기]
────────────
댓글 입력 (하단 고정)
  [TextField] [전송 버튼]
```

### Infinite Scroll 구현

1. `ScrollController` 추가
2. `_scrollController.addListener` → 끝에 도달 시 `_loadMore()`
3. `_loadMore()`: 현재 마지막 포스트의 `createdAt`을 cursor로 전달
4. Provider 변경: `filteredCommunityPostsProvider` → StateNotifier로 변경하여 누적 로드

간단한 방법: `_posts` 리스트를 StatefulWidget에서 관리
```dart
List<CommunityPost> _posts = [];
bool _isLoadingMore = false;
bool _hasMore = true;
String? _cursor;

Future<void> _loadMore() async {
  if (_isLoadingMore || !_hasMore) return;
  _isLoadingMore = true;
  final repo = ref.read(communityRepositoryProvider);
  final filter = ref.read(communityFilterProvider);
  final newPosts = await repo.getPosts(
    category: filter == 'all' ? null : filter,
    cursor: _cursor,
    limit: 20,
  );
  setState(() {
    _posts.addAll(newPosts);
    _cursor = newPosts.isNotEmpty ? newPosts.last.createdAt.toIso8601String() : null;
    _hasMore = newPosts.length >= 20;
    _isLoadingMore = false;
  });
}
```

ScrollController:
```dart
_scrollController.addListener(() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    _loadMore();
  }
});
```

### 더블탭 좋아요 애니메이션

포스트 본문 영역에 `GestureDetector.onDoubleTap`:
```dart
GestureDetector(
  onDoubleTap: () {
    if (!_isLiked) _handleLike();
    // Show heart animation overlay
    setState(() => _showHeartAnimation = true);
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });
  },
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Post content
      Text(post.content, ...),
      // Heart animation
      if (_showHeartAnimation)
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300),
          builder: (context, value, child) => Opacity(
            opacity: value > 0.5 ? 2 - value * 2 : value * 2,
            child: Transform.scale(
              scale: 0.5 + value * 0.5,
              child: Icon(Icons.favorite, size: 80, color: AbbaColors.error),
            ),
          ),
        ),
    ],
  ),
)
```

---

## 변경 2: 마이페이지 신규 생성

### 2-1. 마이페이지 뷰 (my_page_view.dart) — 신규 파일

Settings 탭에서 프로필 섹션을 분리하여 독립 페이지로.

레이아웃:
```
AppBar: "내 기도 정원"

프로필 섹션:
  [아바타 80px] [이름 24pt] [이메일 14pt]
  [127 기도] [14 연속] [23 간증] ← 3열 통계

탭 바 (3개):
  [🙏 내 기도] [✍️ 내 간증] [🔖 저장됨]

탭 콘텐츠:
  내 기도: 날짜별 기도 목록 (PrayerRepository.getPrayersByMonth)
  내 간증: 내가 쓴 커뮤니티 글 목록
  저장됨: 북마크한 글 목록 (savedPostsProvider)
```

### 2-2. 탭바 변경 (abba_tab_bar.dart)

현재 4탭: Home | Calendar | Community | Settings
변경 5탭: Home | Calendar | Community | MyPage | Settings

또는: Settings의 프로필 섹션을 마이페이지로 이동하고 Settings에서 프로필 제거.

더 나은 방법: 4탭 유지, Settings 내에 "내 기도 정원" 버튼 추가 → 마이페이지로 이동.

### 2-3. 라우터 추가

```dart
GoRoute(path: '/settings/my-page', builder: MyPageView),
```

### 2-4. PrayerRepository에 getUserPrayers 추가 (이미 getPrayersByMonth 있음)

Community에서 "내 간증" 필터:
```dart
final myPostsProvider = FutureProvider<List<CommunityPost>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  final userId = ref.watch(authStateProvider).user?.id ?? '';
  // 서비스에서 userId 기반 필터 지원 필요
  // 현재 mock에서는 전체 중 userId 매칭으로 필터
});
```

---

## 변경 3: ARB 키 추가

```
seeMore: "더 보기" / "See more"
seeAllComments: "댓글 {count}개 모두 보기" / "View all {count} comments"
likedBy: "{name} 외 {count}명이 좋아합니다" / "{name} and {count} others liked this"
commentsTitle: "댓글" / "Comments"
myPageTitle: "내 기도 정원" / "My Prayer Garden"
myPrayers: "내 기도" / "My Prayers"
myTestimonies: "내 간증" / "My Testimonies"
savedPosts: "저장됨" / "Saved"
totalPrayersCount: "기도" / "Prayers"
streakCount: "연속" / "Streak"
testimoniesCount: "간증" / "Testimonies"
```

5개 언어 모두.

---

## 완료 조건

- [ ] `flutter analyze` — 0 에러
- [ ] `flutter test` — 전체 통과
- [ ] 커뮤니티: 인스타그램 스타일 풀 너비 피드
- [ ] 댓글: 바텀시트로 열림
- [ ] 더블탭 좋아요: ❤️ 애니메이션
- [ ] Infinite scroll: 20개씩 로드
- [ ] 마이페이지: 내 기도 / 내 간증 / 저장됨 탭
- [ ] Settings에서 마이페이지 진입 가능
