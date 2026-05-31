import SwiftUI

struct XiaoYaCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(XiaoYaDesignTokens.Spacing.card)
            .frame(maxWidth: .infinity)
            .background(XiaoYaDesignTokens.Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))
    }
}
