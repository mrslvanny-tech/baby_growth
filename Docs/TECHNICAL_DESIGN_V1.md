# 小芽成长 V1 技术方案

## 1. 技术栈

- SwiftUI：应用 UI。
- SwiftData：本地持久化和模型管理。
- CloudKit：用户自己的设备之间同步文字数据。
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
├── GrowthForestState.swift
├── ICloudSyncStatus.swift
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
- `GrowthForestState(recordCount:)`
- `ICloudSyncStatusCopyBuilder.copy(for:)`
- `shareCardText(profile:record:calendar:)`

### GrowthTreeView 阶段映射

首页 `GrowthTreeView` 的主体不再由代码重新绘制树，而是使用 36 张 PNG：

```text
tree_stage_01 ... tree_stage_36
```

映射规则：

```swift
if recordCount <= 0 {
    imageName = "tree_stage_01"
} else if recordCount >= 35 {
    imageName = "tree_stage_36"
} else {
    imageName = String(format: "tree_stage_%02d", recordCount + 1)
}
```

当前 V1 单棵树容量为 35 条记录。`recordCount >= 35` 后，主树保持 `tree_stage_36`。

### 多树扩展公式

未来支持几百、几千条记录时，不继续增加单棵树图片数量，而是按 35 条记录生成一棵树：

```swift
let recordsPerTree = 35
let completedTreeCount = recordCount / recordsPerTree
let activeTreeProgress = recordCount % recordsPerTree
let activeTreeImageIndex = min(max(activeTreeProgress + 1, 1), 36)
```

边界说明：

- `recordCount == 0`：0 棵完成树，当前树 `tree_stage_01`。
- `recordCount == 35`：1 棵完成树，当前主视觉可显示满树 `tree_stage_36`。
- `recordCount == 36`：1 棵完成树，第 2 棵树进入 `tree_stage_02`。
- `recordCount == 70`：2 棵完成树，当前主视觉可显示第 2 棵满树或等待第 3 棵发芽。
- `recordCount == 71`：2 棵完成树，第 3 棵树进入 `tree_stage_02`。

V1 暂不新增森林数据模型。森林状态仍可由 `MilestoneRecord` 数量派生，不落库。

### GrowthTreeView 动画职责

`GrowthTreeView` 只负责视觉表达，不修改业务逻辑和数据模型：

- 根据 `recordCount` 计算目标图片名。
- 图片变化时同时叠加旧图和新图。
- 旧图淡出并缩小，新图淡入并轻微放大。
- 新图出现时触发一次轻微 green glow。
- 非 Reduce Motion 状态下展示少量 leaf/sparkle 粒子。
- Reduce Motion 开启时只保留 opacity 淡入淡出。
- 分享卡导出图片时可关闭动画，直接渲染最终状态。

### UI/交互收敛

- 首页不保留下方历史记录卡片；历史入口只通过左上角时光轴按钮进入。
- `RecordEditorView` 不再展示心情选择器，保存时 `moodTags` 写入空数组。
- `RecordEditorView` 分类选择器过滤 `.custom`，避免无完整流程的自定义分类入口。
- 新手引导页不展示头像切换和顶部树模块，创建档案时继续使用默认头像标识。
- App 内日期选择统一为 `.wheel` DatePicker。
- 设置页展示 iCloud 同步状态；App 内不提供 iCloud 开关。
- 历史详情支持删除记录，删除前展示同步删除确认。

### iCloud 同步

V1 使用 SwiftData + CloudKit 私有数据库：

```swift
ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: isUITesting,
    cloudKitDatabase: isUITesting ? .none : .private("iCloud.com.xiaoyagrowth.app")
)
```

同步范围：

- `BabyProfile`
- `MilestoneRecord`

不同步：

- 本机相册图片文件。
- 家庭共享权限。
- 多宝宝关系。

工程配置：

- App target 使用 `App/XiaoyaGrowthApp/XiaoyaGrowthApp.entitlements`。
- CloudKit Container 为 `iCloud.com.xiaoyagrowth.app`。
- UI 测试使用内存数据库并关闭 CloudKit。

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
- 图片 iCloud 同步：V1.1 需要重新设计图片存储和迁移策略。
- NutrientRecord：V1.1 养料闭环可新增模型，也可复用轻量记录逻辑。
- GrowthMetricRecord：身高体重趣味卡后续独立实现。
- Forest Snapshot：未来从记录数量派生多棵树状态，用于展示小森林，不需要新增事实数据模型。

## 9. Prototype Import

Inspire Prototype v1.9 has been imported and reviewed. See `Docs/PROTOTYPE_IMPORT_NOTES_V1_9.md`.

Native V1 intentionally avoids the prototype's URL-query driven side effects. Save success and share preview triggers are represented by in-memory SwiftUI state to prevent repeated share-card presentation.
