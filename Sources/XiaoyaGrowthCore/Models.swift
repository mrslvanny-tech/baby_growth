import Foundation

public struct BabyProfileDraft: Equatable, Sendable {
    public var nickname: String
    public var birthDate: Date
    public var gender: String?
    public var avatarLocalIdentifier: String?

    public init(
        nickname: String,
        birthDate: Date,
        gender: String? = nil,
        avatarLocalIdentifier: String? = nil
    ) {
        self.nickname = nickname
        self.birthDate = birthDate
        self.gender = gender
        self.avatarLocalIdentifier = avatarLocalIdentifier
    }
}

public struct MilestoneRecordDraft: Equatable, Identifiable, Sendable {
    public var id: UUID
    public var templateId: String?
    public var category: MilestoneCategory
    public var title: String
    public var note: String?
    public var occurredAt: Date
    public var mediaLocalIdentifiers: [String]
    public var moodTags: [String]

    public init(
        id: UUID = UUID(),
        templateId: String? = nil,
        category: MilestoneCategory,
        title: String,
        note: String? = nil,
        occurredAt: Date,
        mediaLocalIdentifiers: [String] = [],
        moodTags: [String] = []
    ) {
        self.id = id
        self.templateId = templateId
        self.category = category
        self.title = title
        self.note = note
        self.occurredAt = occurredAt
        self.mediaLocalIdentifiers = mediaLocalIdentifiers
        self.moodTags = moodTags
    }
}

public enum MilestoneCategory: String, CaseIterable, Codable, Equatable, Sendable {
    case grossMotor
    case fineMotor
    case language
    case socialEmotion
    case dailyHabit
    case anniversary
    case custom

    public var title: String {
        switch self {
        case .grossMotor: return "大运动"
        case .fineMotor: return "精细动作"
        case .language: return "语言"
        case .socialEmotion: return "情绪社交"
        case .dailyHabit: return "生活习惯"
        case .anniversary: return "纪念日"
        case .custom: return "自定义"
        }
    }
}

public enum TreeStage: String, CaseIterable, Codable, Equatable, Sendable {
    case seed
    case sprout
    case seedling
    case youngTree
    case floweringTree
    case fruitTree
    case memoryTree

    public var title: String {
        switch self {
        case .seed: return "种子"
        case .sprout: return "小芽"
        case .seedling: return "幼苗"
        case .youngTree: return "小树"
        case .floweringTree: return "开花树"
        case .fruitTree: return "结果树"
        case .memoryTree: return "纪念树"
        }
    }

    public var message: String {
        switch self {
        case .seed: return "一颗小种子已经种下。"
        case .sprout: return "小芽冒出了第一片叶子。"
        case .seedling: return "小树开始认真长高。"
        case .youngTree: return "已经长成一棵小树啦。"
        case .floweringTree: return "树上开出了成长的小花。"
        case .fruitTree: return "每个第一次都变成了果实。"
        case .memoryTree: return "一整年的爱都在这里。"
        }
    }
}

public enum TreeDecorationType: String, Codable, Equatable, Sendable {
    case path
    case leaf
    case fruit
    case star
    case ground
    case halo
    case lightCluster
}

public struct TreeDecoration: Equatable, Identifiable, Sendable {
    public var id: String
    public var type: TreeDecorationType
    public var category: MilestoneCategory
    public var slotIndex: Int
    public var count: Int
    public var title: String

    public init(
        type: TreeDecorationType,
        category: MilestoneCategory,
        slotIndex: Int,
        count: Int = 1,
        title: String
    ) {
        self.id = "\(type.rawValue)-\(category.rawValue)-\(slotIndex)-\(count)"
        self.type = type
        self.category = category
        self.slotIndex = slotIndex
        self.count = count
        self.title = title
    }
}

public struct TreeState: Equatable, Sendable {
    public var stage: TreeStage
    public var recordCount: Int
    public var decorations: [TreeDecoration]

    public init(stage: TreeStage, recordCount: Int, decorations: [TreeDecoration]) {
        self.stage = stage
        self.recordCount = recordCount
        self.decorations = decorations
    }
}

public struct ShareCardCopy: Equatable, Sendable {
    public var dayText: String
    public var title: String
    public var body: String
    public var watermark: String

    public init(dayText: String, title: String, body: String, watermark: String) {
        self.dayText = dayText
        self.title = title
        self.body = body
        self.watermark = watermark
    }
}
