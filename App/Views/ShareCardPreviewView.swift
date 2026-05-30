import SwiftUI
import XiaoyaGrowthCore

struct ShareCardPreviewView: View {
    let profile: BabyProfile
    let record: MilestoneRecord
    @Environment(\.dismiss) private var dismiss

    private var copy: ShareCardCopy {
        ShareCardCopyBuilder.shareCardText(profile: profile.draft, record: record.draft)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                shareCard
                    .padding(.horizontal, 24)

                ShareLink(
                    item: "\(copy.dayText)\n\(copy.title)\n\(copy.body)\n\(copy.watermark)"
                ) {
                    Label("分享纪念卡", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
            .background(Color(uiColor: .secondarySystemBackground))
            .navigationTitle("纪念卡")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var shareCard: some View {
        VStack(spacing: 18) {
            Text(copy.dayText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(uiColor: .systemGreen))

            Text(copy.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.72)

            GrowingTreeView(
                treeState: TreeState(
                    stage: .youngTree,
                    recordCount: 1,
                    decorations: [
                        TreeDecoration(
                            type: record.visualElementType,
                            category: record.category,
                            slotIndex: 0,
                            title: record.title
                        )
                    ]
                ),
                highlightLatest: true
            )
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            Text(copy.body)
                .font(.title3.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .minimumScaleFactor(0.75)

            Text(copy.watermark)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 24, y: 12)
    }
}
