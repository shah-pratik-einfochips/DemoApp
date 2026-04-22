import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        NavigationStack {
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSettings())
}
