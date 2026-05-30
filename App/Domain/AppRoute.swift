import Foundation
import XiaoyaGrowthCore

enum AppRoute: Hashable {
    case templates
    case editor(templateId: String?)
    case history
    case settings
}

struct SaveSuccessState: Identifiable, Equatable {
    var id: UUID
    var title: String
    var recordId: UUID
}

extension MilestoneTemplate {
    static var customTemplate: MilestoneTemplate {
        MilestoneTemplate(
            id: "custom",
            category: .custom,
            title: "自定义记录",
            suggestion: "写下今天最想保存的那个瞬间。"
        )
    }
}
