import SwiftUI
import XiaoyaGrowthCore

struct GrowthTreeView: View {
    let recordCount: Int
    var highlightLatest: Bool = false
    var animatesOnAppear: Bool = true
    var showsCaption: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var displayedImageName: String
    @State private var previousImageName: String?
    @State private var isAnimating = false
    @State private var showParticles = false
    @State private var glowRadius: CGFloat = 8
    @State private var hasAppeared = false

    private var forestState: GrowthForestState {
        GrowthForestState(recordCount: recordCount)
    }

    init(recordCount: Int, highlightLatest: Bool = false, animatesOnAppear: Bool = true, showsCaption: Bool = true) {
        self.recordCount = recordCount
        self.highlightLatest = highlightLatest
        self.animatesOnAppear = animatesOnAppear
        self.showsCaption = showsCaption
        _displayedImageName = State(initialValue: GrowthForestState(recordCount: recordCount).imageName)
    }

    var body: some View {
            VStack(spacing: 12) {
                ZStack {
            // 替换图片树为像素树叶树
                PixelGrowingTreeView(
                treeState: TreeStateCalculator.state(
                    records: (0..<recordCount).map { _ in
                        MilestoneRecordDraft(
                            category: .custom,
                            title: "",
                            occurredAt: Date()
                        )
                    }
                ),
                highlightLatest: highlightLatest
            )

            if showParticles && !reduceMotion {
                LeafParticlesView()
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
            .animation(.easeInOut(duration: reduceMotion ? 0.25 : 0.45), value: isAnimating)
            .animation(.easeInOut(duration: 0.2), value: showParticles)
            .animation(.easeInOut(duration: 0.22), value: glowRadius)

            if showsCaption {
                Text(forestState.headline)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(forestState.subheadline)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            displayedImageName = forestState.imageName
        }
        .onChange(of: recordCount) { _, newValue in
            transitionToStage(for: newValue)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("成长树，\(forestState.headline)，\(forestState.subheadline)")
    }

    private func transitionToStage(for count: Int) {
        let nextImageName = GrowthForestState(recordCount: count).imageName
        guard nextImageName != displayedImageName else { return }

        guard animatesOnAppear else {
            displayedImageName = nextImageName
            previousImageName = nil
            isAnimating = false
            showParticles = false
            glowRadius = 8
            return
        }

        previousImageName = displayedImageName
        displayedImageName = nextImageName
        isAnimating = false
        showParticles = false
        glowRadius = 4

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: reduceMotion ? 0.25 : 0.45)) {
                isAnimating = true
            }

            if reduceMotion {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                    previousImageName = nil
                    isAnimating = false
                    glowRadius = 8
                }
            } else {
                withAnimation(.easeOut(duration: 0.22)) {
                    glowRadius = 18
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    showParticles = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        glowRadius = 8
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.76) {
                    previousImageName = nil
                    isAnimating = false
                    showParticles = false
                }
            }
        }
    }
}

private struct LeafParticlesView: View {
    private let particles = LeafParticle.defaultParticles

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                LeafParticleView(particle: particle)
            }
        }
        .frame(width: 260, height: 210)
        .allowsHitTesting(false)
    }
}

private struct LeafParticleView: View {
    let particle: LeafParticle
    @State private var floated = false

    var body: some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: particle.size, weight: .semibold))
            .foregroundStyle(Color.green.opacity(0.72))
            .rotationEffect(.degrees(floated ? particle.endRotation : particle.startRotation))
            .offset(
                x: floated ? particle.endOffset.width : particle.startOffset.width,
                y: floated ? particle.endOffset.height : particle.startOffset.height
            )
            .scaleEffect(floated ? 0.78 : 0.55)
            .opacity(floated ? 0 : 1)
            .onAppear {
                withAnimation(
                    .easeOut(duration: particle.duration)
                    .delay(particle.delay)
                ) {
                    floated = true
                }
            }
    }
}

private struct LeafParticle: Identifiable {
    let id = UUID()
    let startOffset: CGSize
    let endOffset: CGSize
    let startRotation: Double
    let endRotation: Double
    let size: CGFloat
    let delay: Double
    let duration: Double

    static let defaultParticles: [LeafParticle] = [
        LeafParticle(
            startOffset: CGSize(width: -42, height: -22),
            endOffset: CGSize(width: -58, height: -72),
            startRotation: -18,
            endRotation: -42,
            size: 15,
            delay: 0.02,
            duration: 0.48
        ),
        LeafParticle(
            startOffset: CGSize(width: 12, height: -38),
            endOffset: CGSize(width: 4, height: -92),
            startRotation: 8,
            endRotation: 28,
            size: 13,
            delay: 0.08,
            duration: 0.52
        ),
        LeafParticle(
            startOffset: CGSize(width: 48, height: -18),
            endOffset: CGSize(width: 70, height: -64),
            startRotation: 22,
            endRotation: 52,
            size: 16,
            delay: 0.04,
            duration: 0.5
        ),
        LeafParticle(
            startOffset: CGSize(width: -6, height: -10),
            endOffset: CGSize(width: -22, height: -58),
            startRotation: -6,
            endRotation: -24,
            size: 12,
            delay: 0.12,
            duration: 0.44
        )
    ]
}
