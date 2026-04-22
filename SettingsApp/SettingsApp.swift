import SwiftUI

@main
struct SettingsApp: App {
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .preferredColorScheme(settings.theme.colorScheme)
                .accentColor(settings.accentColor.color)
                .environment(\.sizeCategory,
                              settings.isDynamicTypeEnabled
                              ? settings.fontSize.sizeCategory
                              : .medium)
        }
    }
}
