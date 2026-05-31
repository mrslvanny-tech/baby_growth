import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var nickname = "小芽"
    @State private var birthDate = SeedData.defaultBirthDate()

    private var canSubmit: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Text("欢迎来到小芽成长")
                        .font(XiaoYaDesignTokens.Font.title)
                        .multilineTextAlignment(.center)
                    Text("记录每一个第一次，\n看着小树慢慢长大。")
                        .font(XiaoYaDesignTokens.Font.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                XiaoYaCard {
                    VStack(spacing: 12) {
                        TextField("宝宝昵称", text: $nickname)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("宝宝昵称")

                        DatePicker("出生日期", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                            .environment(\.calendar, Calendar(identifier: .gregorian))
                            .accessibilityLabel("宝宝出生日期")
                    }
                }
            }
            .padding(XiaoYaDesignTokens.Spacing.page)
        }
        .safeAreaInset(edge: .bottom) {
            XiaoYaPrimaryButton {
                createProfile()
            } label: {
                Text("开始记录成长")
            }
            .disabled(!canSubmit)
            .opacity(canSubmit ? 1 : 0.45)
            .accessibilityLabel("开始记录成长")
            .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
            .padding(.top, 8)
            .background(.ultraThinMaterial)
        }
        .background(XiaoYaDesignTokens.Color.appBackground)
    }

    private func createProfile() {
        guard canSubmit else { return }
        let profile = BabyProfile(
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: birthDate,
            avatarLocalIdentifier: "seed-1"
        )
        modelContext.insert(profile)
    }
}
