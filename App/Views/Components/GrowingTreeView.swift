import SwiftUI
import XiaoyaGrowthCore

struct GrowingTreeView: View {
    let treeState: TreeState
    let highlightLatest: Bool

    var body: some View {
        ZStack {
            backgroundGlow
            treeShape
                .scaleEffect(highlightLatest ? 1.04 : 1)
                .brightness(highlightLatest ? 0.08 : 0)
                .animation(.spring(response: 0.7, dampingFraction: 0.72), value: highlightLatest)

            ForEach(treeState.decorations.prefix(26)) { decoration in
                decorationView(decoration)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var backgroundGlow: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: .systemGreen).opacity(0.14))
                .blur(radius: 28)
                .offset(x: -64, y: -42)
            Circle()
                .fill(Color(uiColor: .systemBlue).opacity(0.12))
                .blur(radius: 34)
                .offset(x: 72, y: 38)
            Circle()
                .fill(Color(uiColor: .systemYellow).opacity(0.12))
                .blur(radius: 28)
                .offset(x: 18, y: -88)
        }
    }

    private var treeShape: some View {
        VStack(spacing: -10) {
            canopy
            trunk
            ground
        }
    }

    private var canopy: some View {
        ZStack {
            canopyCircle(size: canopySize * 0.82, x: -52, y: 12)
            canopyCircle(size: canopySize, x: 0, y: -12)
            canopyCircle(size: canopySize * 0.78, x: 54, y: 16)
            canopyCircle(size: canopySize * 0.58, x: -18, y: 56)
            canopyCircle(size: canopySize * 0.54, x: 36, y: 56)
        }
        .frame(height: 210)
        .opacity(treeState.stage == .seed ? 0.22 : 1)
    }

    private var trunk: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(red: 0.56, green: 0.34, blue: 0.18), Color(red: 0.72, green: 0.49, blue: 0.26)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: trunkWidth, height: trunkHeight)
            .opacity(treeState.stage == .seed ? 0.18 : 1)
    }

    private var ground: some View {
        Capsule()
            .fill(Color(uiColor: .systemGreen).opacity(0.2))
            .frame(width: 190, height: 24)
            .overlay {
                if treeState.stage == .seed {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color(uiColor: .systemGreen))
                        .offset(y: -18)
                }
            }
    }

    private func canopyCircle(size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(uiColor: .systemGreen).opacity(0.82),
                        Color(red: 0.18, green: 0.58, blue: 0.32).opacity(0.94)
                    ],
                    center: .topLeading,
                    startRadius: 6,
                    endRadius: size
                )
            )
            .frame(width: size, height: size)
            .offset(x: x, y: y)
    }

    private var canopySize: CGFloat {
        switch treeState.stage {
        case .seed: return 80
        case .sprout: return 96
        case .seedling: return 118
        case .youngTree: return 136
        case .floweringTree: return 148
        case .fruitTree: return 156
        case .memoryTree: return 166
        }
    }

    private var trunkWidth: CGFloat {
        switch treeState.stage {
        case .seed, .sprout: return 30
        case .seedling: return 40
        case .youngTree: return 48
        case .floweringTree, .fruitTree: return 56
        case .memoryTree: return 64
        }
    }

    private var trunkHeight: CGFloat {
        switch treeState.stage {
        case .seed: return 24
        case .sprout: return 70
        case .seedling: return 88
        case .youngTree: return 108
        case .floweringTree, .fruitTree: return 116
        case .memoryTree: return 124
        }
    }

    private func decorationView(_ decoration: TreeDecoration) -> some View {
        let point = pointForDecoration(decoration)
        return Image(systemName: symbol(for: decoration.type))
            .font(.system(size: decoration.type == .lightCluster ? 22 : 17, weight: .bold))
            .foregroundStyle(color(for: decoration.type))
            .shadow(color: color(for: decoration.type).opacity(0.35), radius: 8)
            .overlay(alignment: .topTrailing) {
                if decoration.count > 1 {
                    Text("+\(decoration.count)")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Color(uiColor: .systemGreen))
                        .clipShape(Capsule())
                        .offset(x: 12, y: -12)
                }
            }
            .position(x: point.x, y: point.y)
            .accessibilityLabel(decoration.title)
    }

    private func pointForDecoration(_ decoration: TreeDecoration) -> CGPoint {
        let points: [TreeDecorationType: [CGPoint]] = [
            .leaf: [CGPoint(x: 146, y: 116), CGPoint(x: 198, y: 86), CGPoint(x: 238, y: 128), CGPoint(x: 112, y: 150), CGPoint(x: 188, y: 156), CGPoint(x: 264, y: 170)],
            .fruit: [CGPoint(x: 166, y: 92), CGPoint(x: 220, y: 118), CGPoint(x: 136, y: 162), CGPoint(x: 248, y: 154), CGPoint(x: 194, y: 184)],
            .star: [CGPoint(x: 112, y: 86), CGPoint(x: 260, y: 78), CGPoint(x: 286, y: 140), CGPoint(x: 92, y: 166), CGPoint(x: 220, y: 54)],
            .ground: [CGPoint(x: 116, y: 310), CGPoint(x: 244, y: 312), CGPoint(x: 184, y: 326), CGPoint(x: 290, y: 296)],
            .path: [CGPoint(x: 126, y: 292), CGPoint(x: 238, y: 292), CGPoint(x: 172, y: 318), CGPoint(x: 280, y: 320)],
            .halo: [CGPoint(x: 184, y: 44), CGPoint(x: 224, y: 62), CGPoint(x: 144, y: 64)],
            .lightCluster: [CGPoint(x: 286, y: 86)]
        ]
        let candidates = points[decoration.type] ?? [CGPoint(x: 180, y: 140)]
        return candidates[decoration.slotIndex % candidates.count]
    }

    private func symbol(for type: TreeDecorationType) -> String {
        switch type {
        case .path: return "figure.walk"
        case .leaf: return "leaf.fill"
        case .fruit: return "circle.fill"
        case .star: return "sparkle"
        case .ground: return "drop.fill"
        case .halo: return "sun.max.fill"
        case .lightCluster: return "sparkles"
        }
    }

    private func color(for type: TreeDecorationType) -> Color {
        switch type {
        case .path: return Color(red: 0.63, green: 0.42, blue: 0.22)
        case .leaf: return Color(uiColor: .systemGreen)
        case .fruit: return Color(uiColor: .systemOrange)
        case .star: return Color(uiColor: .systemPink)
        case .ground: return Color(uiColor: .systemBlue)
        case .halo: return Color(uiColor: .systemYellow)
        case .lightCluster: return Color(uiColor: .systemYellow)
        }
    }
}
