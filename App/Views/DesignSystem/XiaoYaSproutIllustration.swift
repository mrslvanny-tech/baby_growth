import SwiftUI
import XiaoyaGrowthCore

struct XiaoYaSproutIllustration: View {
    let treeState: TreeState
    let highlightLatest: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            XiaoYaDesignTokens.Color.softPrimary,
                            XiaoYaDesignTokens.Color.softSecondary
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 14) {
                GrowingTreeView(treeState: treeState, highlightLatest: highlightLatest)
                    .frame(height: 260)

                Text(treeState.stage.title)
                    .font(XiaoYaDesignTokens.Font.title)
                    .foregroundStyle(.primary)

                Text(treeState.stage.message)
                    .font(XiaoYaDesignTokens.Font.note)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(XiaoYaDesignTokens.Spacing.card)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("成长树，当前阶段 \(treeState.stage.title)，已点亮 \(treeState.recordCount) 个成长瞬间")
    }
}
