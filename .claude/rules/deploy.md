---
paths: ["apps/**", "**/fastlane/**"]
---

# 배포 전 AI 체크리스트

- [ ] `.env`에 service_role 키 없는지
- [ ] RLS 스코핑 정상 작동하는지
- [ ] Sentry에 민감 정보 필터 적용됐는지
- [ ] `AppEnvironment`이 prod인지 확인
- [ ] 릴리스: `--obfuscate --split-debug-info`

## 추천 pub.dev 패키지 (직접 사용, 래핑 불필요)
cached_network_image, url_launcher, flutter_slidable, infinite_scroll_pagination,
fl_chart, shimmer, image_picker, webview_flutter, share_plus, geolocator, local_auth
