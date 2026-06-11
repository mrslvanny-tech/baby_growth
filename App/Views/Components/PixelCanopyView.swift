import SwiftUI
import XiaoyaGrowthCore

/// 像素化树冠组件 - 360个小叶片形状的像素块
/// 密集排列成蓬松的树冠轮廓，每个像素块都是一片小叶子的形状
struct PixelCanopyView: View {
    /// 已点亮的叶片数量
    let litCount: Int
    /// 树木阶段，影响整体缩放
    let stage: TreeStage

    // MARK: - 常量

    /// 总叶片数（360片，形成浓密像素树冠）
    private let totalLeaves = 360
    /// 叶片基础宽度
    private let leafW: CGFloat = 5
    /// 叶片基础高度
    private let leafH: CGFloat = 7

    // MARK: - 叶片位置（360个，5簇蓬松树冠）

    /// 360个小叶片中心点坐标（基于 360x210 参考系）
    /// 使用确定性伪随机在5个圆形簇内均匀分布
    private let leafPositions: [CGPoint] = PixelCanopyView.generatePositions()

    private static func generatePositions() -> [CGPoint] {
        // 确定性哈希伪随机
        func hash(_ n: Int, _ s: Int) -> CGFloat {
            let x = sin(Double(n * 127 + s * 31 + 78)) * 43758.5453123
            return CGFloat(x - floor(x))
        }

        // 5个簇组成蓬松树冠：(中心点, 半径, 叶片数)
        let clusters: [(CGPoint, CGFloat, Int)] = [
            (CGPoint(x: 180, y: 55),  75, 100), // 顶部中心 - 最浓密
            (CGPoint(x: 120, y: 90),  62,  70), // 左上
            (CGPoint(x: 240, y: 90),  62,  70), // 右上
            (CGPoint(x: 150, y: 138), 54,  60), // 左下
            (CGPoint(x: 210, y: 138), 54,  60), // 右下
        ]

        var positions: [CGPoint] = []
        var idx = 0

        for (center, radius, count) in clusters {
            for i in 0..<count {
                // 在圆形区域内均匀分布
                let angle = hash(idx, 3) * 2 * CGFloat.pi + CGFloat(i) * 0.017
                let r = sqrt(hash(idx, 7)) * radius
                let x = center.x + r * cos(angle)
                // y轴稍微压扁，让树冠更自然
                let y = center.y + r * sin(angle) * 0.82
                positions.append(CGPoint(x: x, y: y))
                idx += 1
            }
        }

        return positions
    }

    // MARK: - 每个叶片的旋转角度

    private let leafRotations: [Double] = PixelCanopyView.generateRotations()

    private static func generateRotations() -> [Double] {
        func hash(_ n: Int) -> CGFloat {
            let x = sin(Double(n) * 45.234 + 91.876) * 23421.6789123
            return CGFloat(x - floor(x))
        }
        return (0..<360).map { Double(hash($0) * 180 - 90) } // -90 ~ +90 度
    }

    // MARK: - Body

    var body: some View {
        let effectiveLit = min(max(litCount, 0), leafPositions.count)

        ZStack {
            ForEach(0..<leafPositions.count, id: \.self) { index in
                pixelLeaf(index: index, effectiveLit: effectiveLit)
            }
        }
        .frame(width: 360, height: 210)
        .scaleEffect(canopyScale)
    }

    // MARK: - 单个小叶片视图

    @ViewBuilder
    private func pixelLeaf(index: Int, effectiveLit: Int) -> some View {
        let isLit = index < effectiveLit

        Ellipse()
            .fill(isLit ? litFill : unlitFill)
            .frame(width: leafW, height: leafH)
            .position(leafPositions[index])
            .rotationEffect(.degrees(leafRotations[index]), anchor: .center)
            .shadow(
                color: isLit ? litGlowColor.opacity(0.5) : .clear,
                radius: isLit ? 4 : 0,
                x: 0,
                y: isLit ? 1 : 0
            )
            .scaleEffect(isLit ? 1.0 : 0.55)
            .opacity(isLit ? 1.0 : 0.28)
            // 只有最新点亮的叶片做弹出动画
            .animation(
                .spring(response: 0.45, dampingFraction: 0.68)
                .delay(isLit ? Double(index) * 0.0008 : 0),
                value: effectiveLit
            )
    }

    // MARK: - 颜色

    private var litFill: Color {
        Color(red: 0.18, green: 0.76, blue: 0.35)
    }

    private var unlitFill: Color {
        Color(red: 0.78, green: 0.90, blue: 0.80).opacity(0.22)
    }

    private var litGlowColor: Color {
        Color(red: 0.25, green: 0.85, blue: 0.42)
    }

    // MARK: - 阶段缩放

    private var canopyScale: CGFloat {
        switch stage {
        case .seed:          return 0.42
        case .sprout:        return 0.54
        case .seedling:      return 0.70
        case .youngTree:     return 0.84
        case .floweringTree: return 0.92
        case .fruitTree:     return 0.97
        case .memoryTree:    return 1.0
        }
    }
}
