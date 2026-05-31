import Foundation

public struct GrowthForestState: Equatable, Sendable {
    public static let recordsPerTree = 35

    public var recordCount: Int
    public var completedTreeCount: Int
    public var activeTreeNumber: Int
    public var activeTreeProgress: Int
    public var imageName: String
    public var headline: String
    public var subheadline: String

    public init(recordCount: Int) {
        let safeCount = max(0, recordCount)
        self.recordCount = safeCount
        self.completedTreeCount = safeCount / Self.recordsPerTree
        self.activeTreeProgress = safeCount % Self.recordsPerTree

        if safeCount > 0 && activeTreeProgress == 0 {
            self.activeTreeNumber = max(1, completedTreeCount)
        } else {
            self.activeTreeNumber = completedTreeCount + 1
        }

        let imageIndex: Int
        if safeCount <= 0 {
            imageIndex = 1
        } else if safeCount > 0 && activeTreeProgress == 0 {
            imageIndex = 36
        } else {
            imageIndex = min(activeTreeProgress + 1, 36)
        }
        self.imageName = String(format: "tree_stage_%02d", imageIndex)

        if completedTreeCount == 0 {
            self.headline = "已经点亮了 \(safeCount) 个成长瞬间"
        } else if activeTreeProgress == 0 {
            self.headline = "已经长成 \(completedTreeCount) 棵小树"
        } else {
            self.headline = "已经长成 \(completedTreeCount) 棵小树，正在点亮第 \(activeTreeNumber) 棵"
        }
        self.subheadline = "每一次记录，都是小芽长大的一片叶子"
    }
}
