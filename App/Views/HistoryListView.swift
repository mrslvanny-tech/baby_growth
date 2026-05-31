import SwiftUI
import SwiftData
import XiaoyaGrowthCore

struct HistoryListView: View {
    let profile: BabyProfile
    let records: [MilestoneRecord]

    var body: some View {
        ScrollView {
            if records.isEmpty {
                XiaoYaEmptyState(
                    title: "还没有成长记录",
                    message: "点亮第一个成长瞬间，小树就会开始变化。",
                    systemImage: "leaf.fill"
                )
                .padding(XiaoYaDesignTokens.Spacing.page)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(records) { record in
                        NavigationLink {
                            MilestoneDetailView(profile: profile, record: record, treeRecordCount: records.count)
                        } label: {
                            XiaoYaCard {
                                HStack(spacing: 12) {
                                    Image(systemName: "leaf.fill")
                                        .foregroundStyle(XiaoYaDesignTokens.Color.primary)
                                        .frame(width: 34, height: 34)
                                        .background(XiaoYaDesignTokens.Color.softPrimary)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(record.title)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text(record.category.title)
                                            .font(XiaoYaDesignTokens.Font.caption)
                                            .foregroundStyle(.secondary)
                                        Text(record.occurredAt, style: .date)
                                            .font(XiaoYaDesignTokens.Font.caption)
                                            .foregroundStyle(.tertiary)
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(XiaoYaDesignTokens.Spacing.page)
            }
        }
        .navigationTitle("历史记录")
        .background(XiaoYaDesignTokens.Color.appBackground)
    }
}

struct MilestoneDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let profile: BabyProfile
    let record: MilestoneRecord
    let treeRecordCount: Int
    @State private var showingShareCard = false
    @State private var showingDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: XiaoYaDesignTokens.Spacing.section) {
                XiaoYaCard {
                    VStack(alignment: .leading, spacing: 10) {
                    Text(record.title)
                        .font(XiaoYaDesignTokens.Font.title)
                    Label(record.category.title, systemImage: "tag")
                        .foregroundStyle(.secondary)
                    Text(record.occurredAt, style: .date)
                        .font(XiaoYaDesignTokens.Font.note)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let note = record.note, !note.isEmpty {
                    XiaoYaCard {
                        Text(note)
                            .font(XiaoYaDesignTokens.Font.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                XiaoYaPrimaryButton {
                    showingShareCard = true
                } label: {
                    Label("生成纪念卡", systemImage: "square.and.arrow.up")
                }
            }
            .padding(XiaoYaDesignTokens.Spacing.page)
        }
        .navigationTitle("成长详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("删除成长记录")
            }
        }
        .background(XiaoYaDesignTokens.Color.appBackground)
        .sheet(isPresented: $showingShareCard) {
            ShareCardPreviewView(profile: profile, record: record, treeRecordCount: treeRecordCount)
        }
        .confirmationDialog(
            "删除这条成长记录？",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("删除记录", role: .destructive) {
                deleteRecord()
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("删除后会从使用 iCloud 的设备中移除，首页小树会按剩余记录重新计算。")
        }
    }

    private func deleteRecord() {
        modelContext.delete(record)
        try? modelContext.save()
        dismiss()
    }
}
