import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var nickname = "小芽"
    @State private var birthDate = SeedData.defaultBirthDate()
    @State private var avatarSeed = 1

    private var canSubmit: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 24)

            VStack(spacing: 12) {
                AvatarSeedView(seed: avatarSeed, size: 92)
                Button {
                    avatarSeed = (avatarSeed % 6) + 1
                } label: {
                    Label("换一个头像", systemImage: "arrow.triangle.2.circlepath")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("随机切换宝宝头像")
            }

            VStack(spacing: 8) {
                Text("先认识一下你的小芽")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Text("之后我们会帮你自动计算宝宝来到世界的第几天。")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                TextField("宝宝昵称", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("宝宝昵称")

                DatePicker("出生日期", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .accessibilityLabel("宝宝出生日期")
            }
            .padding(20)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            Spacer()

            Button {
                createProfile()
            } label: {
                Text("开始记录成长")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(uiColor: .systemGreen))
            .disabled(!canSubmit)
            .accessibilityLabel("开始记录成长")
        }
        .padding(24)
        .background(Color(uiColor: .secondarySystemBackground))
    }

    private func createProfile() {
        guard canSubmit else { return }
        let profile = BabyProfile(
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: birthDate,
            avatarLocalIdentifier: "seed-\(avatarSeed)"
        )
        modelContext.insert(profile)
    }
}
