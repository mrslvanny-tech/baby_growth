import Foundation

public struct MilestoneTemplate: Equatable, Identifiable, Sendable {
    public var id: String
    public var category: MilestoneCategory
    public var title: String
    public var suggestion: String

    public init(id: String, category: MilestoneCategory, title: String, suggestion: String) {
        self.id = id
        self.category = category
        self.title = title
        self.suggestion = suggestion
    }
}

public enum MilestoneTemplates {
    public static let all: [MilestoneTemplate] = [
        MilestoneTemplate(id: "gross_head_up", category: .grossMotor, title: "第一次抬头很稳", suggestion: "你终于能稳稳抬头看世界了。"),
        MilestoneTemplate(id: "gross_roll", category: .grossMotor, title: "第一次翻身", suggestion: "你第一次自己翻过身。"),
        MilestoneTemplate(id: "gross_sit", category: .grossMotor, title: "第一次独坐", suggestion: "你第一次不用扶也能坐住。"),
        MilestoneTemplate(id: "gross_crawl", category: .grossMotor, title: "第一次爬行", suggestion: "你开始向喜欢的东西靠近。"),
        MilestoneTemplate(id: "gross_stand_help", category: .grossMotor, title: "第一次扶站", suggestion: "你扶着东西站了起来。"),
        MilestoneTemplate(id: "gross_stand", category: .grossMotor, title: "第一次独站", suggestion: "你短短地站住了几秒。"),
        MilestoneTemplate(id: "gross_walk", category: .grossMotor, title: "第一次走路", suggestion: "你自己向前走了几步。"),

        MilestoneTemplate(id: "fine_grab", category: .fineMotor, title: "第一次抓住玩具", suggestion: "你第一次稳稳抓住了喜欢的东西。"),
        MilestoneTemplate(id: "fine_hands", category: .fineMotor, title: "第一次双手互握", suggestion: "你发现了自己的小手。"),
        MilestoneTemplate(id: "fine_clap", category: .fineMotor, title: "第一次拍手", suggestion: "你第一次开心地拍起小手。"),
        MilestoneTemplate(id: "fine_pinch", category: .fineMotor, title: "第一次捏起小东西", suggestion: "小手越来越灵活了。"),
        MilestoneTemplate(id: "fine_spoon", category: .fineMotor, title: "第一次自己拿勺子", suggestion: "你想试着自己吃饭啦。"),

        MilestoneTemplate(id: "lang_babble", category: .language, title: "第一次咿呀回应", suggestion: "你开始认真回应我们。"),
        MilestoneTemplate(id: "lang_dad", category: .language, title: "第一次叫爸爸", suggestion: "这一天，爸爸听见了最甜的声音。"),
        MilestoneTemplate(id: "lang_mom", category: .language, title: "第一次叫妈妈", suggestion: "这一天，妈妈听见了最甜的声音。"),
        MilestoneTemplate(id: "lang_word", category: .language, title: "第一个清晰词语", suggestion: "你有了第一个自己的词。"),
        MilestoneTemplate(id: "lang_mimic", category: .language, title: "第一次模仿声音", suggestion: "你开始学着和世界对话。"),

        MilestoneTemplate(id: "social_laugh", category: .socialEmotion, title: "第一次笑出声", suggestion: "你的笑声把这一天照亮了。"),
        MilestoneTemplate(id: "social_know_mom", category: .socialEmotion, title: "第一次认出妈妈", suggestion: "你看见妈妈就笑了。"),
        MilestoneTemplate(id: "social_know_dad", category: .socialEmotion, title: "第一次认出爸爸", suggestion: "你看见爸爸就笑了。"),
        MilestoneTemplate(id: "social_wave", category: .socialEmotion, title: "第一次挥手", suggestion: "你学会了和世界打招呼。"),
        MilestoneTemplate(id: "social_kiss", category: .socialEmotion, title: "第一次亲亲", suggestion: "你给了我们一个小小的亲亲。"),
        MilestoneTemplate(id: "social_hug", category: .socialEmotion, title: "第一次拥抱", suggestion: "你张开小手抱住了我们。"),

        MilestoneTemplate(id: "habit_food", category: .dailyHabit, title: "第一次吃辅食", suggestion: "世界的味道，从一小口开始。"),
        MilestoneTemplate(id: "habit_cup", category: .dailyHabit, title: "第一次喝水杯", suggestion: "你有了自己的小杯子。"),
        MilestoneTemplate(id: "habit_sleep", category: .dailyHabit, title: "第一次睡整觉", suggestion: "今晚大家都睡得很好。"),
        MilestoneTemplate(id: "habit_brush", category: .dailyHabit, title: "第一次刷牙", suggestion: "你开始照顾自己的小牙齿。"),
        MilestoneTemplate(id: "habit_bath", category: .dailyHabit, title: "第一次洗澡不哭", suggestion: "洗澡也变成了开心事。"),

        MilestoneTemplate(id: "anniv_month", category: .anniversary, title: "满月", suggestion: "一个月啦，小小的你已经变了好多。"),
        MilestoneTemplate(id: "anniv_100", category: .anniversary, title: "百天", suggestion: "第 100 天，我们一起走过了第一个大纪念日。"),
        MilestoneTemplate(id: "anniv_half", category: .anniversary, title: "半岁", suggestion: "半岁的你，每天都有新变化。"),
        MilestoneTemplate(id: "anniv_one", category: .anniversary, title: "一岁", suggestion: "365 天，欢迎来到一岁的世界。"),
        MilestoneTemplate(id: "anniv_spring", category: .anniversary, title: "第一次过春节", suggestion: "你第一次和我们一起过春节。"),
        MilestoneTemplate(id: "anniv_birthday", category: .anniversary, title: "第一次过生日", suggestion: "今天属于你。")
    ]
}
