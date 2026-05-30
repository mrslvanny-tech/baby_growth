import Foundation

enum SeedData {
    static func defaultBirthDate(calendar: Calendar = .current, today: Date = Date()) -> Date {
        calendar.date(byAdding: .day, value: -127, to: today) ?? today
    }
}
