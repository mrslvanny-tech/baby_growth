import SwiftUI

struct XiaoYaGrowthBadge: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(XiaoYaDesignTokens.Color.primary)
                .frame(width: 24, height: 24)
                .background(XiaoYaDesignTokens.Color.softPrimary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(title)
                    .font(XiaoYaDesignTokens.Font.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(XiaoYaDesignTokens.Color.elevatedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
