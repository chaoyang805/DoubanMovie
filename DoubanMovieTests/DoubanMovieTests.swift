//
//  DoubanMovieTests.swift
//  DoubanMovieTests
//
//  Created by chaoyang805 on 16/7/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import XCTest
import ObjectMapper
import RealmSwift
@testable import DoubanMovie

class DoubanMovieTests: XCTestCase {
    let searchURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/search/index.php")
    let celebrityURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/celebrity/index.php")
    let inTheatersURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/in_theater/index.php")
    let inTheatersSubjectURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/in_theater_subject/index.php")
    let subjectByIdURL = NSURL(string: "http://localhost/DoubanServer/api/douban_movie/subject_by_id/index.php")
    var service: DoubanService!
    override func setUp() {
        super.setUp()
        service = DoubanService.sharedService
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    // JSON Serialize
    func testInTheaterSubject() {
        
        let inTheaterSubjectJSON = try?  String(contentsOfURL: inTheatersSubjectURL!, encoding: NSUTF8StringEncoding)
        let movie = Mapper<DoubanMovie>().map(inTheaterSubjectJSON)
        XCTAssertNotNil(movie)
        XCTAssertGreaterThan(movie!.casts.count, 0)
        
    }
    
    func testSearchAPI() {
        let searchJSON = try? String(contentsOfURL: searchURL!, encoding: NSUTF8StringEncoding)
        let resultsSet = Mapper<DoubanResultsSet>().map(searchJSON)
        XCTAssertNotNil(resultsSet)
    }
    
    func testCelebrityAPI() {
        let celebrityJSON = try? String(contentsOfURL: celebrityURL!, encoding: NSUTF8StringEncoding)
        let celebrity = Mapper<DoubanCelebrity>().map(celebrityJSON)
        
        XCTAssertNotNil(celebrity)
        
    }
    
    func testInTheatersAPI() {
        let inTheatersJSON = try? String(contentsOfURL: inTheatersURL!, encoding: NSUTF8StringEncoding)
        let inTeatersResultsSet = Mapper<DoubanResultsSet>().map(inTheatersJSON)
        XCTAssertNotNil(inTeatersResultsSet)
    }
    
    func testSubjectByIdAPI() {
        let subjectByIdJSON = try? String(contentsOfURL: subjectByIdURL!, encoding: NSUTF8StringEncoding)
        let subject = Mapper<DoubanMovie>().map(subjectByIdJSON)
        XCTAssertNotNil(subject)
    }
    
    // MARK: - Networking test
    
    func testInTheatersRequest() {
        service.getInTheaterMovies(at: 0, resultCount: 20) { (responseJSON) in
            
        }
    }
    func testRating() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.  
        let ratingScore = 7.2
        let yellowStarCount = floor(ratingScore / 2)
    
        let hasHalfStar =  (ratingScore / 2 - yellowStarCount > 0.1) && (ratingScore / 2 - yellowStarCount <= 0.6)
        print("\(ratingScore / 2 - yellowStarCount)")

        XCTAssertFalse(hasHalfStar)
    }
    
    func testRealmWriteMany() {
        
        let expectation = self.expectationWithDescription("intheaters")
        var resultsSet: DoubanResultsSet?
        
        DoubanService.sharedService.getInTheaterMovies(at: 0, resultCount: 5) { (responseJSON, error) in
            resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
            XCTAssertNotNil(responseJSON, "response is nil")
            
            let realmHelper = RealmHelper()
            if let movies = resultsSet?.subjects where movies.count > 0 {
                realmHelper.addFavoriteMovies(movies)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5) { (error) in
            NSLog("\(error)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            
        }
    }
    
    
}
