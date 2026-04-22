import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var showResetAlert = false

    var body: some View {
        List {
            profileSection
            appearanceSection
            textSection
            notificationsSection
            privacySection
            generalSection
            aboutSection
            resetSection
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Reset Settings", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) { settings.resetToDefaults() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will restore all settings to their default values.")
        }
    }

    private var profileSection: some View {
        Section {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(settings.accentColor.color.gradient)
                        .frame(width: 64, height: 64)
                    Text("PS")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pratik Shah")
                        .font(.headline)
                    Text("pratik@example.com")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 6)
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            NavigationLink {
                AppearanceView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "paintpalette.fill",
                    iconColor: .purple,
                    title: "Theme & Accent Color",
                    value: settings.theme.rawValue
                )
            }
        }
    }

    private var textSection: some View {
        Section("Text & Display") {
            NavigationLink {
                FontSettingsView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "textformat.size",
                    iconColor: .blue,
                    title: "Font & Typography",
                    value: settings.fontSize.rawValue
                )
            }
        }
    }

    private var notificationsSection: some View {
        Section("Notifications") {
            NavigationLink {
                NotificationsView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "bell.badge.fill",
                    iconColor: .red,
                    title: "Notifications",
                    value: settings.isNotificationsEnabled ? "On" : "Off"
                )
            }
        }
    }

    private var privacySection: some View {
        Section("Privacy & Security") {
            NavigationLink {
                PrivacyView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "lock.shield.fill",
                    iconColor: .green,
                    title: "Privacy & Security",
                    value: settings.isFaceIDEnabled ? "Face ID On" : nil
                )
            }
        }
    }

    private var generalSection: some View {
        Section("General") {
            NavigationLink {
                LanguageView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "globe",
                    iconColor: .teal,
                    title: "Language & Region",
                    value: "\(settings.language.flag) \(settings.language.rawValue)"
                )
            }

            Toggle(isOn: $settings.isAutoUpdateEnabled) {
                SettingsRow(
                    icon: "arrow.triangle.2.circlepath",
                    iconColor: .orange,
                    title: "Auto Updates"
                )
            }

            Toggle(isOn: $settings.isDataSaverEnabled) {
                SettingsRow(
                    icon: "antenna.radiowaves.left.and.right",
                    iconColor: .indigo,
                    title: "Data Saver"
                )
            }

            Toggle(isOn: $settings.isHapticsEnabled) {
                SettingsRow(
                    icon: "hand.tap.fill",
                    iconColor: .pink,
                    title: "Haptics"
                )
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                AboutView()
                    .environmentObject(settings)
            } label: {
                SettingsRow(
                    icon: "info.circle.fill",
                    iconColor: .gray,
                    title: "About App",
                    value: "v\(settings.appVersion)"
                )
            }
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                showResetAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("Reset All Settings")
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var value: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(iconColor.gradient)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(title)
            Spacer()
            if let value {
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppSettings())
    }
}
