import Foundation

public enum ICloudSyncAvailability: Equatable, Sendable {
    case available
    case noAccount
    case restricted
    case temporarilyUnavailable
    case localOnly
    case unknown
}

public struct ICloudSyncStatusCopy: Equatable, Sendable {
    public var title: String
    public var message: String
    public var actionTitle: String?

    public init(title: String, message: String, actionTitle: String?) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
    }
}

public enum ICloudSyncStatusCopyBuilder {
    public static func copy(for availability: ICloudSyncAvailability) -> ICloudSyncStatusCopy {
        switch availability {
        case .available:
            return ICloudSyncStatusCopy(
                title: "iCloud 同步已开启",
                message: "成长记录会保存在你的 iCloud，并在你的设备之间同步。",
                actionTitle: nil
            )
        case .noAccount:
            return ICloudSyncStatusCopy(
                title: "iCloud 未登录",
                message: "请在系统设置中登录 Apple ID，以便同步成长记录。",
                actionTitle: "打开系统设置"
            )
        case .restricted:
            return ICloudSyncStatusCopy(
                title: "iCloud 暂不可用",
                message: "当前设备的 iCloud 功能受限，请检查系统设置。",
                actionTitle: "打开系统设置"
            )
        case .temporarilyUnavailable:
            return ICloudSyncStatusCopy(
                title: "iCloud 暂不可用",
                message: "请检查网络或稍后再试。你仍然可以继续在本机记录。",
                actionTitle: "打开系统设置"
            )
        case .localOnly:
            return ICloudSyncStatusCopy(
                title: "当前仅保存在本机",
                message: "你仍然可以正常记录，开启 iCloud 后会同步。",
                actionTitle: "打开系统设置"
            )
        case .unknown:
            return ICloudSyncStatusCopy(
                title: "正在检查 iCloud",
                message: "小芽成长会在 iCloud 可用时自动同步你的成长记录。",
                actionTitle: nil
            )
        }
    }
}
