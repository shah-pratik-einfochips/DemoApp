import XCTest
import LoginKit

@MainActor
final class LoginModuleTests: XCTestCase {

    var sut: LoginViewModel!

    override func setUp() {
        super.setUp()
        sut = LoginViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - LoginViewModel Default State

    func testDefaultEmailIsEmpty() {
        XCTAssertEqual(sut.email, "")
    }

    func testDefaultPasswordIsEmpty() {
        XCTAssertEqual(sut.password, "")
    }

    func testDefaultPasswordVisibilityIsFalse() {
        XCTAssertFalse(sut.isPasswordVisible)
    }

    func testDefaultValidationErrorIsNil() {
        XCTAssertNil(sut.validationError)
    }

    // MARK: - clearFields

    func testClearFieldsResetsEmail() {
        sut.email = "test@example.com"
        sut.clearFields()
        XCTAssertEqual(sut.email, "")
    }

    func testClearFieldsResetsPassword() {
        sut.password = "Secret123"
        sut.clearFields()
        XCTAssertEqual(sut.password, "")
    }

    func testClearFieldsResetsPasswordVisibility() {
        sut.isPasswordVisible = true
        sut.clearFields()
        XCTAssertFalse(sut.isPasswordVisible)
    }

    func testClearFieldsClearsValidationError() {
        sut.email = ""
        sut.password = ""
        sut.login()
        XCTAssertNotNil(sut.validationError)
        sut.clearFields()
        XCTAssertNil(sut.validationError)
    }

    // MARK: - login() Success

    func testLoginWithValidCredentialsCallsOnSuccess() {
        var receivedCredentials: LoginCredentials?
        sut.onSuccess = { receivedCredentials = $0 }
        sut.email = "user@example.com"
        sut.password = "anypassword"
        sut.login()
        XCTAssertNotNil(receivedCredentials)
    }

    func testLoginSuccessPassesCorrectEmail() {
        var receivedCredentials: LoginCredentials?
        sut.onSuccess = { receivedCredentials = $0 }
        sut.email = "user@example.com"
        sut.password = "anypassword"
        sut.login()
        XCTAssertEqual(receivedCredentials?.email, "user@example.com")
    }

    func testLoginSuccessPassesCorrectPassword() {
        var receivedCredentials: LoginCredentials?
        sut.onSuccess = { receivedCredentials = $0 }
        sut.email = "user@example.com"
        sut.password = "secret123"
        sut.login()
        XCTAssertEqual(receivedCredentials?.password, "secret123")
    }

    func testLoginSuccessClearsValidationError() {
        sut.email = "user@example.com"
        sut.password = "anypassword"
        sut.login()
        XCTAssertNil(sut.validationError)
    }

    func testLoginSuccessDoesNotCallOnFailure() {
        var failureCalled = false
        sut.onFailure = { _ in failureCalled = true }
        sut.email = "user@example.com"
        sut.password = "anypassword"
        sut.login()
        XCTAssertFalse(failureCalled)
    }

    // MARK: - login() Failure – Empty Email

    func testLoginWithEmptyEmailSetsValidationError() {
        sut.email = ""
        sut.password = "anypassword"
        sut.login()
        XCTAssertNotNil(sut.validationError)
    }

    func testLoginWithEmptyEmailValidationMessage() {
        sut.email = ""
        sut.password = "anypassword"
        sut.login()
        XCTAssertEqual(sut.validationError, "Email cannot be empty.")
    }

    func testLoginWithEmptyEmailDoesNotCallOnSuccess() {
        var successCalled = false
        sut.onSuccess = { _ in successCalled = true }
        sut.email = ""
        sut.password = "anypassword"
        sut.login()
        XCTAssertFalse(successCalled)
    }

    func testLoginWithEmptyEmailCallsOnFailure() {
        var failureMessage: String?
        sut.onFailure = { failureMessage = $0 }
        sut.email = ""
        sut.password = "anypassword"
        sut.login()
        XCTAssertNotNil(failureMessage)
    }

    // MARK: - login() Failure – Invalid Email

    func testLoginWithInvalidEmailSetsValidationError() {
        sut.email = "notanemail"
        sut.password = "anypassword"
        sut.login()
        XCTAssertNotNil(sut.validationError)
    }

    func testLoginWithInvalidEmailValidationMessage() {
        sut.email = "notanemail"
        sut.password = "anypassword"
        sut.login()
        XCTAssertEqual(sut.validationError, "Please enter a valid email address.")
    }

    func testLoginWithMissingDomainEmailFails() {
        sut.email = "user@"
        sut.password = "anypassword"
        sut.login()
        XCTAssertNotNil(sut.validationError)
    }

    // MARK: - login() Failure – Empty Password

    func testLoginWithEmptyPasswordSetsValidationError() {
        sut.email = "user@example.com"
        sut.password = ""
        sut.login()
        XCTAssertNotNil(sut.validationError)
    }

    func testLoginWithEmptyPasswordValidationMessage() {
        sut.email = "user@example.com"
        sut.password = ""
        sut.login()
        XCTAssertEqual(sut.validationError, "Password cannot be empty.")
    }

    // MARK: - login() Failure – Both Empty

    func testLoginWithBothEmptyFieldsFails() {
        sut.email = ""
        sut.password = ""
        sut.login()
        XCTAssertNotNil(sut.validationError)
    }

    // MARK: - LoginValidator

    func testValidatorSuccessWithValidInput() {
        let result = LoginValidator.validate(email: "user@example.com", password: "password")
        XCTAssertEqual(result, .success)
    }

    func testValidatorFailsWithEmptyEmail() {
        let result = LoginValidator.validate(email: "", password: "password")
        XCTAssertEqual(result, .failure("Email cannot be empty."))
    }

    func testValidatorFailsWithWhitespaceOnlyEmail() {
        let result = LoginValidator.validate(email: "   ", password: "password")
        XCTAssertEqual(result, .failure("Email cannot be empty."))
    }

    func testValidatorFailsWithInvalidEmailFormat() {
        let result = LoginValidator.validate(email: "invalidemail", password: "password")
        XCTAssertEqual(result, .failure("Please enter a valid email address."))
    }

    func testValidatorFailsWithEmptyPassword() {
        let result = LoginValidator.validate(email: "user@example.com", password: "")
        XCTAssertEqual(result, .failure("Password cannot be empty."))
    }

    func testValidatorAcceptsSubdomainEmail() {
        let result = LoginValidator.validate(email: "user@mail.example.com", password: "pass")
        XCTAssertEqual(result, .success)
    }

    func testValidatorAcceptsPlusAddressEmail() {
        let result = LoginValidator.validate(email: "user+tag@example.com", password: "pass")
        XCTAssertEqual(result, .success)
    }

    // MARK: - LoginCredentials

    func testLoginCredentialsStoresEmail() {
        let creds = LoginCredentials(email: "a@b.com", password: "pass")
        XCTAssertEqual(creds.email, "a@b.com")
    }

    func testLoginCredentialsStoresPassword() {
        let creds = LoginCredentials(email: "a@b.com", password: "secret")
        XCTAssertEqual(creds.password, "secret")
    }
}
