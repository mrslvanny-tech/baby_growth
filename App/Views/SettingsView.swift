import SwiftUI

struct SettingsView: View {
    @Bindable var profile: BabyProfile
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var draftName = ""
    @State private var draftBirthDate = Date()
    @State private var avatarSeed = 1
    @State private var showingToast = false

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

                TextField("宝宝昵称", text: $draftName)
                    .disabled(!isEditing)
                    .accessibilityLabel("宝宝昵称")

                DatePicker("出生日期", selection: $draftBirthDate, displayedComponents: .date)
                    .disabled(!isEditing)
                    .accessibilityLabel("宝宝出生日期")
            }

            Section("支持与关于") {
                NavigationLink("数据说明") {
                    Text("小芽成长 V1 所有数据仅保存在本机，不上传服务器；iCloud 同步会作为后续版本单独设计。")
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

    private func seedFromIdentifier(_ identifier: String?) -> Int {
        guard let identifier,
              let value = Int(identifier.replacingOccurrences(of: "seed-", with: "")) else {
            return 1
        }
        return max(1, min(value, 6))
    }
}
