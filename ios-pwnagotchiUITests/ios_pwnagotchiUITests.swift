//
//  ios_pwnagotchiUITests.swift
//  ios-pwnagotchiUITests
//
//  Created by Silsha Fux on 23.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import XCTest

class ios_pwnagotchiUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicNavigation() {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Not connected"].buttons["Settings"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Username"]/*[[".cells.textFields[\"Username\"]",".textFields[\"Username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["_TtGC7SwiftUIP13$7fff2c68216028DestinationHosting"].buttons["Not connected"].tap()
        app.buttons["Connect"].tap();
        
        XCTAssert(app.staticTexts["Not connected"].exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
