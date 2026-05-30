import SwiftUI
import SwiftData

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BabyProfile.createdAt) private var profiles: [BabyProfile]

    var body: some View {
        if let profile = profiles.first {
            MainNavigationView(profile: profile)
        } else {
            OnboardingView()
        }
    }
}

struct MainNavigationView: View {
    @Bindable var profile: BabyProfile
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MilestoneRecord.occurredAt, order: .reverse) private var records: [MilestoneRecord]
    @State private var path: [AppRoute] = []
    @State private var saveSuccess: SaveSuccessState?

    var profileRecords: [MilestoneRecord] {
        records.filter { $0.babyId == profile.id }
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                profile: profile,
                records: profileRecords,
                saveSuccess: $saveSuccess,
                onRecord: { path.append(.templates) },
                onHistory: { path.append(.history) },
                onSettings: { path.append(.settings) }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .templates:
                    TemplateListView { template in
                        path.append(.editor(templateId: template?.id))
                    }
                case .editor(let templateId):
                    RecordEditorView(
                        profile: profile,
                        template: template(for: templateId),
                        onSaved: { record in
                            path.removeAll()
                            saveSuccess = SaveSuccessState(
                                id: UUID(),
                                title: record.title,
                                recordId: record.id
                            )
                        }
                    )
                case .history:
                    HistoryListView(profile: profile, records: profileRecords)
                case .settings:
                    SettingsView(profile: profile)
                }
            }
        }
    }

    private func template(for id: String?) -> MilestoneTemplate? {
        guard let id else { return nil }
        if id == MilestoneTemplate.customTemplate.id { return .customTemplate }
        return MilestoneTemplates.all.first { $0.id == id }
    }
}
