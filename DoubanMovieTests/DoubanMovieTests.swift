//
//  DoubanMovieTests.swift
//  DoubanMovieTests
//
//  Created by chaoyang805 on 16/7/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import XCTest
//@testable import DoubanMovie

class DoubanMovieTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.  
        let ratingScore = 7.2
        let yellowStarCount = floor(ratingScore / 2)
    
        let hasHalfStar =  (ratingScore / 2 - yellowStarCount > 0.1) && (ratingScore / 2 - yellowStarCount <= 0.6)
        print("\(ratingScore / 2 - yellowStarCount)")

        XCTAssertTrue(hasHalfStar)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
