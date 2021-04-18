//
//  CathayHoldingsTests.swift
//  CathayHoldingsTests
//
//  Created by 胡珀菖 on 2021/4/17.
//

import XCTest
@testable import CathayHoldings

class CathayHoldingsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRange() throws {
        
        let min = 0
        let max = 100
        let outOfMax = 101
        let resultOutOfMax = valueIn(outOfMax, min: min, max: max)
        XCTAssert(resultOutOfMax == max, "Out of max must be max")
        
        let outOfMin = -1
        let resultOutOfMin = valueIn(outOfMin, min: min, max: max)
        XCTAssert(resultOutOfMin == min, "Out of min must be min")
        
        let inRange = 58
        let resultInRange = valueIn(inRange, min: min, max: max)
        XCTAssert(resultInRange == inRange, "In range must be original")
    }
    
    func testRegular() throws {
        
        let regularMin = 0.0
        let regularMax = 1.0
        
        let min = 0.0
        let max = 100.0
        let rMax = 100.0
        let resultRegularMax = regular(rMax, min: min, max: max)
        XCTAssert(resultRegularMax == regularMax, "Regular Max must be 1.0")
        
        let rMin = 0.0
        let resultRegularMin = regular(rMin, min: min, max: max)
        XCTAssert(resultRegularMin == regularMin, "Regular Min must be 0.0")

        let rMid = 50.0
        let resultRegularMiddle = regular(rMid, min: min, max: max)
        XCTAssert(resultRegularMiddle == 0.5, "Regular Middle must be 0.5")
    }
    
    func testError() throws {
        let error = CHError.exception()
        XCTAssert(error.code == -999, "Exception Error Code must be -999")
        XCTAssert(error.description == "unknown error", "Exception Error Message must be 'unknown error'")
    }
    
    func testAsynchronousURLConnection() {
        
        let urlExpectation = expectation(description: "GET Zoo Plant")
        
        CHWebServiceManager.shared.getZooPlant(request: CHGetZooPlantRequest(limit: 20, offset: 0)) { (response) in
            
            XCTAssert(response.count == 20, "inquiry limit 20 at 0, result count must be 20")

            urlExpectation.fulfill()
            
        } failure: { (error) in
            
            if error.code == NSURLErrorTimedOut {
                
                XCTAssert(error.description == "Request Timed Out", "wrong message")
                
            } else if error.code == NSURLErrorNotConnectedToInternet ||
                        error.code == NSURLErrorNetworkConnectionLost {
                
                XCTAssert(error.description == "Please Check Network", "wrong message")
                
            } else {
                
                XCTAssert(error.description == "unknown error", "wrong message")
            }

            urlExpectation.fulfill()
        }

        waitForExpectations(timeout: kTimeoutInterval_WS) { (error) in
            print("test timeout")
        }
    }
    
    func testEnterBackground() {
        
        let urlExpectation = expectation(description: "GET Zoo Plant")
        
        CHWebServiceManager.shared.getZooPlant(request: CHGetZooPlantRequest(limit: 20, offset: 0)) { (response) in
            
            XCTAssert(response.count == 20, "inquiry limit 20 at 0, result count must be 20")

            urlExpectation.fulfill()
            
        } failure: { (error) in
            
            if error.code == NSURLErrorTimedOut {
                
                XCTAssert(error.description == "Request Timed Out", "wrong message")
                
            } else if error.code == NSURLErrorNotConnectedToInternet ||
                        error.code == NSURLErrorNetworkConnectionLost {
                
                XCTAssert(error.description == "Please Check Network", "wrong message")
                
            } else {
                
                XCTAssert(error.description == "unknown error", "wrong message")
            }

            urlExpectation.fulfill()
        }
        
        waitForExpectations(timeout: kTimeoutInterval_WS) { (error) in
            print("test timeout")
        }
        
        XCUIDevice.shared.press(.home)
        
        let runningCount = CHWebServiceManager.shared.runningTasks.filter({ $0.state == .running }).count
        XCTAssert(runningCount == 0, "enter background must suspend")
        
    }
}
