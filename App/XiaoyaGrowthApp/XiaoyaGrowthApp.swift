import SwiftUI
import SwiftData

@main
struct XiaoyaGrowthApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(for: [
            BabyProfile.self,
            MilestoneRecord.self
        ])
    }
}
