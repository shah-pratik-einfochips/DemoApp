import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            appInfoSection
            linksSection
            legalSection
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var appInfoSection: some View {
        Section {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(settings.accentColor.color.gradient)
                        .frame(width: 90, height: 90)
                        .shadow(color: settings.accentColor.color.opacity(0.4), radius: 10, y: 4)
                    Image(systemName: "gear.badge.checkmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 6) {
                    Text("Settings App")
                        .font(.title2.bold())
                    Text("Version \(settings.appVersion) (Build \(settings.buildNumber))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
    }

    private var linksSection: some View {
        Section("Resources") {
            AboutLinkRow(icon: "star.fill", color: .yellow, title: "Rate on App Store") {}
            AboutLinkRow(icon: "envelope.fill", color: .blue, title: "Send Feedback") {}
            AboutLinkRow(icon: "questionmark.circle.fill", color: .teal, title: "Help & Support") {}
            AboutLinkRow(icon: "square.and.arrow.up", color: .orange, title: "Share App") {}
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            AboutLinkRow(icon: "doc.text.fill", color: .gray, title: "Terms of Service") {}
            AboutLinkRow(icon: "hand.raised.fill", color: .pink, title: "Privacy Policy") {}
            AboutLinkRow(icon: "c.circle.fill", color: .secondary, title: "Acknowledgements") {}

            HStack {
                Text("© 2025 Demo Corp. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}

struct AboutLinkRow: View {
    let icon: String
    let color: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(color.gradient)
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
            .environmentObject(AppSettings())
    }
}
