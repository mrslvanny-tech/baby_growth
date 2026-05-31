import XCTest
@testable import XiaoyaGrowthCore

final class ICloudSyncStatusTests: XCTestCase {
    func testAvailableStatusExplainsAutomaticSync() {
        let copy = ICloudSyncStatusCopyBuilder.copy(for: .available)

        XCTAssertEqual(copy.title, "iCloud 同步已开启")
        XCTAssertEqual(copy.message, "成长记录会保存在你的 iCloud，并在你的设备之间同步。")
        XCTAssertNil(copy.actionTitle)
    }

    func testNoAccountStatusGuidesUserToSystemSettings() {
        let copy = ICloudSyncStatusCopyBuilder.copy(for: .noAccount)

        XCTAssertEqual(copy.title, "iCloud 未登录")
        XCTAssertEqual(copy.message, "请在系统设置中登录 Apple ID，以便同步成长记录。")
        XCTAssertEqual(copy.actionTitle, "打开系统设置")
    }

    func testLocalOnlyStatusKeepsRecordingAvailable() {
        let copy = ICloudSyncStatusCopyBuilder.copy(for: .localOnly)

        XCTAssertEqual(copy.title, "当前仅保存在本机")
        XCTAssertEqual(copy.message, "你仍然可以正常记录，开启 iCloud 后会同步。")
        XCTAssertEqual(copy.actionTitle, "打开系统设置")
    }
}
