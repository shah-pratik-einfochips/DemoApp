import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            themeSection
            accentColorSection
            previewSection
        }
        .navigationTitle("Theme & Accent Color")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var themeSection: some View {
        Section {
            ForEach(AppTheme.allCases) { theme in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        settings.theme = theme
                    }
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(themeBackground(theme))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle().strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                                )
                            Image(systemName: theme.icon)
                                .font(.system(size: 17))
                                .foregroundStyle(themeIconColor(theme))
                        }
                        Text(theme.rawValue)
                            .foregroundStyle(.primary)
                        Spacer()
                        if settings.theme == theme {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(settings.accentColor.color)
                                .font(.title3)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            Text("App Theme")
        } footer: {
            Text("System theme follows your device's appearance settings.")
        }
    }

    private var accentColorSection: some View {
        Section("Accent Color") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 16) {
                ForEach(AppAccentColor.allCases) { accent in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            settings.accentColor = accent
                        }
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(accent.color.gradient)
                                    .frame(width: 48, height: 48)
                                    .shadow(color: accent.color.opacity(0.4), radius: 4, y: 2)
                                if settings.accentColor == accent {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            Text(accent.rawValue)
                                .font(.caption2)
                                .foregroundStyle(settings.accentColor == accent ? accent.color : .secondary)
                                .fontWeight(settings.accentColor == accent ? .semibold : .regular)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var previewSection: some View {
        Section("Preview") {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sample Text")
                            .font(.headline)
                        Text("This is how your app will look with the selected theme and accent color.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                HStack(spacing: 12) {
                    Button("Primary") {}
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)

                    Button("Secondary") {}
                        .buttonStyle(.bordered)
                        .controlSize(.regular)

                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                }

                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(settings.accentColor.color.opacity(0.15 + Double(i) * 0.25))
                            .frame(height: 40)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func themeBackground(_ theme: AppTheme) -> Color {
        switch theme {
        case .system: return Color(.systemBackground)
        case .light:  return Color(.systemBackground)
        case .dark:   return Color(.systemGray6)
        }
    }

    private func themeIconColor(_ theme: AppTheme) -> Color {
        switch theme {
        case .system: return .primary
        case .light:  return .orange
        case .dark:   return .indigo
        }
    }
}

#Preview {
    NavigationStack {
        AppearanceView()
            .environmentObject(AppSettings())
    }
}
