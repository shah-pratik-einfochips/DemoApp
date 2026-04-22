import SwiftUI
import LoginKit

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                SettingsView()
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            ))
        } else {
            LoginView(
                onSuccess: { credentials in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isLoggedIn = true
                    }
                },
                onFailure: { error in
                    print("Login failed: \(error)")
                }
            )
            .transition(.asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            ))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSettings())
}
