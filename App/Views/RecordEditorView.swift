import SwiftUI
import SwiftData
import PhotosUI
import XiaoyaGrowthCore

struct RecordEditorView: View {
    @Environment(\.modelContext) private var modelContext
    let profile: BabyProfile
    let template: MilestoneTemplate?
    let onSaved: (MilestoneRecord) -> Void

    @State private var title: String
    @State private var note: String
    @State private var occurredAt: Date
    @State private var category: MilestoneCategory
    @State private var moodTag: String = "开心"
    @State private var photoItem: PhotosPickerItem?
    @State private var mediaLocalIdentifiers: [String] = []

    init(profile: BabyProfile, template: MilestoneTemplate?, onSaved: @escaping (MilestoneRecord) -> Void) {
        self.profile = profile
        self.template = template
        self.onSaved = onSaved
        _title = State(initialValue: template?.title == "自定义记录" ? "" : template?.title ?? "")
        _note = State(initialValue: template?.suggestion ?? "")
        _occurredAt = State(initialValue: Date())
        _category = State(initialValue: template?.category ?? .custom)
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("成长瞬间") {
                TextField("节点名称", text: $title)
                    .accessibilityLabel("节点名称")

                Picker("分类", selection: $category) {
                    ForEach(MilestoneCategory.allCases, id: \.self) { category in
                        Text(category.title).tag(category)
                    }
                }

                DatePicker("发生日期", selection: $occurredAt, displayedComponents: .date)
                    .accessibilityLabel("发生日期")
            }

            Section("一句话描述") {
                TextEditor(text: $note)
                    .frame(minHeight: 120)
                    .accessibilityLabel("一句话描述")
            }

            Section("照片") {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Label(
                        mediaLocalIdentifiers.isEmpty ? "选择一张照片" : "已选择照片",
                        systemImage: "photo"
                    )
                }
                .onChange(of: photoItem) { _, newValue in
                    if newValue != nil {
                        mediaLocalIdentifiers = ["local-photo-placeholder"]
                    }
                }
                Text("V1 本地保存照片引用；上架前接入 PhotosPicker 的持久化标识。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("心情") {
                Picker("心情标签", selection: $moodTag) {
                    Text("开心").tag("开心")
                    Text("惊喜").tag("惊喜")
                    Text("感动").tag("感动")
                    Text("平静").tag("平静")
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle(template?.title == "自定义记录" ? "自定义记录" : "编辑记录")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: save) {
                Text("保存并点亮小树")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(uiColor: .systemGreen))
            .disabled(!canSave)
            .padding(.horizontal, 20)
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
            mediaLocalIdentifiers: mediaLocalIdentifiers,
            moodTags: [moodTag],
            visualElementType: decorationType
        )
        modelContext.insert(record)
        onSaved(record)
    }
}
