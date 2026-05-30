import Foundation

public enum TreeStateCalculator {
    public static func treeStage(recordCount: Int) -> TreeStage {
        switch recordCount {
        case 0:
            return .seed
        case 1...3:
            return .sprout
        case 4...8:
            return .seedling
        case 9...15:
            return .youngTree
        case 16...25:
            return .floweringTree
        case 26...40:
            return .fruitTree
        default:
            return .memoryTree
        }
    }

    public static func state(records: [MilestoneRecordDraft]) -> TreeState {
        TreeState(
            stage: treeStage(recordCount: records.count),
            recordCount: records.count,
            decorations: treeDecorations(records: records)
        )
    }

    public static func treeDecorations(records: [MilestoneRecordDraft]) -> [TreeDecoration] {
        var counts: [MilestoneCategory: Int] = [:]
        var decorations: [TreeDecoration] = []

        for record in records {
            let categoryCount = counts[record.category, default: 0]
            counts[record.category] = categoryCount + 1

            let type = visibleDecorationType(for: record.category)
            let limit = visibleSlotLimit(for: type)
            if categoryCount < limit {
                decorations.append(
                    TreeDecoration(
                        type: type,
                        category: record.category,
                        slotIndex: categoryCount,
                        title: record.title
                    )
                )
            }
        }

        for (category, total) in counts where total > visibleSlotLimit(for: visibleDecorationType(for: category)) {
            let overflow = total - visibleSlotLimit(for: visibleDecorationType(for: category))
            decorations.append(
                TreeDecoration(
                    type: .lightCluster,
                    category: category,
                    slotIndex: 0,
                    count: overflow,
                    title: "\(category.title)光点组"
                )
            )
        }

        return decorations
    }

    public static func visibleDecorationType(for category: MilestoneCategory) -> TreeDecorationType {
        switch category {
        case .grossMotor:
            return .path
        case .fineMotor:
            return .leaf
        case .language:
            return .fruit
        case .socialEmotion:
            return .star
        case .dailyHabit:
            return .ground
        case .anniversary:
            return .halo
        case .custom:
            return .star
        }
    }

    private static func visibleSlotLimit(for type: TreeDecorationType) -> Int {
        switch type {
        case .path:
            return 4
        case .leaf:
            return 12
        case .fruit:
            return 8
        case .star:
            return 6
        case .ground:
            return 6
        case .halo:
            return 6
        case .lightCluster:
            return 1
        }
    }
}
