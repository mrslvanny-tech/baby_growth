import Foundation

public enum ShareCardCopyBuilder {
    public static func shareCardText(
        profile: BabyProfileDraft,
        record: MilestoneRecordDraft,
        calendar: Calendar = .current
    ) -> ShareCardCopy {
        let days = TimeCalculator.daysSinceBirth(
            birthDate: profile.birthDate,
            today: record.occurredAt,
            calendar: calendar
        )
        return ShareCardCopy(
            dayText: "出生第 \(days) 天",
            title: record.title,
            body: bodyText(for: record),
            watermark: "来自「小芽成长」"
        )
    }

    private static func bodyText(for record: MilestoneRecordDraft) -> String {
        if record.title.contains("翻身") {
            return "原来探索世界，是从一次小小的转身开始。"
        }
        if record.title.contains("抓") || record.category == .fineMotor {
            return "原来长大，是从一次小小的伸手开始。"
        }
        if record.title.contains("爸爸") || record.title.contains("妈妈") || record.category == .language {
            return "这一天，小树长出了一颗最甜的果实。"
        }
        if record.title.contains("辅食") || record.category == .dailyHabit {
            return "世界的味道，从一小口开始。"
        }
        if record.title.contains("走路") {
            return "从这一天起，世界又大了一点。"
        }
        return record.note?.isEmpty == false ? record.note! : "今天的小树，又多了一点生机。"
    }
}
