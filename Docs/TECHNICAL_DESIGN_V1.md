# 小芽成长 V1 技术方案

## 1. 技术栈

- SwiftUI：应用 UI。
- SwiftData：本地持久化。
- XiaoyaGrowthCore：纯业务逻辑模块。
- PhotosUI：照片选择入口。
- ShareLink：系统分享。
- XCTest：核心逻辑测试。
- XcodeGen：生成和维护 Xcode 工程。

最低系统：iOS 17。

## 2. 模块划分

```text
Sources/XiaoyaGrowthCore
├── Models.swift
├── TimeCalculator.swift
├── TreeStateCalculator.swift
├── ShareCardCopyBuilder.swift
└── MilestoneTemplates.swift

App
├── XiaoyaGrowthApp
├── Models
├── Domain
├── Repositories
└── Views

Tests/XiaoyaGrowthCoreTests
```

原则：

- 业务计算放在 Core，避免和 SwiftUI/SwiftData 绑定。
- SwiftData 模型只保存事实数据。
- `TreeState` 是派生状态，不落库。
- 分享卡自动弹出状态只存在于内存，不持久化。

## 3. 数据模型

### BabyProfile

保存宝宝基础资料：

- `id`
- `nickname`
- `birthDate`
- `gender`
- `avatarLocalIdentifier`
- `createdAt`
- `updatedAt`

### MilestoneRecord

保存成长记录事实数据：

- `id`
- `babyId`
- `templateId`
- `category`
- `title`
- `note`
- `occurredAt`
- `mediaLocalIdentifiers`
- `moodTags`
- `visualElementType`
- `createdAt`
- `updatedAt`

### TreeState

不落库，由 `MilestoneRecord` 实时计算：

- `stage`
- `recordCount`
- `decorations`

## 4. 核心函数

- `daysSinceBirth(birthDate:today:calendar:)`
- `monthAgeText(birthDate:today:calendar:)`
- `nextMonthCountdownText(birthDate:today:calendar:)`
- `timeTagText(mode:profile:today:calendar:)`
- `treeStage(recordCount:)`
- `treeDecorations(records:)`
- `shareCardText(profile:record:calendar:)`

## 5. 工程生成

安装 XcodeGen 后执行：

```bash
xcodegen generate
```

生成：

```text
XiaoyaGrowth.xcodeproj
```

打开工程：

```text
XiaoyaGrowth.xcodeproj
```

Scheme：

```text
XiaoyaGrowth
```

## 6. 测试策略

Core 测试覆盖：

- 出生当天为第 1 天。
- 出生天数包含出生当天。
- 月龄使用 Calendar 计算，不按 30 天粗算。
- 下个月龄倒计时使用自然月。
- 树阶段阈值。
- 装饰类别映射。
- 同类装饰溢出聚合。
- 分享卡文案。

完整验证命令：

```bash
xcodebuild test -scheme XiaoyaGrowth -destination 'platform=iOS Simulator,name=iPhone 15'
```

当前机器如果只有 Command Line Tools，需要先安装完整 Xcode 并切换：

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

## 7. 商业化可维护性

- 版本号统一在 `VERSION`、`project.yml`、`CHANGELOG.md` 维护。
- 架构决策写入 `Docs/ADR-*.md`。
- 上架前执行 `RELEASE_CHECKLIST.md`。
- 每次 SwiftData schema 变更必须写迁移说明。
- P2/P3 需求不能直接进主干，必须先更新产品文档和版本计划。

## 8. 后续演进接口

V1 预留但不实现：

- Widget Snapshot：未来从 Core 派生只读快照。
- iCloud：未来替换/扩展 Repository 层。
- NutrientRecord：V1.1 养料闭环可新增模型，也可复用轻量记录逻辑。
- GrowthMetricRecord：身高体重趣味卡后续独立实现。

## 9. Prototype Import

Inspire Prototype v1.9 has been imported and reviewed. See `Docs/PROTOTYPE_IMPORT_NOTES_V1_9.md`.

Native V1 intentionally avoids the prototype's URL-query driven side effects. Save success and share preview triggers are represented by in-memory SwiftUI state to prevent repeated share-card presentation.
