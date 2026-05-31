import XCTest

final class XiaoyaGrowthUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

    func testPrimaryGrowthRecordJourneyClosesEveryScreen() {
        app.buttons["开始记录成长"].tap()
        XCTAssertTrue(app.buttons["记录新成长"].waitForExistence(timeout: 4))

        app.buttons["记录新成长"].tap()
        XCTAssertTrue(app.buttons["第一次抬头很稳"].waitForExistence(timeout: 4))

        app.buttons["第一次抬头很稳"].tap()
        XCTAssertTrue(app.navigationBars["编辑记录"].waitForExistence(timeout: 4))

        app.buttons["保存成长记录"].tap()
        XCTAssertTrue(app.navigationBars["纪念卡"].waitForExistence(timeout: 6))
        XCTAssertTrue(app.buttons["分享给家人"].exists)
        XCTAssertTrue(app.buttons["保存图片"].exists)

        app.buttons["稍后再说"].tap()
        XCTAssertTrue(app.buttons["记录新成长"].waitForExistence(timeout: 4))

        app.buttons["查看历史记录"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["第一次抬头很稳"].waitForExistence(timeout: 4))

        app.staticTexts["第一次抬头很稳"].tap()
        XCTAssertTrue(app.navigationBars["成长详情"].waitForExistence(timeout: 4))

        app.buttons["生成纪念卡"].tap()
        XCTAssertTrue(app.navigationBars["纪念卡"].waitForExistence(timeout: 4))
        app.buttons["完成"].tap()
        XCTAssertTrue(app.navigationBars["成长详情"].waitForExistence(timeout: 4))
    }

    func testSettingsShowsICloudSyncStatus() {
        app.buttons["开始记录成长"].tap()
        XCTAssertTrue(app.buttons["记录新成长"].waitForExistence(timeout: 4))

        app.buttons["打开设置"].tap()
        XCTAssertTrue(app.navigationBars["设置"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["iCloud 同步"].waitForExistence(timeout: 4))
    }

    func testDeletingRecordRequiresConfirmationAndUpdatesHistory() {
        app.buttons["开始记录成长"].tap()
        XCTAssertTrue(app.buttons["记录新成长"].waitForExistence(timeout: 4))

        app.buttons["记录新成长"].tap()
        XCTAssertTrue(app.buttons["第一次抬头很稳"].waitForExistence(timeout: 4))
        app.buttons["第一次抬头很稳"].tap()
        XCTAssertTrue(app.navigationBars["编辑记录"].waitForExistence(timeout: 4))
        app.buttons["保存成长记录"].tap()

        XCTAssertTrue(app.navigationBars["纪念卡"].waitForExistence(timeout: 6))
        app.buttons["稍后再说"].tap()
        XCTAssertTrue(app.buttons["记录新成长"].waitForExistence(timeout: 4))

        app.buttons["查看历史记录"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["第一次抬头很稳"].waitForExistence(timeout: 4))
        app.staticTexts["第一次抬头很稳"].tap()
        XCTAssertTrue(app.navigationBars["成长详情"].waitForExistence(timeout: 4))

        app.buttons["删除成长记录"].tap()
        XCTAssertTrue(app.buttons["删除记录"].waitForExistence(timeout: 4))
        app.buttons["删除记录"].tap()
        XCTAssertTrue(app.staticTexts["还没有成长记录"].waitForExistence(timeout: 4))
    }
}
