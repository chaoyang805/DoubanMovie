//
//  DoubanMovieTests.swift
//  DoubanMovieTests
//
//  Created by chaoyang805 on 16/7/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import DoubanMovie

class DoubanMovieTests: XCTestCase {
    let searchURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/search/index.php")
    let celebrityURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/celebrity/index.php")
    let inTheatersURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/in_theater/index.php")
    let inTheatersSubjectURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/in_theater_subject/index.php")
    let subjectByIdURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/subject_by_id/index.php")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func textSearchAPI() {
        
    }
    
    func testInTheaterSubject() {
        
        let inTheaterSubjectJSON = try?  String(contentsOfURL: inTheatersSubjectURL!, encoding: NSUTF8StringEncoding)
        
        let movie = Mapper<DoubanMovie>().map(inTheaterSubjectJSON)
        XCTAssertNotNil(movie)
        XCTAssertGreaterThan(movie!.casts.count, 0)
        
    }
    
    func testSearchAPI() {
        
    }
    
    func testRating() {
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
