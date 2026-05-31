import SwiftUI

struct XiaoYaEmptyState: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        XiaoYaCard {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(XiaoYaDesignTokens.Color.primary)

                Text(title)
                    .font(XiaoYaDesignTokens.Font.title)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(XiaoYaDesignTokens.Font.note)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }
}
