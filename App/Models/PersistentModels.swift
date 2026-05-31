import Foundation
import SwiftData
import XiaoyaGrowthCore

@Model
final class BabyProfile {
    var id: UUID = UUID()
    var nickname: String = ""
    var birthDate: Date = Date()
    var gender: String?
    var avatarLocalIdentifier: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(
        id: UUID = UUID(),
        nickname: String,
        birthDate: Date,
        gender: String? = nil,
        avatarLocalIdentifier: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.nickname = nickname
        self.birthDate = birthDate
        self.gender = gender
        self.avatarLocalIdentifier = avatarLocalIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var draft: BabyProfileDraft {
        BabyProfileDraft(
            nickname: nickname,
            birthDate: birthDate,
            gender: gender,
            avatarLocalIdentifier: avatarLocalIdentifier
        )
    }
}

@Model
final class MilestoneRecord {
    var id: UUID = UUID()
    var babyId: UUID = UUID()
    var templateId: String?
    var categoryRawValue: String = MilestoneCategory.grossMotor.rawValue
    var title: String = ""
    var note: String?
    var occurredAt: Date = Date()
    var mediaLocalIdentifiers: [String] = []
    var moodTags: [String] = []
    var visualElementTypeRawValue: String = TreeDecorationType.leaf.rawValue
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(
        id: UUID = UUID(),
        babyId: UUID,
        templateId: String? = nil,
        category: MilestoneCategory,
        title: String,
        note: String? = nil,
        occurredAt: Date,
        mediaLocalIdentifiers: [String] = [],
        moodTags: [String] = [],
        visualElementType: TreeDecorationType,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.templateId = templateId
        self.categoryRawValue = category.rawValue
        self.title = title
        self.note = note
        self.occurredAt = occurredAt
        self.mediaLocalIdentifiers = mediaLocalIdentifiers
        self.moodTags = moodTags
        self.visualElementTypeRawValue = visualElementType.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var category: MilestoneCategory {
        MilestoneCategory(rawValue: categoryRawValue) ?? .custom
    }

    var visualElementType: TreeDecorationType {
        TreeDecorationType(rawValue: visualElementTypeRawValue) ?? .star
    }

    var draft: MilestoneRecordDraft {
        MilestoneRecordDraft(
            id: id,
            templateId: templateId,
            category: category,
            title: title,
            note: note,
            occurredAt: occurredAt,
            mediaLocalIdentifiers: mediaLocalIdentifiers,
            moodTags: moodTags
        )
    }
}
