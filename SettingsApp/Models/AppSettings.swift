import SwiftUI
import Combine

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light  = "Light"
    case dark   = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        }
    }
}

enum AppFontSize: String, CaseIterable, Identifiable {
    case small      = "Small"
    case medium     = "Medium"
    case large      = "Large"
    case extraLarge = "Extra Large"

    var id: String { rawValue }

    var scale: CGFloat {
        switch self {
        case .small:      return 0.85
        case .medium:     return 1.0
        case .large:      return 1.15
        case .extraLarge: return 1.3
        }
    }

    var sizeCategory: ContentSizeCategory {
        switch self {
        case .small:      return .small
        case .medium:     return .medium
        case .large:      return .large
        case .extraLarge: return .extraLarge
        }
    }
}

enum AppAccentColor: String, CaseIterable, Identifiable {
    case blue   = "Blue"
    case indigo = "Indigo"
    case purple = "Purple"
    case pink   = "Pink"
    case red    = "Red"
    case orange = "Orange"
    case green  = "Green"
    case teal   = "Teal"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blue:   return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink:   return .pink
        case .red:    return .red
        case .orange: return .orange
        case .green:  return .green
        case .teal:   return .teal
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case english    = "English"
    case spanish    = "Español"
    case french     = "Français"
    case german     = "Deutsch"
    case japanese   = "日本語"
    case chinese    = "中文"
    case arabic     = "العربية"
    case hindi      = "हिंदी"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .english:  return "🇺🇸"
        case .spanish:  return "🇪🇸"
        case .french:   return "🇫🇷"
        case .german:   return "🇩🇪"
        case .japanese: return "🇯🇵"
        case .chinese:  return "🇨🇳"
        case .arabic:   return "🇸🇦"
        case .hindi:    return "🇮🇳"
        }
    }
}

class AppSettings: ObservableObject {

    @Published var theme: AppTheme {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: "app_theme") }
    }

    @Published var fontSize: AppFontSize {
        didSet { UserDefaults.standard.set(fontSize.rawValue, forKey: "app_font_size") }
    }

    @Published var accentColor: AppAccentColor {
        didSet { UserDefaults.standard.set(accentColor.rawValue, forKey: "app_accent_color") }
    }

    @Published var isDynamicTypeEnabled: Bool {
        didSet { UserDefaults.standard.set(isDynamicTypeEnabled, forKey: "dynamic_type") }
    }

    @Published var isBoldTextEnabled: Bool {
        didSet { UserDefaults.standard.set(isBoldTextEnabled, forKey: "bold_text") }
    }

    @Published var isNotificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(isNotificationsEnabled, forKey: "notifications") }
    }

    @Published var isSoundEnabled: Bool {
        didSet { UserDefaults.standard.set(isSoundEnabled, forKey: "sound") }
    }

    @Published var isBadgeEnabled: Bool {
        didSet { UserDefaults.standard.set(isBadgeEnabled, forKey: "badge") }
    }

    @Published var isHapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(isHapticsEnabled, forKey: "haptics") }
    }

    @Published var isFaceIDEnabled: Bool {
        didSet { UserDefaults.standard.set(isFaceIDEnabled, forKey: "face_id") }
    }

    @Published var isAnalyticsEnabled: Bool {
        didSet { UserDefaults.standard.set(isAnalyticsEnabled, forKey: "analytics") }
    }

    @Published var isLocationEnabled: Bool {
        didSet { UserDefaults.standard.set(isLocationEnabled, forKey: "location") }
    }

    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "app_language") }
    }

    @Published var isAutoUpdateEnabled: Bool {
        didSet { UserDefaults.standard.set(isAutoUpdateEnabled, forKey: "auto_update") }
    }

    @Published var isDataSaverEnabled: Bool {
        didSet { UserDefaults.standard.set(isDataSaverEnabled, forKey: "data_saver") }
    }

    @Published var loggedInEmail: String = ""
    @Published var isLoggedIn: Bool = false

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    init() {
        let ud = UserDefaults.standard

        self.theme           = AppTheme(rawValue: ud.string(forKey: "app_theme") ?? "") ?? .system
        self.fontSize        = AppFontSize(rawValue: ud.string(forKey: "app_font_size") ?? "") ?? .medium
        self.accentColor     = AppAccentColor(rawValue: ud.string(forKey: "app_accent_color") ?? "") ?? .blue
        self.language        = AppLanguage(rawValue: ud.string(forKey: "app_language") ?? "") ?? .english

        self.isDynamicTypeEnabled  = ud.object(forKey: "dynamic_type")  as? Bool ?? true
        self.isBoldTextEnabled     = ud.object(forKey: "bold_text")      as? Bool ?? false
        self.isNotificationsEnabled = ud.object(forKey: "notifications") as? Bool ?? true
        self.isSoundEnabled        = ud.object(forKey: "sound")          as? Bool ?? true
        self.isBadgeEnabled        = ud.object(forKey: "badge")          as? Bool ?? true
        self.isHapticsEnabled      = ud.object(forKey: "haptics")        as? Bool ?? true
        self.isFaceIDEnabled       = ud.object(forKey: "face_id")        as? Bool ?? false
        self.isAnalyticsEnabled    = ud.object(forKey: "analytics")      as? Bool ?? true
        self.isLocationEnabled     = ud.object(forKey: "location")       as? Bool ?? false
        self.isAutoUpdateEnabled   = ud.object(forKey: "auto_update")    as? Bool ?? true
        self.isDataSaverEnabled    = ud.object(forKey: "data_saver")     as? Bool ?? false
    }

    func logout() {
        loggedInEmail = ""
        isLoggedIn = false
    }

    func resetToDefaults() {
        theme                = .system
        fontSize             = .medium
        accentColor          = .blue
        language             = .english
        isDynamicTypeEnabled = true
        isBoldTextEnabled    = false
        isNotificationsEnabled = true
        isSoundEnabled       = true
        isBadgeEnabled       = true
        isHapticsEnabled     = true
        isFaceIDEnabled      = false
        isAnalyticsEnabled   = true
        isLocationEnabled    = false
        isAutoUpdateEnabled  = true
        isDataSaverEnabled   = false
    }
}
