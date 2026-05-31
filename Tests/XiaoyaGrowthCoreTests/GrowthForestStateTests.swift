import XCTest
@testable import XiaoyaGrowthCore

final class GrowthForestStateTests: XCTestCase {
    func testImageNamesMapSingleTreeProgress() {
        XCTAssertEqual(GrowthForestState(recordCount: 0).imageName, "tree_stage_01")
        XCTAssertEqual(GrowthForestState(recordCount: 1).imageName, "tree_stage_02")
        XCTAssertEqual(GrowthForestState(recordCount: 34).imageName, "tree_stage_35")
        XCTAssertEqual(GrowthForestState(recordCount: 35).imageName, "tree_stage_36")
    }

    func testForestStateStartsNextTreeAfterThirtyFiveRecords() {
        let state = GrowthForestState(recordCount: 36)

        XCTAssertEqual(state.completedTreeCount, 1)
        XCTAssertEqual(state.activeTreeNumber, 2)
        XCTAssertEqual(state.activeTreeProgress, 1)
        XCTAssertEqual(state.imageName, "tree_stage_02")
        XCTAssertEqual(state.headline, "已经长成 1 棵小树，正在点亮第 2 棵")
    }

    func testCompletedTreeBoundaryUsesFullTreeCopy() {
        let state = GrowthForestState(recordCount: 70)

        XCTAssertEqual(state.completedTreeCount, 2)
        XCTAssertEqual(state.activeTreeNumber, 2)
        XCTAssertEqual(state.activeTreeProgress, 0)
        XCTAssertEqual(state.imageName, "tree_stage_36")
        XCTAssertEqual(state.headline, "已经长成 2 棵小树")
    }
}
