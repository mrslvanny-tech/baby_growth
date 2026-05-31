import SwiftUI
import XiaoyaGrowthCore

struct HomeView: View {
    @Bindable var profile: BabyProfile
    let records: [MilestoneRecord]
    @Binding var saveSuccess: SaveSuccessState?
    let onRecord: () -> Void
    let onHistory: () -> Void
    let onSettings: () -> Void

    @State private var timeMode: TimeTagMode = .days
    @State private var shareRecord: MilestoneRecord?

    var body: some View {
        ZStack(alignment: .top) {
            XiaoYaDesignTokens.Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: XiaoYaDesignTokens.Spacing.section) {
                    header
                    growthTreeHero
                }
                .padding(XiaoYaDesignTokens.Spacing.page)
            }
            .safeAreaInset(edge: .bottom) {
                XiaoYaPrimaryButton(action: onRecord) {
                    Label("记录新成长", systemImage: "plus.circle.fill")
                }
                .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
                .padding(.top, 8)
                .background(.ultraThinMaterial)
                .accessibilityLabel("记录新成长")
            }

            if let saveSuccess {
                SuccessToast(title: "已点亮芽点：\(saveSuccess.title)")
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onHistory) {
                    Image(systemName: "clock.arrow.circlepath")
                }
                .accessibilityLabel("查看历史记录")
            }
            ToolbarItem(placement: .principal) {
                Text("\(profile.nickname)成长记录")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(.secondary)
                    .opacity(0.6)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onSettings) {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("打开设置")
            }
        }
        .onChange(of: saveSuccess) { _, newValue in
            guard let newValue else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                openShareCard(for: newValue.recordId)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    saveSuccess = nil
                }
            }
        }
        .onChange(of: records.count) { _, _ in
            guard let recordId = saveSuccess?.recordId, shareRecord == nil else { return }
            openShareCard(for: recordId)
        }
        .sheet(item: $shareRecord) { record in
            ShareCardPreviewView(profile: profile, record: record, treeRecordCount: records.count)
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            Button {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                    timeMode = timeMode.next()
                }
            } label: {
                Text(TimeCalculator.timeTagText(mode: timeMode, profile: profile.draft))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
                    .background(XiaoYaDesignTokens.Color.cardBackground)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("宝宝出生时间标签")
            .accessibilityHint("双击切换天数、月龄和下个月龄倒计时")

            Text("每一个第一次，\n都会让小树长出一片叶子")
                .font(XiaoYaDesignTokens.Font.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var growthTreeHero: some View {
        GrowthTreeView(recordCount: records.count, highlightLatest: saveSuccess != nil)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 340)
        .padding(.vertical, 8)
    }

    private func openShareCard(for recordId: UUID) {
        shareRecord = records.first { $0.id == recordId }
    }
}
