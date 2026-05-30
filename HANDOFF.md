# 小芽成长项目交接说明

## 现在这个文件夹是什么

这是“小芽成长”V1 原生 iOS App 的开工工程包，包含：

- SwiftUI App 源码。
- SwiftData 本地模型。
- 可复用核心业务逻辑模块。
- XCTest 测试骨架。
- XcodeGen 工程配置。
- 产品、设计、技术、版本治理、上架检查文档。
- Inspire Prototype v1.9 导入记录。

当前路径：

```text
/Users/bytedance/Desktop/小芽成长
```

## 换电脑时怎么带走

推荐直接压缩整个文件夹：

```bash
cd /Users/bytedance/Desktop
tar -czf 小芽成长-handoff.tar.gz 小芽成长
```

在新电脑解压：

```bash
tar -xzf 小芽成长-handoff.tar.gz
cd 小芽成长
```

如果用 Git 管理，建议新电脑上初始化仓库后提交第一版：

```bash
git init
git add .
git commit -m "chore: bootstrap xiaoya growth v1"
```

## 新电脑需要安装什么

### 必需

1. 完整 Xcode。
2. Homebrew。
3. XcodeGen。

安装 XcodeGen：

```bash
brew install xcodegen
```

生成 Xcode 工程：

```bash
xcodegen generate
```

打开：

```bash
open XiaoyaGrowth.xcodeproj
```

### Xcode 版本建议

如果新电脑是 macOS 15.x，优先安装 Xcode 16.4。

如果新电脑是 macOS 26.2 或更高，可以从 App Store 安装最新版 Xcode。

当前电脑情况：

- macOS 15.7。
- 没有完整 `/Applications/Xcode.app`。
- App Store 当前 Xcode 26.5 要求 macOS 26.2，当前电脑无法直接装最新版。
- 已安装 Homebrew 工具：`xcodegen`、`xcodes`、`mas`，并正在/已尝试安装 `aria2` 用于加速 Xcode 下载。

## 新电脑继续开发的推荐步骤

1. 解压项目文件夹。
2. 安装完整 Xcode。
3. 安装 XcodeGen。
4. 执行：

```bash
xcodegen generate
```

5. 打开 `XiaoyaGrowth.xcodeproj`。
6. 选择 `XiaoyaGrowth` scheme。
7. 选择 iPhone 模拟器。
8. 运行测试：

```bash
xcodebuild test -scheme XiaoyaGrowth -destination 'platform=iOS Simulator,name=iPhone 15'
```

9. 跑 App，优先检查：

- 首次建档。
- 首页时间标签切换。
- 模板选择。
- 保存成长记录。
- 首页树状态刷新。
- 自动展示一次纪念卡。
- 设置页修改昵称和生日。
- 历史记录详情。

## 当前已完成

- V1 范围确认：核心闭环优先。
- SwiftUI 页面源码已落地。
- Core 纯函数已落地。
- 测试文件已写好。
- `project.yml` 已生成 Xcode 工程。
- Inspire Prototype v1.9 已下载、解压、阅读，并形成导入记录。
- 临时原型解压目录已清理。
- 产品文档、设计文档、技术文档已写入 `Docs/`。
- 版本管理和上架检查清单已写入根目录。

## 当前未完成/需新电脑继续

- 因当前电脑没有完整 Xcode，未能真正运行 iOS Simulator。
- 因当前 Command Line Tools 的 SwiftPM/SDK 不匹配，`swift test` 当前无法执行。
- App Icon、正式插画、截图、签名 Team ID、App Store Connect 信息还未配置。
- PhotosPicker 当前只保留入口和占位标识，上架前需要补真实图片持久化策略。

## 项目结构速览

```text
App/
  XiaoyaGrowthApp/        App 入口
  Models/                 SwiftData 持久化模型
  Views/                  SwiftUI 页面和组件
  Domain/                 App 路由与页面状态
  Repositories/           默认数据

Sources/XiaoyaGrowthCore/
  Models.swift
  TimeCalculator.swift
  TreeStateCalculator.swift
  ShareCardCopyBuilder.swift
  MilestoneTemplates.swift

Tests/XiaoyaGrowthCoreTests/
  TimeCalculatorTests.swift
  TreeStateCalculatorTests.swift
  ShareCardCopyBuilderTests.swift

Docs/
  PRODUCT_PRD_V1.md
  DESIGN_SPEC_V1.md
  TECHNICAL_DESIGN_V1.md
  PROTOTYPE_IMPORT_NOTES_V1_9.md
  VERSIONING_AND_CHANGE_MANAGEMENT.md
  ADR-0001-native-swiftui-local-first.md
```

## 最重要的文档阅读顺序

1. `HANDOFF.md`
2. `Docs/PRODUCT_PRD_V1.md`
3. `Docs/DESIGN_SPEC_V1.md`
4. `Docs/TECHNICAL_DESIGN_V1.md`
5. `Docs/PROTOTYPE_IMPORT_NOTES_V1_9.md`
6. `RELEASE_CHECKLIST.md`
7. `CHANGELOG.md`

## 后续做得更好的建议

- 尽快把这个文件夹放进 Git，并以 `main` 作为稳定分支。
- 第一阶段先修到能在 Xcode 真机/模拟器跑通，不急着加新功能。
- 每次改动都写 `CHANGELOG.md`，涉及架构选择就补 ADR。
- 上架前优先打磨首页大树、分享卡、App Icon 和截图，这几个决定商业第一眼。
- V1.1 再做“补充养料/浇水闭环”，不要在 V1 首发前扩大范围。
- V2 再做 Widget/岛屿地图/月龄总结，不要影响 V1 上架节奏。
