# Versioning and Change Management

## Version Strategy

小芽成长 uses semantic versioning for product releases.

- `1.0.x`: V1 launch stabilization, bug fixes, copy polish, visual polish.
- `1.1.x`: Nutrient / watering loop if V1 retention needs more light daily interaction.
- `1.2.x`: iCloud sync or share card visual upgrades, depending on launch feedback.
- `2.0.x`: Widget and summary cards.
- `3.0.x`: Watch, Live Activity, commercial themes, and larger paid exports.

## Change Rules

- Every user-visible change must update `CHANGELOG.md`.
- Every architecture decision that affects future work must add an ADR under `Docs/`.
- Every SwiftData schema change must include a migration note before release.
- P2/P3 work cannot enter V1 without explicitly updating the product scope document.

## Branch and Release Proposal

- `main`: release-ready code only.
- `develop`: integration branch for the next minor version.
- `feature/<version>-<topic>`: feature work.
- `release/<version>`: stabilization branch before TestFlight/App Store submission.
- Tags: `v1.0.0`, `v1.0.1`, etc.

## Definition of Done

- Tests pass in Xcode.
- Release checklist is complete.
- Product, design, and technical docs are updated.
- App Store privacy and permission text still match implementation.
