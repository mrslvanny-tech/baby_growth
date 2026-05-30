import Foundation

public enum TimeCalculator {
    public static func daysSinceBirth(birthDate: Date, today: Date = Date(), calendar: Calendar = .current) -> Int {
        let start = calendar.startOfDay(for: birthDate)
        let end = calendar.startOfDay(for: today)
        let diff = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        return max(diff + 1, 1)
    }

    public static func monthAgeText(birthDate: Date, today: Date = Date(), calendar: Calendar = .current) -> String {
        let birthDay = calendar.startOfDay(for: birthDate)
        let currentDay = calendar.startOfDay(for: today)
        let components = calendar.dateComponents([.month, .day], from: birthDay, to: currentDay)
        let months = max(components.month ?? 0, 0)
        let days = max(components.day ?? 0, 0)
        return "\(months) 个月 \(days) 天"
    }

    public static func nextMonthCountdownText(birthDate: Date, today: Date = Date(), calendar: Calendar = .current) -> String {
        let birthDay = calendar.startOfDay(for: birthDate)
        let currentDay = calendar.startOfDay(for: today)
        let currentMonths = max(calendar.dateComponents([.month], from: birthDay, to: currentDay).month ?? 0, 0)
        let targetMonths = currentMonths + 1
        guard let nextMonthDate = calendar.date(byAdding: .month, value: targetMonths, to: birthDay) else {
            return "距离下个月龄还有 0 天"
        }
        let days = max(calendar.dateComponents([.day], from: currentDay, to: nextMonthDate).day ?? 0, 0)
        return "距离 \(targetMonths) 个月还有 \(days) 天"
    }

    public static func timeTagText(mode: TimeTagMode, profile: BabyProfileDraft, today: Date = Date(), calendar: Calendar = .current) -> String {
        switch mode {
        case .days:
            let days = daysSinceBirth(birthDate: profile.birthDate, today: today, calendar: calendar)
            return "\(profile.nickname) 已来到世界 \(days) 天"
        case .months:
            return "\(profile.nickname) 已经 \(monthAgeText(birthDate: profile.birthDate, today: today, calendar: calendar))了"
        case .countdown:
            return nextMonthCountdownText(birthDate: profile.birthDate, today: today, calendar: calendar)
        }
    }
}

public enum TimeTagMode: Int, CaseIterable, Sendable {
    case days
    case months
    case countdown

    public func next() -> TimeTagMode {
        let modes = Self.allCases
        let index = (rawValue + 1) % modes.count
        return modes[index]
    }
}
