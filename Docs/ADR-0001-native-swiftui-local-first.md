# ADR-0001: Native SwiftUI and Local-First V1

## Status

Accepted.

## Context

小芽成长 V1 needs to become a commercial iPhone app that feels native to Apple platforms and can later grow into Widget, Watch, iCloud, and paid themes. The V1 product scope is intentionally small: baby profile, growth tree, milestone recording, history, and share card.

## Decision

Use native SwiftUI for the app shell and SwiftData for local persistence. Keep core product logic in a separate `XiaoyaGrowthCore` module with pure functions and XCTest coverage.

## Consequences

- The UI can use iOS-native controls such as DatePicker, PhotosPicker, sheets, ShareLink, and system dynamic type.
- The domain logic can be reused by Widget and Watch targets later.
- SwiftData model migrations must be managed carefully before commercial release.
- A full Xcode installation is required for simulator, archive, signing, and App Store release work.
