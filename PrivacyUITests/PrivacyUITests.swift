//
//  PrivacyUITests.swift
//  PrivacyUITests
//
//  Created by Evelyn Hur on 3/14/24.
//

import XCTest

final class PrivacyUITests: XCTestCase {

    func testOnboarding() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
                app.launch()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Learn More"].tap()
        elementsQuery.buttons["Continue"].tap()
        
        let eMailAddressTextField = elementsQuery.textFields["E-Mail Address"]
        eMailAddressTextField.tap()
        eMailAddressTextField.typeText("carolinetran.sea@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.press(forDuration: 1.5)
        let password = "123456"
        UIPasteboard.general.string = password
        print(UIPasteboard.general.string ?? "Pasteboard is empty")
        let pasteMenuItem = app.menuItems["Paste"]
        if pasteMenuItem.waitForExistence(timeout: 10) {
            pasteMenuItem.tap()
        } else {
            XCTFail("Paste option not found")
        }
        
        let loginButton = elementsQuery.buttons["Login"]
        loginButton.tap()
        sleep(5)
        elementsQuery.buttons["Allow HealthKit Access"].tap()
        app.tables.staticTexts["Turn On All"].tap()
        app.navigationBars["Health Access"].buttons["UIA.Health.AuthSheet.DoneButton"].tap()

        let nextButton = app.scrollViews.otherElements.buttons["Next"]
        XCTAssertTrue(nextButton.waitForExistence(timeout: 10), "Next button did not appear")
        nextButton.tap()
        app.alerts["“Prisma” Would Like to Send You Notifications"]
            .scrollViews.otherElements
            .staticTexts["“Prisma” Would Like to Send You Notifications"].tap()

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
