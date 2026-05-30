import SwiftUI
import XiaoyaGrowthCore

struct HistoryListView: View {
    let profile: BabyProfile
    let records: [MilestoneRecord]

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView(
                    "还没有成长记录",
                    systemImage: "leaf",
                    description: Text("点亮第一个成长瞬间，小树就会开始变化。")
                )
            } else {
                ForEach(records) { record in
                    NavigationLink {
                        MilestoneDetailView(profile: profile, record: record)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(record.title)
                                .font(.headline)
                            Text(record.category.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(record.occurredAt, style: .date)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("历史记录")
    }
}

struct MilestoneDetailView: View {
    let profile: BabyProfile
    let record: MilestoneRecord
    @State private var showingShareCard = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(record.title)
                        .font(.largeTitle.bold())
                    Label(record.category.title, systemImage: "tag")
                        .foregroundStyle(.secondary)
                    Text(record.occurredAt, style: .date)
                        .foregroundStyle(.secondary)
                }

                if let note = record.note, !note.isEmpty {
                    Text(note)
                        .font(.body)
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }

                Button {
                    showingShareCard = true
                } label: {
                    Label("生成纪念卡", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
            }
            .padding(20)
        }
        .navigationTitle("成长详情")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShareCard) {
            ShareCardPreviewView(profile: profile, record: record)
        }
    }
}
