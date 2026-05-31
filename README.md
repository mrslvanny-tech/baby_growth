# 小芽成长

小芽成长是一个原生 iOS 宝宝成长纪念 App。它把宝宝的每一次成长记录转化为一棵逐渐长大的小树，让用户完成“记录成长瞬间 -> 点亮叶片 -> 小树成长 -> 生成纪念卡分享”的核心闭环。

## 产品定位

- 私密宝宝成长纪念册。
- 轻游戏化成长树表达。
- 不做医学评估、不判断发育快慢、不制造育儿焦虑。
- V1 只支持一个宝宝。

## V1 核心能力

- Onboarding 创建宝宝档案。
- 首页展示宝宝时间标签和 36 阶段成长树。
- 记录成长节点，保存后小树自然过渡生长。
- 历史记录和成长详情。
- 纪念卡预览、系统分享、保存到相册。
- 设置页编辑宝宝资料。
- iCloud 私有数据库同步文字数据。

## iCloud 同步范围

V1 使用用户自己的 iCloud 私有数据库同步：

- 宝宝昵称、出生日期、头像标识。
- 成长记录标题、日期、描述、分类、模板标识。
- 小树进度由成长记录数量实时计算，不单独存储。

V1 暂不同步图片。图片跨设备同步进入后续版本设计。

如果用户未登录 iCloud 或关闭 iCloud 权限，App 仍可本地使用；设置页会展示 iCloud 状态和系统设置引导。

## 技术栈

- SwiftUI
- SwiftData
- CloudKit
- XiaoyaGrowthCore Swift Package
- XcodeGen
- XCTest / XCUITest

最低系统版本：iOS 17。

## 工程结构

```text
App/
  Models/                 SwiftData 持久化模型
  Views/                  SwiftUI 页面与组件
  XiaoyaGrowthApp/         App 入口、entitlements
Sources/XiaoyaGrowthCore/  可测试核心逻辑
Tests/                     Core 单元测试和 UI 测试
Docs/                      产品、设计、技术与测试文档
project.yml                XcodeGen 工程配置
```

## 本地开发

安装 XcodeGen：

```bash
brew install xcodegen
```

生成 Xcode 工程：

```bash
xcodegen generate
```

运行核心测试：

```bash
swift test
```

运行完整 Xcode 测试：

```bash
xcodebuild test \
  -project XiaoyaGrowth.xcodeproj \
  -scheme XiaoyaGrowth \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'
```

## iCloud 配置说明

CloudKit Container：

```text
iCloud.com.xiaoyagrowth.app
```

Bundle ID：

```text
com.xiaoyagrowth.app
```

真机和上架前，需要在 Apple Developer 后台为 App ID 开启 iCloud / CloudKit，并确认 Xcode Signing Team 正确。

UI 测试会使用内存数据库，并关闭 CloudKit，避免测试污染真实 iCloud 数据。

App Store 上传交接见 [Docs/APP_STORE_UPLOAD_HANDOFF.md](Docs/APP_STORE_UPLOAD_HANDOFF.md)。

## 文档

- [产品文档](Docs/PRODUCT_PRD_V1.md)
- [设计规范](Docs/DESIGN_SPEC_V1.md)
- [技术方案](Docs/TECHNICAL_DESIGN_V1.md)
- [测试计划](Docs/TEST_PLAN_V1.md)
- [iCloud 同步与产品边界](Docs/ICLOUD_SYNC_AND_PRODUCT_BOUNDARY_V1.md)

## 当前边界

V1 不实现：

- 家庭共享。
- 多宝宝。
- 图片 iCloud 同步。
- 最近删除。
- 完整森林页。
- 付费主题卡。

这些能力需要独立设计和测试后再进入后续版本。
