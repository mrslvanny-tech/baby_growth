import XCTest
import Foundation
@testable import XiaoyaGrowthCore

final class TimeCalculatorTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
        return calendar
    }()

    func testBirthDayIsDisplayedAsDayOne() throws {
        let birthDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 30)))
        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 30)))

        XCTAssertEqual(TimeCalculator.daysSinceBirth(birthDate: birthDate, today: today, calendar: calendar), 1)
    }

    func testDaysSinceBirthIncludesTheBirthDay() throws {
        let birthDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 23)))
        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 30)))

        XCTAssertEqual(TimeCalculator.daysSinceBirth(birthDate: birthDate, today: today, calendar: calendar), 128)
    }

    func testMonthAgeUsesCalendarMonthsInsteadOfThirtyDayBuckets() throws {
        let birthDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 31)))
        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 3, day: 30)))

        XCTAssertEqual(TimeCalculator.monthAgeText(birthDate: birthDate, today: today, calendar: calendar), "1 个月 30 天")
    }

    func testNextMonthCountdownRespectsCalendarMonthLengths() throws {
        let birthDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 23)))
        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 30)))

        XCTAssertEqual(TimeCalculator.nextMonthCountdownText(birthDate: birthDate, today: today, calendar: calendar), "距离 5 个月还有 24 天")
    }
}
