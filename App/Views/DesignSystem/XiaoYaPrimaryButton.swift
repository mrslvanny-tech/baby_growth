import SwiftUI

struct XiaoYaPrimaryButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label

    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: action) {
            label
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(XiaoYaDesignTokens.Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))
    }
}
