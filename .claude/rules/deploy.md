---
paths: ["apps/**", "**/fastlane/**"]
---

# Pre-Deployment AI Checklist

- [ ] No service_role key in `.env`
- [ ] RLS scoping works correctly
- [ ] Sensitive data filter applied in Sentry
- [ ] Confirm `AppEnvironment` is set to prod
- [ ] Release: `--obfuscate --split-debug-info`

## Recommended pub.dev Packages (use directly, no wrapping needed)
cached_network_image, url_launcher, flutter_slidable, infinite_scroll_pagination,
fl_chart, shimmer, image_picker, webview_flutter, share_plus, geolocator, local_auth
