# App Store Release Checklist

## Version Gate

- Confirm `VERSION`, `MARKETING_VERSION`, and `CURRENT_PROJECT_VERSION` are updated.
- Add a dated entry to `CHANGELOG.md`.
- Confirm migration notes exist for any SwiftData model changes.
- Confirm privacy copy is still accurate.

## Product Gate

- New user can complete onboarding in under 30 seconds.
- User can save one milestone and see the tree update in under 60 seconds.
- Share card has no overflowing text on small iPhone screens.
- No medical, diagnostic, “advanced/delayed”, or anxiety-inducing copy appears in product UI.

## Engineering Gate

- Run `xcodegen generate`.
- Open `XiaoyaGrowth.xcodeproj` with full Xcode.
- Run the `XiaoyaGrowth` scheme tests on an iPhone simulator.
- Run the app on the smallest supported iPhone simulator.
- Run the app on a large iPhone simulator.
- Verify light mode, dark mode, and larger accessibility text.
- Archive with Release configuration.

## App Store Gate

- App icon and screenshots are final.
- App privacy nutrition labels match local-only storage behavior.
- Photo permission purpose string is reviewed.
- Support URL and privacy URL are ready.
- Build number is higher than the previous App Store Connect build.
