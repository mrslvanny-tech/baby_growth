import SwiftUI
import XiaoyaGrowthCore

/// 像素风格成长树视图（替换原 GrowingTreeView）
/// 树干为深色树干图，树冠由 360 个小叶片像素块组成
struct PixelGrowingTreeView: View {
    let treeState: TreeState
    let highlightLatest: Bool

    var body: some View {
        ZStack {
            backgroundGlow
            treeShape
                .scaleEffect(highlightLatest ? 1.04 : 1)
                .brightness(highlightLatest ? 0.08 : 0)
                .animation(.spring(response: 0.7, dampingFraction: 0.72), value: highlightLatest)

            // 装饰物（保留原有系统）
            ForEach(treeState.decorations.prefix(26)) { decoration in
                decorationView(decoration)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
    }

    // MARK: - 背景光晕

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

    // MARK: - 树形主体

    private var treeShape: some View {
        VStack(spacing: -6) {
            canopy
            trunk
            ground
        }
    }

    // MARK: - 像素树冠（360个小叶片像素块）

    private var canopy: some View {
        PixelCanopyView(
            litCount: treeState.recordCount,
            stage: treeState.stage
        )
        .frame(height: 210)
        .opacity(treeState.stage == .seed ? 0.18 : 1)
    }

    // MARK: - 深色树干

    private var trunk: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.38, green: 0.24, blue: 0.13),
                        Color(red: 0.52, green: 0.34, blue: 0.19),
                        Color(red: 0.42, green: 0.27, blue: 0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: trunkWidth, height: trunkHeight)
            .opacity(treeState.stage == .seed ? 0.16 : 1)
    }

    // MARK: - 地面

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

    // MARK: - 尺寸计算

    private var trunkWidth: CGFloat {
        switch treeState.stage {
        case .seed, .sprout:  return 28
        case .seedling:       return 38
        case .youngTree:      return 46
        case .floweringTree,
             .fruitTree:      return 54
        case .memoryTree:     return 62
        }
    }

    private var trunkHeight: CGFloat {
        switch treeState.stage {
        case .seed:           return 22
        case .sprout:         return 68
        case .seedling:       return 86
        case .youngTree:      return 106
        case .floweringTree,
             .fruitTree:      return 114
        case .memoryTree:     return 122
        }
    }

    // MARK: - 装饰物系统（完全保留原有逻辑）

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
            .leaf: [
                CGPoint(x: 146, y: 116),
                CGPoint(x: 198, y: 86),
                CGPoint(x: 238, y: 128),
                CGPoint(x: 112, y: 150),
                CGPoint(x: 188, y: 156),
                CGPoint(x: 264, y: 170)
            ],
            .fruit: [
                CGPoint(x: 166, y: 92),
                CGPoint(x: 220, y: 118),
                CGPoint(x: 136, y: 162),
                CGPoint(x: 248, y: 154),
                CGPoint(x: 194, y: 184)
            ],
            .star: [
                CGPoint(x: 112, y: 86),
                CGPoint(x: 260, y: 78),
                CGPoint(x: 286, y: 140),
                CGPoint(x: 92, y: 166),
                CGPoint(x: 220, y: 54)
            ],
            .ground: [
                CGPoint(x: 116, y: 310),
                CGPoint(x: 244, y: 312),
                CGPoint(x: 184, y: 326),
                CGPoint(x: 290, y: 296)
            ],
            .path: [
                CGPoint(x: 126, y: 292),
                CGPoint(x: 238, y: 292),
                CGPoint(x: 172, y: 318),
                CGPoint(x: 280, y: 320)
            ],
            .halo: [
                CGPoint(x: 184, y: 44),
                CGPoint(x: 224, y: 62),
                CGPoint(x: 144, y: 64)
            ],
            .lightCluster: [
                CGPoint(x: 286, y: 86)
            ]
        ]
        let candidates = points[decoration.type] ?? [CGPoint(x: 180, y: 140)]
        return candidates[decoration.slotIndex % candidates.count]
    }

    private func symbol(for type: TreeDecorationType) -> String {
        switch type {
        case .path:         return "figure.walk"
        case .leaf:         return "leaf.fill"
        case .fruit:        return "circle.fill"
        case .star:         return "sparkle"
        case .ground:       return "drop.fill"
        case .halo:         return "sun.max.fill"
        case .lightCluster: return "sparkles"
        }
    }

    private func color(for type: TreeDecorationType) -> Color {
        switch type {
        case .path:         return Color(red: 0.63, green: 0.42, blue: 0.22)
        case .leaf:         return Color(uiColor: .systemGreen)
        case .fruit:        return Color(uiColor: .systemOrange)
        case .star:         return Color(uiColor: .systemPink)
        case .ground:       return Color(uiColor: .systemBlue)
        case .halo:         return Color(uiColor: .systemYellow)
        case .lightCluster: return Color(uiColor: .systemYellow)
        }
    }
}
