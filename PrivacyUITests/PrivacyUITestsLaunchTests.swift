//
//  PrivacyUITestsLaunchTests.swift
//  PrivacyUITests
//
//  Created by Evelyn Hur on 3/14/24.
//

import XCTest

final class PrivacyUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        onboardingTests()
        privacyTests()
    }
    
    func onboardingTests() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Learn More"].tap()
        elementsQuery.buttons["Continue"].tap()
        
        let eMailAddressTextField = elementsQuery.textFields["E-Mail Address"]
        eMailAddressTextField.tap()
        eMailAddressTextField.typeText("carolinetran.sea@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        
        let loginButton = elementsQuery.buttons["Login"]
        loginButton.tap()
        elementsQuery.buttons["Allow HealthKit Access"].tap()
        app.tables
            .cells["UIA.Health.AuthSheet.AllCategoryButton"]
            .staticTexts["Turn On All"]
            .tap()
        app.navigationBars["Health Access"]
            .buttons["UIA.Health.AuthSheet.DoneButton"]
            .tap()
        elementsQuery.buttons["Next"].tap()
        app.alerts["“Prisma” Would Like to Send You Notifications"].scrollViews.otherElements.buttons["Allow"].tap()
    }
    
    func privacyTests() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Privacy Controls"].tap()
        XCUIApplication().collectionViews
            .cells
            .buttons["shoeprints.fill, Step Count, Enabled"]
            .tap()
        
        // Wait for the switch to appear and toggle it
        let stepCountSwitch = app.switches["Step Count"]
        let stepCountSwitchExists = expectation(for: NSPredicate(format: "exists == 1"),
                                                evaluatedWith: stepCountSwitch,
                                                handler: nil)
        
        wait(for: [stepCountSwitchExists], timeout: 10)
        if stepCountSwitch.isHittable {
            stepCountSwitch.tap() // If the switch is available, tap it.
        }
        
        for index in 0..<10 {
            // Check if the "Hide Timestamp" button is present
            let hideTimestampButton = app.buttons["Hide Timestamp"]
            if hideTimestampButton.waitForExistence(timeout: 2) && hideTimestampButton.isHittable {
                hideTimestampButton.tap()
            } else {
                // Check if the "Show Timestamp" button is present
                let showTimestampButton = app.buttons["Show Timestamp"]
                if showTimestampButton.waitForExistence(timeout: 2) && showTimestampButton.isHittable {
                    showTimestampButton.tap()
                } else {
                    XCTFail("Neither hide nor show timestamp button is hittable for timestamp index: \(index)")
                }
            }
        }
        
//        // Wait for the first timestamp to appear
//        let firstTimestamp = app.staticTexts["2024-03-13T20:01:25.742"] // Use the exact identifier for your timestamp element
//        let firstTimestampExists = expectation(for: NSPredicate(format: "exists == 1"),
//                                               evaluatedWith: firstTimestamp,
//                                               handler: nil)
//        
//        wait(for: [firstTimestampExists], timeout: 10)
//        // Proceed with other actions, e.g., tapping on the timestamp if necessary
//        if firstTimestamp.isHittable {
//            firstTimestamp.tap()
//        }
    }
}
