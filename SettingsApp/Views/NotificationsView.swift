import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            masterSection
            if settings.isNotificationsEnabled {
                alertStyleSection
                scheduleSection
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.25), value: settings.isNotificationsEnabled)
    }

    private var masterSection: some View {
        Section {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill((settings.isNotificationsEnabled ? Color.red : Color.gray).gradient)
                        .frame(width: 48, height: 48)
                    Image(systemName: settings.isNotificationsEnabled ? "bell.badge.fill" : "bell.slash.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Allow Notifications")
                        .font(.headline)
                    Text(settings.isNotificationsEnabled ? "Notifications are enabled" : "All notifications are muted")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Toggle("", isOn: $settings.isNotificationsEnabled)
                    .labelsHidden()
            }
            .padding(.vertical, 4)
        } footer: {
            Text("Notifications keep you updated with important alerts and activity from the app.")
        }
    }

    private var alertStyleSection: some View {
        Section("Alert Style") {
            Toggle(isOn: $settings.isSoundEnabled) {
                SettingsRow(
                    icon: "speaker.wave.3.fill",
                    iconColor: .orange,
                    title: "Sound"
                )
            }

            Toggle(isOn: $settings.isBadgeEnabled) {
                SettingsRow(
                    icon: "app.badge.fill",
                    iconColor: .red,
                    title: "Badge Count"
                )
            }

            Toggle(isOn: $settings.isHapticsEnabled) {
                SettingsRow(
                    icon: "waveform.path",
                    iconColor: .purple,
                    title: "Vibration"
                )
            }
        }
    }

    private var scheduleSection: some View {
        Section {
            NotificationTimeRow(icon: "moon.stars.fill", color: .indigo,
                                title: "Do Not Disturb",
                                subtitle: "11:00 PM – 7:00 AM")
            NotificationTimeRow(icon: "calendar.badge.clock", color: .blue,
                                title: "Scheduled Summary",
                                subtitle: "Daily at 9:00 AM")
            NotificationTimeRow(icon: "bell.and.waves.left.and.right.fill", color: .teal,
                                title: "Breaking Alerts",
                                subtitle: "Always delivered")
        } header: {
            Text("Delivery Schedule")
        }
    }
}

struct NotificationTimeRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color.gradient)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
            .environmentObject(AppSettings())
    }
}
