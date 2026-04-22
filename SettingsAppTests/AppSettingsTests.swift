import XCTest
@testable import SettingsApp

final class AppSettingsTests: XCTestCase {

    var sut: AppSettings!

    private let udKeys = [
        "app_theme", "app_font_size", "app_accent_color", "app_language",
        "dynamic_type", "bold_text", "notifications", "sound", "badge",
        "haptics", "face_id", "analytics", "location", "auto_update", "data_saver"
    ]

    override func setUp() {
        super.setUp()
        udKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        sut = AppSettings()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Default Values

    func testDefaultThemeIsSystem() {
        XCTAssertEqual(sut.theme, .system)
    }

    func testDefaultFontSizeIsMedium() {
        XCTAssertEqual(sut.fontSize, .medium)
    }

    func testDefaultAccentColorIsBlue() {
        XCTAssertEqual(sut.accentColor, .blue)
    }

    func testDefaultLanguageIsEnglish() {
        XCTAssertEqual(sut.language, .english)
    }

    func testDefaultDynamicTypeIsEnabled() {
        XCTAssertTrue(sut.isDynamicTypeEnabled)
    }

    func testDefaultBoldTextIsDisabled() {
        XCTAssertFalse(sut.isBoldTextEnabled)
    }

    func testDefaultNotificationsIsEnabled() {
        XCTAssertTrue(sut.isNotificationsEnabled)
    }

    func testDefaultSoundIsEnabled() {
        XCTAssertTrue(sut.isSoundEnabled)
    }

    func testDefaultBadgeIsEnabled() {
        XCTAssertTrue(sut.isBadgeEnabled)
    }

    // MARK: - Auth State

    func testIsLoggedInDefaultsFalse() {
        XCTAssertFalse(sut.isLoggedIn)
    }

    func testLoggedInEmailDefaultsEmpty() {
        XCTAssertEqual(sut.loggedInEmail, "")
    }

    func testSetLoggedInState() {
        sut.loggedInEmail = "user@example.com"
        sut.isLoggedIn = true
        XCTAssertEqual(sut.loggedInEmail, "user@example.com")
        XCTAssertTrue(sut.isLoggedIn)
    }

    func testLogoutClearsEmailAndSetsLoggedInFalse() {
        sut.loggedInEmail = "user@example.com"
        sut.isLoggedIn = true
        sut.logout()
        XCTAssertEqual(sut.loggedInEmail, "")
        XCTAssertFalse(sut.isLoggedIn)
    }

    func testLogoutOnAlreadyLoggedOutStateIsNoOp() {
        sut.logout()
        XCTAssertEqual(sut.loggedInEmail, "")
        XCTAssertFalse(sut.isLoggedIn)
    }

    // MARK: - Settings Mutations

    func testSetThemeToDark() {
        sut.theme = .dark
        XCTAssertEqual(sut.theme, .dark)
    }

    func testSetThemeToLight() {
        sut.theme = .light
        XCTAssertEqual(sut.theme, .light)
    }

    func testSetFontSizeToLarge() {
        sut.fontSize = .large
        XCTAssertEqual(sut.fontSize, .large)
    }

    func testSetFontSizeToExtraLarge() {
        sut.fontSize = .extraLarge
        XCTAssertEqual(sut.fontSize, .extraLarge)
    }

    func testSetAccentColorToPurple() {
        sut.accentColor = .purple
        XCTAssertEqual(sut.accentColor, .purple)
    }

    func testToggleBoldText() {
        sut.isBoldTextEnabled = true
        XCTAssertTrue(sut.isBoldTextEnabled)
    }

    func testDisableNotifications() {
        sut.isNotificationsEnabled = false
        XCTAssertFalse(sut.isNotificationsEnabled)
    }

    // MARK: - resetToDefaults

    func testResetRestoresTheme() {
        sut.theme = .dark
        sut.resetToDefaults()
        XCTAssertEqual(sut.theme, .system)
    }

    func testResetRestoresFontSize() {
        sut.fontSize = .extraLarge
        sut.resetToDefaults()
        XCTAssertEqual(sut.fontSize, .medium)
    }

    func testResetRestoresAccentColor() {
        sut.accentColor = .red
        sut.resetToDefaults()
        XCTAssertEqual(sut.accentColor, .blue)
    }

    func testResetRestoresNotifications() {
        sut.isNotificationsEnabled = false
        sut.isSoundEnabled = false
        sut.resetToDefaults()
        XCTAssertTrue(sut.isNotificationsEnabled)
        XCTAssertTrue(sut.isSoundEnabled)
    }

    func testResetRestoresBoldTextToFalse() {
        sut.isBoldTextEnabled = true
        sut.resetToDefaults()
        XCTAssertFalse(sut.isBoldTextEnabled)
    }

    // MARK: - AppTheme

    func testAppThemeSystemColorSchemeIsNil() {
        XCTAssertNil(AppTheme.system.colorScheme)
    }

    func testAppThemeLightColorScheme() {
        XCTAssertEqual(AppTheme.light.colorScheme, .light)
    }

    func testAppThemeDarkColorScheme() {
        XCTAssertEqual(AppTheme.dark.colorScheme, .dark)
    }

    func testAppThemeIcons() {
        XCTAssertEqual(AppTheme.system.icon, "circle.lefthalf.filled")
        XCTAssertEqual(AppTheme.light.icon, "sun.max.fill")
        XCTAssertEqual(AppTheme.dark.icon, "moon.fill")
    }

    // MARK: - AppFontSize

    func testFontSizeScaleValues() {
        XCTAssertEqual(AppFontSize.small.scale, 0.85, accuracy: 0.001)
        XCTAssertEqual(AppFontSize.medium.scale, 1.0, accuracy: 0.001)
        XCTAssertEqual(AppFontSize.large.scale, 1.15, accuracy: 0.001)
        XCTAssertEqual(AppFontSize.extraLarge.scale, 1.3, accuracy: 0.001)
    }

    func testFontSizeSizeCategories() {
        XCTAssertEqual(AppFontSize.small.sizeCategory, .small)
        XCTAssertEqual(AppFontSize.medium.sizeCategory, .medium)
        XCTAssertEqual(AppFontSize.large.sizeCategory, .large)
        XCTAssertEqual(AppFontSize.extraLarge.sizeCategory, .extraLarge)
    }

    // MARK: - AppAccentColor

    func testAllAccentColorsHaveUniqueIDs() {
        let ids = AppAccentColor.allCases.map { $0.id }
        XCTAssertEqual(ids.count, Set(ids).count)
    }

    // MARK: - AppLanguage

    func testAllLanguagesHaveUniqueIDs() {
        let ids = AppLanguage.allCases.map { $0.id }
        XCTAssertEqual(ids.count, Set(ids).count)
    }
}
