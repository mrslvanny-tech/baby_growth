import CloudKit
import SwiftUI
import XiaoyaGrowthCore

struct SettingsView: View {
    @Bindable var profile: BabyProfile
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var draftName = ""
    @State private var draftBirthDate = Date()
    @State private var avatarSeed = 1
    @State private var showingToast = false
    @State private var iCloudAvailability: ICloudSyncAvailability = .unknown

    var body: some View {
        Form {
            Section("个人信息") {
                HStack(spacing: 16) {
                    AvatarSeedView(seed: avatarSeed, size: 64)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.nickname)
                            .font(.headline)
                        Text("宝宝档案")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if isEditing {
                        Button {
                            avatarSeed = (avatarSeed % 6) + 1
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .accessibilityLabel("随机切换头像")
                    }
                }

                if isEditing {
                    TextField("宝宝昵称", text: $draftName)
                        .accessibilityLabel("宝宝昵称")

                    DatePicker("出生日期", selection: $draftBirthDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                        .environment(\.calendar, Calendar(identifier: .gregorian))
                        .accessibilityLabel("宝宝出生日期")
                } else {
                    LabeledContent("宝宝昵称") {
                        Text(profile.nickname)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("出生日期") {
                        Text(profile.birthDate.formatted(.dateTime.locale(Locale(identifier: "zh_Hans_CN")).year().month().day()))
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("宝宝出生日期，\(profile.birthDate.formatted(.dateTime.locale(Locale(identifier: "zh_Hans_CN")).year().month().day()))")
                }
            }

            Section("iCloud 同步") {
                iCloudStatusView
            }

            Section("支持与关于") {
                NavigationLink("数据说明") {
                    Text("小芽成长 V1 会在系统 iCloud 可用时同步宝宝资料和成长记录；图片暂时仅保留在本机。")
                        .padding()
                        .navigationTitle("数据说明")
                }
                NavigationLink("隐私说明") {
                    Text("产品不提供医学评估，不判断发育快慢，只用于家庭纪念记录。")
                        .padding()
                        .navigationTitle("隐私说明")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(XiaoYaDesignTokens.Color.appBackground)
        .navigationTitle("设置")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "保存" : "编辑") {
                    isEditing ? save() : startEditing()
                }
                .disabled(isEditing && draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .overlay(alignment: .top) {
            if showingToast {
                SuccessToast(title: "设置已保存")
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onAppear {
            draftName = profile.nickname
            draftBirthDate = profile.birthDate
            avatarSeed = seedFromIdentifier(profile.avatarLocalIdentifier)
            refreshICloudStatus()
        }
    }

    private var iCloudStatusView: some View {
        let copy = ICloudSyncStatusCopyBuilder.copy(for: iCloudAvailability)
        return VStack(alignment: .leading, spacing: 10) {
            Label(copy.title, systemImage: iCloudStatusIcon)
                .font(.headline)
                .foregroundStyle(iCloudStatusColor)
            Text(copy.message)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text("最近更新：\(profile.updatedAt.formatted(.dateTime.locale(Locale(identifier: "zh_Hans_CN")).month().day().hour().minute()))")
                .font(.caption)
                .foregroundStyle(.tertiary)
            if let actionTitle = copy.actionTitle {
                Button(actionTitle) {
                    openSystemSettings()
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private var iCloudStatusIcon: String {
        switch iCloudAvailability {
        case .available:
            return "checkmark.icloud.fill"
        case .unknown:
            return "icloud"
        default:
            return "exclamationmark.icloud"
        }
    }

    private var iCloudStatusColor: Color {
        switch iCloudAvailability {
        case .available:
            return XiaoYaDesignTokens.Color.primary
        case .unknown:
            return .secondary
        default:
            return Color(uiColor: .systemOrange)
        }
    }

    private func startEditing() {
        draftName = profile.nickname
        draftBirthDate = profile.birthDate
        avatarSeed = seedFromIdentifier(profile.avatarLocalIdentifier)
        withAnimation {
            isEditing = true
        }
    }

    private func save() {
        profile.nickname = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.birthDate = draftBirthDate
        profile.avatarLocalIdentifier = "seed-\(avatarSeed)"
        profile.updatedAt = Date()
        withAnimation {
            isEditing = false
            showingToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingToast = false
            }
        }
    }

    private func refreshICloudStatus() {
        Task {
            let status: CKAccountStatus
            do {
                status = try await CKContainer(identifier: "iCloud.com.xiaoyagrowth.app").accountStatus()
            } catch {
                await MainActor.run {
                    iCloudAvailability = .temporarilyUnavailable
                }
                return
            }

            await MainActor.run {
                switch status {
                case .available:
                    iCloudAvailability = .available
                case .noAccount:
                    iCloudAvailability = .noAccount
                case .restricted:
                    iCloudAvailability = .restricted
                case .couldNotDetermine:
                    iCloudAvailability = .temporarilyUnavailable
                case .temporarilyUnavailable:
                    iCloudAvailability = .temporarilyUnavailable
                @unknown default:
                    iCloudAvailability = .unknown
                }
            }
        }
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func seedFromIdentifier(_ identifier: String?) -> Int {
        guard let identifier,
              let value = Int(identifier.replacingOccurrences(of: "seed-", with: "")) else {
            return 1
        }
        return max(1, min(value, 6))
    }
}
