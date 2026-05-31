# SwiftData CloudKit Migration Notes V1

日期：2026-05-31

## 背景

V1 从本地 SwiftData 存储升级为 SwiftData + CloudKit 私有数据库同步。

同步目标：

- `BabyProfile`
- `MilestoneRecord`

不同步：

- 本机相册图片文件。
- 家庭共享权限。
- 多宝宝关系。

## 模型调整

为了符合 SwiftData + CloudKit 的约束，持久化模型做了以下调整：

- 移除 `@Attribute(.unique)`。
- `id` 保留为业务 UUID 字段。
- 必填属性提供稳定默认值。
- 树状态继续由记录数量派生，不落库。

## 迁移风险

开启 CloudKit 后，需要在真机上验证旧本地数据进入同步容器时是否保留。

重点验证：

- 已有宝宝资料不丢失。
- 已有成长记录不丢失。
- 首页成长树数量与迁移后的记录数量一致。
- 设置页 iCloud 状态展示正常。

如果真机验证发现本地 store 无法自动迁移到 CloudKit store，需要增加一次性导入流程：

```text
读取旧本地 store
-> 写入 CloudKit-enabled store
-> 标记迁移完成
-> 后续只使用 CloudKit-enabled store
```

当前 V1 代码路径不实现单独迁移 UI。
