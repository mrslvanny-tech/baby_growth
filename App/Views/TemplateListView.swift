import SwiftUI
import XiaoyaGrowthCore

struct TemplateListView: View {
    let onSelect: (MilestoneTemplate?) -> Void
    @State private var searchText = ""

    private var groupedTemplates: [(MilestoneCategory, [MilestoneTemplate])] {
        MilestoneCategory.allCases.compactMap { category in
            let templates = MilestoneTemplates.all.filter { template in
                template.category == category && matchesSearch(template)
            }
            return templates.isEmpty ? nil : (category, templates)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: XiaoYaDesignTokens.Spacing.section) {
                topControls

                ForEach(groupedTemplates, id: \.0) { category, templates in
                    VStack(alignment: .leading, spacing: 12) {
                        Label(category.title, systemImage: icon(for: category))
                            .font(.headline)
                            .foregroundStyle(color(for: category))
                            .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(templates) { template in
                                templateCard(template)
                            }
                        }
                        .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
                    }
                }

                Button {
                    onSelect(.customTemplate)
                } label: {
                    Label("自定义记录", systemImage: "plus.circle")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .overlay {
                            RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                                .foregroundStyle(Color(uiColor: .systemGray4))
                        }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("记录新成长")
        .navigationBarTitleDisplayMode(.large)
        .background(XiaoYaDesignTokens.Color.appBackground)
    }

    private var topControls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("搜索成长瞬间...", text: $searchText)
                    .textInputAutocapitalization(.never)
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(XiaoYaDesignTokens.Color.cardBackground)
            .clipShape(Capsule())

            Label("选择一个成长模板，或创建自定义记录", systemImage: "rectangle.grid.2x2")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
        .padding(.top, 16)
    }

    private func templateCard(_ template: MilestoneTemplate) -> some View {
        Button {
            onSelect(template)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(template.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                Text(template.suggestion)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .padding(XiaoYaDesignTokens.Spacing.card)
            .background(XiaoYaDesignTokens.Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: XiaoYaDesignTokens.Radius.card, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(template.title)
    }

    private func matchesSearch(_ template: MilestoneTemplate) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return template.title.localizedCaseInsensitiveContains(query)
            || template.suggestion.localizedCaseInsensitiveContains(query)
            || template.category.title.localizedCaseInsensitiveContains(query)
    }

    private func icon(for category: MilestoneCategory) -> String {
        switch category {
        case .grossMotor: return "figure.walk"
        case .fineMotor: return "hand.raised"
        case .language: return "message"
        case .socialEmotion: return "sparkles"
        case .dailyHabit: return "sun.max"
        case .anniversary: return "flag"
        case .custom: return "square.and.pencil"
        }
    }

    private func color(for category: MilestoneCategory) -> Color {
        switch category {
        case .grossMotor: return Color(uiColor: .systemGreen)
        case .fineMotor: return Color(uiColor: .systemMint)
        case .language: return Color(uiColor: .systemBlue)
        case .socialEmotion: return Color(uiColor: .systemPink)
        case .dailyHabit: return Color(uiColor: .systemOrange)
        case .anniversary: return Color(uiColor: .systemYellow)
        case .custom: return Color(uiColor: .systemGray)
        }
    }
}
