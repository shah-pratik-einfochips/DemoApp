import SwiftUI

struct PrivacyView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            authSection
            dataSection
            trackingSection
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authSection: some View {
        Section {
            Toggle(isOn: $settings.isFaceIDEnabled) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.green.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "faceid")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Face ID / Touch ID")
                        Text("Require biometric authentication on launch")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            NavigationLink {
                PlaceholderDetailView(title: "Change Passcode")
            } label: {
                SettingsRow(
                    icon: "lock.fill",
                    iconColor: .blue,
                    title: "Change Passcode"
                )
            }

            NavigationLink {
                PlaceholderDetailView(title: "Two-Factor Authentication")
            } label: {
                SettingsRow(
                    icon: "shield.lefthalf.filled.badge.checkmark",
                    iconColor: .indigo,
                    title: "Two-Factor Authentication",
                    value: "On"
                )
            }
        } header: {
            Text("Authentication")
        }
    }

    private var dataSection: some View {
        Section {
            Toggle(isOn: $settings.isLocationEnabled) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.teal.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "location.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Location Services")
                        Text("Allow app to access your location")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            NavigationLink {
                PlaceholderDetailView(title: "Camera Access")
            } label: {
                SettingsRow(
                    icon: "camera.fill",
                    iconColor: .gray,
                    title: "Camera Access",
                    value: "Allowed"
                )
            }

            NavigationLink {
                PlaceholderDetailView(title: "Contacts")
            } label: {
                SettingsRow(
                    icon: "person.2.fill",
                    iconColor: .orange,
                    title: "Contacts",
                    value: "Denied"
                )
            }
        } header: {
            Text("App Permissions")
        }
    }

    private var trackingSection: some View {
        Section {
            Toggle(isOn: $settings.isAnalyticsEnabled) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.purple.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Analytics & Crash Reports")
                        Text("Help improve the app by sharing usage data")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            NavigationLink {
                PlaceholderDetailView(title: "Data & Privacy")
            } label: {
                SettingsRow(
                    icon: "hand.raised.fill",
                    iconColor: .pink,
                    title: "Data & Privacy Policy"
                )
            }
        } header: {
            Text("Data Collection")
        } footer: {
            Text("Usage data is anonymized and never sold to third parties.")
        }
    }
}

struct PlaceholderDetailView: View {
    let title: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 52))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text("This setting detail page is not yet implemented.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
            .environmentObject(AppSettings())
    }
}
