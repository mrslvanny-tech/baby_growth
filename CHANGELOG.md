# Changelog

All notable changes to 小芽成长 are documented here.

The project uses semantic versioning for product releases:

- `MAJOR`: incompatible data model or product contract changes.
- `MINOR`: new user-visible capabilities that preserve existing data.
- `PATCH`: bug fixes, copy updates, visual polish, and compatibility fixes.

## [1.0.0] - 2026-05-30

### Added

- V1 native SwiftUI product blueprint implementation.
- Local-first baby profile and milestone record models.
- Growth tree stage and decoration calculation core.
- Onboarding, home, record flow, history, settings, and share card source screens.
- XcodeGen project configuration for maintainable Xcode project generation.
- Initial product, design, and technical documentation set.
- Imported Inspire Prototype v1.9 notes and aligned V1 native scope with prototype states.

## [1.0.0-rc.1] - 2026-05-31

### Added

- Unified XiaoYa design system and native iOS UI polish.
- 36-stage growth tree assets and animated `GrowthTreeView`.
- Lightweight forest copy for record counts beyond one completed tree.
- iCloud private database configuration for syncing baby profile and milestone text data across the user's own devices.
- Settings iCloud status section with system settings guidance.
- Milestone deletion flow with confirmation copy for iCloud-synced deletion.
- README for GitHub and release handoff.
- UI tests for primary record flow, iCloud settings visibility, and delete confirmation.

### Changed

- Simplified onboarding, record editing, and settings display/edit states.
- Removed mood entry from the V1 record editor.
- Updated V1 product, technical, design, test, and iCloud boundary documentation.

### Notes

- V1 does not sync photos through iCloud; image sync is reserved for a later version.
- App Store upload still requires Apple Developer iCloud/CloudKit capability configuration for `iCloud.com.xiaoyagrowth.app`.
