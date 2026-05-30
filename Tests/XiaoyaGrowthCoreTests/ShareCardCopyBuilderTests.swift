import XCTest
import Foundation
@testable import XiaoyaGrowthCore

final class ShareCardCopyBuilderTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
        return calendar
    }()

    func testShareCardCopyIncludesDayCountAndMilestoneTitle() throws {
        let birthDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 23)))
        let occurredAt = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 30)))
        let profile = BabyProfileDraft(nickname: "小芽", birthDate: birthDate)
        let record = MilestoneRecordDraft(category: .fineMotor, title: "第一次抓住玩具", note: "你第一次稳稳抓住了小熊。", occurredAt: occurredAt)

        let copy = ShareCardCopyBuilder.shareCardText(profile: profile, record: record, calendar: calendar)

        XCTAssertEqual(copy.dayText, "出生第 128 天")
        XCTAssertEqual(copy.title, "第一次抓住玩具")
        XCTAssertEqual(copy.body, "原来长大，是从一次小小的伸手开始。")
        XCTAssertEqual(copy.watermark, "来自「小芽成长」")
    }
}
