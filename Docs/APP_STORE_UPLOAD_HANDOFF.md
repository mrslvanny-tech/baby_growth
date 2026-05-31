# 小芽成长 App Store 上传交接

日期：2026-05-31

## 当前状态

代码、资源、文档和测试已经整理到 V1 release candidate 状态。

已验证：

- `swift test`
- `xcodebuild test -project XiaoyaGrowth.xcodeproj -scheme XiaoyaGrowth -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'`
- `xcodebuild build -project XiaoyaGrowth.xcodeproj -scheme XiaoyaGrowth -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO`

Release 真机编译已通过。App Store Archive 当前被签名能力阻塞。

## 当前阻塞

当前 Apple 账号环境是 Personal Team。Personal Team 不支持 iCloud capability，因此无法生成带 CloudKit entitlement 的 App Store Archive。

Archive 报错类型：

```text
Personal development teams do not support the iCloud capability.
Provisioning profile doesn't include the iCloud capability.
Provisioning profile doesn't support iCloud.com.xiaoyagrowth.app iCloud Container.
```

这不是代码编译错误，而是 Apple Developer 签名和能力配置问题。

## App Store 上传前必须完成

### 1. Apple Developer Program

需要使用付费 Apple Developer Program 团队。

### 2. App Identifier

在 Apple Developer 后台确认 App ID：

```text
com.xiaoyagrowth.app
```

开启能力：

- iCloud
- CloudKit

### 3. CloudKit Container

创建或绑定 Container：

```text
iCloud.com.xiaoyagrowth.app
```

确保该 Container 绑定到 App ID `com.xiaoyagrowth.app`。

### 4. Xcode Signing

打开：

```text
XiaoyaGrowth.xcodeproj
```

选择：

```text
Target: XiaoyaGrowthApp
Signing & Capabilities
Team: 付费 Apple Developer Team
```

确认 Capabilities 中存在：

- iCloud
- CloudKit
- Container: `iCloud.com.xiaoyagrowth.app`

### 5. Archive

在 Xcode 中执行：

```text
Product -> Archive
```

Archive 成功后：

```text
Distribute App -> App Store Connect -> Upload
```

## 命令行验证

开发者账号配置完成后，也可以用命令行验证：

```bash
xcodebuild archive \
  -project XiaoyaGrowth.xcodeproj \
  -scheme XiaoyaGrowth \
  -destination 'generic/platform=iOS' \
  -archivePath build/XiaoyaGrowth.xcarchive \
  -allowProvisioningUpdates
```

## App Store Connect 信息

### App 隐私

V1 数据策略：

- 宝宝资料和成长记录文字数据会同步到用户自己的 iCloud 私有数据库。
- App 不上传数据到自有服务器。
- V1 不同步图片。
- 保存纪念卡需要“添加到相册”权限。
- 不做第三方追踪。
- 不做医学评估。

### 权限文案

当前相册写入权限：

```text
小芽成长需要添加纪念卡图片到系统相册。
```

### 版本

当前版本配置：

```text
MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
Bundle ID = com.xiaoyagrowth.app
CloudKit Container = iCloud.com.xiaoyagrowth.app
```

如果 App Store Connect 已经上传过 Build 1，需要把 `CURRENT_PROJECT_VERSION` 提升到更高数字。

## 上传前人工检查

- 真机登录 iCloud 后，新增记录能同步到同 Apple ID 的另一台设备。
- 未登录 iCloud 时，App 仍能本地创建宝宝资料和新增记录。
- 设置页 iCloud 状态文案正确。
- 删除记录前有确认弹窗。
- 纪念卡分享和保存图片可用。
- App Store 截图、隐私 URL、支持 URL 已准备。
