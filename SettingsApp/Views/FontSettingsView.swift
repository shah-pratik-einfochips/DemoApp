import SwiftUI

struct FontSettingsView: View {
    @EnvironmentObject var settings: AppSettings

    private let sampleText = "The quick brown fox jumps over the lazy dog."

    var body: some View {
        List {
            fontSizeSection
            dynamicTypeSection
            textDisplaySection
            previewSection
        }
        .navigationTitle("Font & Typography")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var fontSizeSection: some View {
        Section {
            ForEach(AppFontSize.allCases) { size in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        settings.fontSize = size
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(size.rawValue)
                                .foregroundStyle(.primary)
                                .font(.system(size: 15 * size.scale))
                            Text("Aa")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 22 * size.scale, weight: .medium))
                        }
                        Spacer()
                        if settings.fontSize == size {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(settings.accentColor.color)
                                .font(.title3)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            Text("Text Size")
        } footer: {
            Text("Adjusts the base text size throughout the app.")
        }
    }

    private var dynamicTypeSection: some View {
        Section {
            Toggle(isOn: $settings.isDynamicTypeEnabled) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.blue.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "textformat")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dynamic Type")
                            .font(.body)
                        Text("Respects system accessibility text size")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Toggle(isOn: $settings.isBoldTextEnabled) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.indigo.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "bold")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Bold Text")
                            .font(.body)
                        Text("Makes text heavier throughout the app")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } header: {
            Text("Accessibility")
        }
    }

    private var textDisplaySection: some View {
        Section("Font Size Slider") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "textformat.size.smaller")
                        .foregroundStyle(.secondary)
                    Slider(
                        value: Binding(
                            get: { Double(AppFontSize.allCases.firstIndex(of: settings.fontSize) ?? 1) },
                            set: { settings.fontSize = AppFontSize.allCases[Int($0)] }
                        ),
                        in: 0...Double(AppFontSize.allCases.count - 1),
                        step: 1
                    )
                    .accentColor(settings.accentColor.color)
                    Image(systemName: "textformat.size.larger")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Spacer()
                    Text("Current: \(settings.fontSize.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var previewSection: some View {
        Section("Live Preview") {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Text("Large Title").font(.largeTitle)
                    Text("Title").font(.title)
                    Text("Headline").font(.headline)
                    Text("Body — \(sampleText)").font(.body)
                    Text("Caption").font(.caption)
                }
                .fontWeight(settings.isBoldTextEnabled ? .bold : .regular)
                .environment(\.sizeCategory,
                             settings.isDynamicTypeEnabled
                             ? settings.fontSize.sizeCategory
                             : .medium)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    NavigationStack {
        FontSettingsView()
            .environmentObject(AppSettings())
    }
}
