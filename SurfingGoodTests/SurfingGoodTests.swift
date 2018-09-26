//
//  MXviewToGoTests.swift
//  MXviewToGoTests
//
//  Created by liusean on 05/12/2016.
//  Copyright © 2016 liusean. All rights reserved.
//

import XCTest
import SwiftHTTP

@testable import MXviewToGo

class MXviewToGoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequest() {
        let expectation = self.expectation(description: "testGetRequest")
        
        do {
            let opt = try HTTP.GET("https://google.com", parameters: nil)
            opt.start { responds in
                if responds.error != nil {
                    XCTAssert(false, "Failure")
                }
                XCTAssert(true, "Pass")
                expectation.fulfill()
            }
            
        } catch {
            XCTAssert(false, "Failure")
        }
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
