//
//  CathayHoldingsUITests.swift
//  CathayHoldingsUITests
//
//  Created by 胡珀菖 on 2021/4/17.
//

import XCTest

class CathayHoldingsUITests: XCTestCase {

    let app = XCUIApplication()
    
    override class func setUp() {
        super.setUp()
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let app = XCUIApplication()
        
        // UI tests must launch the application that they test.
        app.launch()
        let tablesQuery = app.tables
        
        let exists = NSPredicate(format: "%d > 0", true)
        expectation(for: exists, evaluatedWith: tablesQuery.cells.count, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        
        let staticText = XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["臺灣動物區；蟲蟲探索谷；兒童動物區；熱帶雨林區；白手長臂猿島"]/*[[".cells.staticTexts[\"臺灣動物區；蟲蟲探索谷；兒童動物區；熱帶雨林區；白手長臂猿島\"]",".staticTexts[\"臺灣動物區；蟲蟲探索谷；兒童動物區；熱帶雨林區；白手長臂猿島\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.swipeUp()
        staticText.tap()
        
        XCUIDevice.shared.press(.home)
        app.activate()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
