import SwiftUI
import SwiftData

@main
struct XiaoyaGrowthApp: App {
    private let container: ModelContainer = {
        let schema = Schema([
            BabyProfile.self,
            MilestoneRecord.self
        ])
        let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing")
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isUITesting,
            cloudKitDatabase: isUITesting ? .none : .private("iCloud.com.xiaoyagrowth.app")
        )
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Unable to create model container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(container)
    }
}
