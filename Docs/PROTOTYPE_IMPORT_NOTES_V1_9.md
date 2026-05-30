# Inspire Prototype Import Notes - v1.9

## Source

- Prototype name: 小芽成长原型 v1.9
- Download URL: `https://cdn-tos-cn.bytedance.net/obj/tiktok-web-ai-cn/1994e64d97384b9d149d6b79340e8179bde06deeed9f30a99dbf319b1fc6b629.tar.gz`
- Local import path used during implementation: `/private/tmp/xiaoya-prototype-import`

## Readme Summary

The package contains a React prototype under `prototype/codebase`, generation notes under `prototype/notebook`, and 12 screenshot states in `captures.json`.

Key routes:

- `/onboarding`
- `/home`
- `/settings`
- `/templates?view=list`
- `/record`
- `/share`
- `/measurements`

## Capture States Reviewed

- Onboarding profile creation.
- Home time tag in three modes.
- Settings edit page.
- Share card overlay.
- Template list.
- Save success tree bud animation.
- Water menu, water input, water saved pulse, water history list.

## Decisions Applied To Native V1

- Keep the clean home page with no large profile header.
- Use a centered tappable time tag.
- Keep the settings page as an independent screen.
- Use card-style template selection with search.
- Use a full-tree visual with glowing buds/decorations.
- Preserve one-time share card presentation after save.

## Decisions Deferred

- Water/nutrient menu and breathing pulse are documented for V1.1.
- Island map template selection is documented for V2.
- Measurements page and fun height/weight cards remain P1/V2.

## Implementation Notes

The React prototype uses route query params such as `action=save_success` and `show_card=true`. The native app deliberately does not persist route-like trigger flags. It uses `SaveSuccessState` in memory so the share card cannot loop after navigation or app restart.
