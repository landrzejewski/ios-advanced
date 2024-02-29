//
//  BestWatherUITests.swift
//  BestWatherUITests
//
//  Created by Łukasz Andrzejewski on 16/01/2024.
//

import XCTest

final class BestWatherUITests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.uninstall()
    }
    
    func test_refresh_forecast_for_city() {
        let city = "Berlin"
        app.images["settings"].tap()
        let cityTextField = app.textFields.firstMatch
        cityTextField.clear()
        cityTextField.typeText(city)
        app.buttons["close"].tap()
        sleep(3)
        XCTAssertEqual(city, app.staticTexts["city"].label)
    }
    
    func test_refresh_forecast_for_current_location() {
        allowLocationUpdates()
        app.images["location"].tap()
        sleep(5)
        XCTAssertEqual("Cupertino", app.staticTexts["city"].label)
    }
    
    private func allowLocationUpdates() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let button = springboard.alerts.firstMatch.buttons["Pozwalaj, gdy używam aplikacji"]
        _ = button.waitForExistence(timeout: 100)
        button.tap()
    }
    
}

extension XCUIElement {
    
    func clear() {
        guard let value = self.value as? String else {
            return
        }
        tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: value.count)
        typeText(deleteString)
    }
    
}

extension XCUIApplication {

    func uninstall(name: String? = nil) {
        self.terminate()
        
        let timeout = TimeInterval(5)
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        let appName: String
        if let name = name {
            appName = name
        } else {
            let uiTestRunnerName = Bundle.main.infoDictionary?["CFBundleName"] as! String
            appName = uiTestRunnerName.replacingOccurrences(of: "UITests-Runner", with: "")
        }

        /// use `firstMatch` because icon may appear in iPad dock
        let appIcon = springboard.icons[appName].firstMatch
        if appIcon.waitForExistence(timeout: timeout) {
            appIcon.press(forDuration: 2)
        } else {
            XCTFail("Failed to find app icon named \(appName)")
        }
        
        let removeAppButton = springboard.buttons["Usuń aplikację"]
        if removeAppButton.waitForExistence(timeout: timeout) {
            removeAppButton.tap()
        } else {
            XCTFail("Failed to find 'Remove App'")
        }

        let deleteAppButton = springboard.alerts.buttons["Usuń aplikację"]
        if deleteAppButton.waitForExistence(timeout: timeout) {
            deleteAppButton.tap()
        } else {
            XCTFail("Failed to find 'Delete App'")
        }

        let finalDeleteButton = springboard.alerts.buttons["Usuń"]
        if finalDeleteButton.waitForExistence(timeout: timeout) {
            finalDeleteButton.tap()
        } else {
            XCTFail("Failed to find 'Delete'")
        }
    }
    
}
