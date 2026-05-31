import SwiftUI
import SwiftData
import XiaoyaGrowthCore

struct RecordEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let profile: BabyProfile
    let template: MilestoneTemplate?
    let onSaved: (MilestoneRecord) -> Void

    @State private var title: String
    @State private var note: String
    @State private var occurredAt: Date
    @State private var category: MilestoneCategory

    init(profile: BabyProfile, template: MilestoneTemplate?, onSaved: @escaping (MilestoneRecord) -> Void) {
        self.profile = profile
        self.template = template
        self.onSaved = onSaved
        _title = State(initialValue: template?.title == "自定义记录" ? "" : template?.title ?? "")
        _note = State(initialValue: template?.suggestion ?? "")
        _occurredAt = State(initialValue: Date())
        _category = State(initialValue: template?.category == .custom ? .grossMotor : template?.category ?? .grossMotor)
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var selectableCategories: [MilestoneCategory] {
        MilestoneCategory.allCases.filter { $0 != .custom }
    }

    var body: some View {
        Form {
            Section("成长瞬间") {
                TextField("节点名称", text: $title)
                    .accessibilityLabel("节点名称")

                Picker("分类", selection: $category) {
                    ForEach(selectableCategories, id: \.self) { category in
                        Text(category.title).tag(category)
                    }
                }

                DatePicker("发生日期", selection: $occurredAt, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                    .environment(\.calendar, Calendar(identifier: .gregorian))
                    .accessibilityLabel("发生日期")
            }

            Section("一句话描述") {
                TextEditor(text: $note)
                    .frame(minHeight: 120)
                    .accessibilityLabel("一句话描述")
            }

        }
        .scrollContentBackground(.hidden)
        .background(XiaoYaDesignTokens.Color.appBackground)
        .navigationTitle(template?.title == "自定义记录" ? "自定义记录" : "编辑记录")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("取消") {
                    dismiss()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            XiaoYaPrimaryButton(action: save) {
                Text("保存并点亮小树")
            }
            .disabled(!canSave)
            .opacity(canSave ? 1 : 0.45)
            .padding(.horizontal, XiaoYaDesignTokens.Spacing.page)
            .padding(.top, 8)
            .background(.ultraThinMaterial)
            .accessibilityLabel("保存成长记录")
        }
    }

    private func save() {
        guard canSave else { return }
        let decorationType = TreeStateCalculator.visibleDecorationType(for: category)
        let record = MilestoneRecord(
            babyId: profile.id,
            templateId: template?.id == MilestoneTemplate.customTemplate.id ? nil : template?.id,
            category: category,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            occurredAt: occurredAt,
            moodTags: [],
            visualElementType: decorationType
        )
        modelContext.insert(record)
        try? modelContext.save()
        onSaved(record)
    }
}
