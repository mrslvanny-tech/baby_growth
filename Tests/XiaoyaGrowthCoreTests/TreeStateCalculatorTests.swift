import XCTest
import Foundation
@testable import XiaoyaGrowthCore

final class TreeStateCalculatorTests: XCTestCase {
    func testRecordThresholdsMapToTheCorrectTreeStages() {
        let cases: [(Int, TreeStage)] = [
        (0, TreeStage.seed),
        (1, TreeStage.sprout),
        (3, TreeStage.sprout),
        (4, TreeStage.seedling),
        (8, TreeStage.seedling),
        (9, TreeStage.youngTree),
        (15, TreeStage.youngTree),
        (16, TreeStage.floweringTree),
        (25, TreeStage.floweringTree),
        (26, TreeStage.fruitTree),
        (40, TreeStage.fruitTree),
        (41, TreeStage.memoryTree)
        ]

        for (recordCount, stage) in cases {
            XCTAssertEqual(TreeStateCalculator.treeStage(recordCount: recordCount), stage)
        }
    }

    func testDecorationsAreMappedFromMilestoneCategories() {
        let records = [
            MilestoneRecordDraft(category: .grossMotor, title: "第一次翻身", occurredAt: Date()),
            MilestoneRecordDraft(category: .language, title: "第一次叫妈妈", occurredAt: Date()),
            MilestoneRecordDraft(category: .socialEmotion, title: "第一次笑出声", occurredAt: Date()),
            MilestoneRecordDraft(category: .dailyHabit, title: "第一次吃辅食", occurredAt: Date())
        ]

        let decorations = TreeStateCalculator.treeDecorations(records: records)

        XCTAssertEqual(decorations.map(\.type), [.path, .fruit, .star, .ground])
        XCTAssertEqual(decorations.map(\.slotIndex), [0, 0, 0, 0])
    }

    func testDecorationsAggregateWhenCategoryExceedsVisibleSlots() {
        let records = (0..<10).map {
            MilestoneRecordDraft(category: .language, title: "语言 \($0)", occurredAt: Date())
        }

        let decorations = TreeStateCalculator.treeDecorations(records: records)

        XCTAssertEqual(decorations.filter { $0.type == .fruit }.count, 8)
        XCTAssertEqual(decorations.last?.type, .lightCluster)
        XCTAssertEqual(decorations.last?.count, 2)
    }
}
