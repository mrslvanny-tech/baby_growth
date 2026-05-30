import SwiftUI

struct AvatarSeedView: View {
    let seed: Int
    let size: CGFloat

    private var colors: [Color] {
        switch seed {
        case 2:
            return [Color(uiColor: .systemBlue), Color(uiColor: .systemTeal)]
        case 3:
            return [Color(uiColor: .systemPink), Color(uiColor: .systemOrange)]
        case 4:
            return [Color(uiColor: .systemPurple), Color(uiColor: .systemIndigo)]
        case 5:
            return [Color(uiColor: .systemYellow), Color(uiColor: .systemGreen)]
        case 6:
            return [Color(uiColor: .systemMint), Color(uiColor: .systemCyan)]
        default:
            return [Color(uiColor: .systemGreen), Color(uiColor: .systemYellow)]
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Image(systemName: "leaf.fill")
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .shadow(color: colors.first?.opacity(0.25) ?? .clear, radius: 12, y: 6)
        .accessibilityHidden(true)
    }
}
