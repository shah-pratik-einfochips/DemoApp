import SwiftUI

struct LanguageView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            Section {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        withAnimation {
                            settings.language = lang
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Text(lang.flag)
                                .font(.title2)
                                .frame(width: 40)
                            Text(lang.rawValue)
                                .foregroundStyle(.primary)
                            Spacer()
                            if settings.language == lang {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(settings.accentColor.color)
                                    .font(.title3)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            } header: {
                Text("Select Language")
            } footer: {
                Text("Changing the language will take effect after restarting the app.")
            }

            Section("Region") {
                SettingsRow(icon: "clock.fill", iconColor: .orange, title: "Time Zone", value: TimeZone.current.identifier)
                SettingsRow(icon: "calendar", iconColor: .red, title: "Calendar", value: "Gregorian")
                SettingsRow(icon: "number", iconColor: .blue, title: "Number Format", value: "1,234.56")
            }
        }
        .navigationTitle("Language & Region")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LanguageView()
            .environmentObject(AppSettings())
    }
}
