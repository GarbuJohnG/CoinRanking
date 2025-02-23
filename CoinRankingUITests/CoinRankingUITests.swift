//
//  CoinRankingUITests.swift
//  CoinRankingUITests
//
//  Created by John Gachuhi on 21/02/2025.
//

import XCTest

final class CoinRankingUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favorites"].tap()
        tabBar.buttons["Home"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap()
        app.navigationBars["BTC"].buttons["Home"].tap()
        app.navigationBars["Home"].buttons["filter"].tap()
        app.sheets["Sort Coins"].scrollViews.otherElements.buttons["Highest Price"].tap()
        
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
