import Photos
import SwiftUI
import XiaoyaGrowthCore

struct ShareCardPreviewView: View {
    let profile: BabyProfile
    let record: MilestoneRecord
    let treeRecordCount: Int
    @Environment(\.dismiss) private var dismiss
    @State private var saveState: ShareCardSaveState?

    private var copy: ShareCardCopy {
        ShareCardCopyBuilder.shareCardText(profile: profile.draft, record: record.draft)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    ShareCardContent(copy: copy, record: record, treeRecordCount: treeRecordCount)
                        .padding(.horizontal, 20)

                    VStack(spacing: 12) {
                        ShareLink(item: shareText) {
                            Label("分享给家人", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                        }
                        .buttonStyle(.plain)
                        .background(XiaoYaDesignTokens.Color.primary)
                        .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))

                        Button {
                            saveCardImage()
                        } label: {
                            Label("保存图片", systemImage: "square.and.arrow.down")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                        }
                        .buttonStyle(.plain)
                        .background(XiaoYaDesignTokens.Color.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))

                        Button("稍后再说") {
                            dismiss()
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.secondary)
                    }
                    .font(.headline)
                    .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
                    .padding(.bottom, 24)
                }
                .padding(.top, 20)
            }
            .background(XiaoYaDesignTokens.Color.appBackground)
            .navigationTitle("纪念卡")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .alert(item: $saveState) { state in
                Alert(
                    title: Text(state.title),
                    message: Text(state.message),
                    dismissButton: .default(Text("知道了"))
                )
            }
        }
    }

    private var shareText: String {
        "\(copy.dayText)\n\(copy.title)\n\(copy.body)\n\(copy.watermark)"
    }

    @MainActor
    private func saveCardImage() {
        let renderer = ImageRenderer(content: ShareCardContent(copy: copy, record: record, treeRecordCount: treeRecordCount).frame(width: 360))
        renderer.scale = UIScreen.main.scale
        guard let image = renderer.uiImage else {
            saveState = .failure("纪念卡生成失败，请稍后再试。")
            return
        }

        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            writeImageToPhotoLibrary(image)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                Task { @MainActor in
                    if newStatus == .authorized || newStatus == .limited {
                        writeImageToPhotoLibrary(image)
                    } else {
                        saveState = .failure("没有相册写入权限，暂时无法保存图片。")
                    }
                }
            }
        default:
            saveState = .failure("没有相册写入权限，请在系统设置中允许小芽成长添加照片。")
        }
    }

    private func writeImageToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            Task { @MainActor in
                if success {
                    saveState = .success
                } else {
                    saveState = .failure(error?.localizedDescription ?? "保存失败，请稍后再试。")
                }
            }
        }
    }
}

private struct ShareCardContent: View {
    let copy: ShareCardCopy
    let record: MilestoneRecord
    let treeRecordCount: Int

    var body: some View {
        VStack(spacing: 18) {
            Text(copy.dayText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(XiaoYaDesignTokens.Color.primary)

            Text(copy.title)
                .font(XiaoYaDesignTokens.Font.importantNumber)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.72)
                .lineLimit(3)

            GrowthTreeView(recordCount: treeRecordCount, highlightLatest: true, animatesOnAppear: false, showsCaption: false)
            .frame(height: 320)
            .background(
                LinearGradient(
                    colors: [
                        XiaoYaDesignTokens.Color.softPrimary,
                        XiaoYaDesignTokens.Color.softSecondary
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 16, y: 8)

            Text(copy.body)
                .font(XiaoYaDesignTokens.Font.body.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .minimumScaleFactor(0.75)

            Text(copy.watermark)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(XiaoYaDesignTokens.Spacing.card)
        .frame(maxWidth: .infinity)
        .background(XiaoYaDesignTokens.Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 24, y: 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("纪念卡，\(copy.dayText)，\(copy.title)")
    }
}

private struct ShareCardSaveState: Identifiable {
    let id = UUID()
    let title: String
    let message: String

    static let success = ShareCardSaveState(title: "已保存", message: "纪念卡图片已经保存到系统相册。")

    static func failure(_ message: String) -> ShareCardSaveState {
        ShareCardSaveState(title: "保存失败", message: message)
    }
}
