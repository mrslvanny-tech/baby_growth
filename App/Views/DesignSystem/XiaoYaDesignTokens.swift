import SwiftUI

enum XiaoYaDesignTokens {
    enum Color {
        static let appBackground = SwiftUI.Color(uiColor: .systemGroupedBackground)
        static let cardBackground = SwiftUI.Color(uiColor: .secondarySystemGroupedBackground)
        static let elevatedBackground = SwiftUI.Color(uiColor: .systemBackground)
        static let primary = SwiftUI.Color(uiColor: .systemGreen)
        static let secondary = SwiftUI.Color(uiColor: .systemMint)
        static let softPrimary = SwiftUI.Color(uiColor: .systemGreen).opacity(0.14)
        static let softSecondary = SwiftUI.Color(uiColor: .systemMint).opacity(0.18)
    }

    enum Radius {
        static let card: CGFloat = 20
        static let pill: CGFloat = 999
    }

    enum Spacing {
        static let page: CGFloat = 20
        static let card: CGFloat = 16
        static let section: CGFloat = 24
        static let compact: CGFloat = 8
    }

    enum Font {
        static let title = SwiftUI.Font.title2.bold()
        static let importantNumber = SwiftUI.Font.largeTitle.weight(.semibold)
        static let body = SwiftUI.Font.body
        static let note = SwiftUI.Font.footnote
        static let caption = SwiftUI.Font.caption
    }
}
