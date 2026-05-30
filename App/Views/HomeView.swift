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
    @State private var showingShareCard = false

    private var treeState: TreeState {
        TreeStateCalculator.state(records: records.map(\.draft))
    }

    private var latestRecord: MilestoneRecord? {
        records.sorted { $0.occurredAt > $1.occurredAt }.first
    }

    private var selectedRecordForShare: MilestoneRecord? {
        guard let recordId = saveSuccess?.recordId else { return nil }
        return records.first { $0.id == recordId }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    header
                    GrowingTreeView(treeState: treeState, highlightLatest: saveSuccess != nil)
                        .frame(height: 360)
                        .accessibilityLabel("成长树，当前阶段 \(treeState.stage.title)，已点亮 \(treeState.recordCount) 个成长瞬间")
                    summary
                    primaryActions
                }
                .padding(20)
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: onRecord) {
                    Label("记录新成长", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .label))
                .padding(.horizontal, 20)
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
        .navigationTitle("小芽成长")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onHistory) {
                    Image(systemName: "clock.arrow.circlepath")
                }
                .accessibilityLabel("查看历史记录")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onSettings) {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("打开设置")
            }
        }
        .onChange(of: saveSuccess) { _, newValue in
            guard newValue != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showingShareCard = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    saveSuccess = nil
                }
            }
        }
        .sheet(isPresented: $showingShareCard) {
            if let record = selectedRecordForShare {
                ShareCardPreviewView(profile: profile, record: record)
            }
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
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("宝宝出生时间标签")
            .accessibilityHint("双击切换天数、月龄和下个月龄倒计时")

            Text("把每一个第一次，养成一棵会长大的小树。")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var summary: some View {
        VStack(spacing: 12) {
            Text(treeState.stage.message)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)

            Text("已点亮 \(treeState.recordCount) 个成长瞬间")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let latestRecord {
                Label("最近：\(latestRecord.title)", systemImage: "sparkle")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(Color(uiColor: .systemGreen))
            } else {
                Text("从今天起，记录每一个第一次。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var primaryActions: some View {
        Button(action: onHistory) {
            HStack {
                Label("查看历史记录", systemImage: "list.bullet.rectangle")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
