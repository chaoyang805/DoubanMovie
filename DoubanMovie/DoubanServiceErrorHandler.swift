//
//  DoubanServiceErrorHandler.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class DoubanServiceErrorHandler: NSObject, ErrorHandler {
    
    func onDoubanService(service: DoubanService, request requestType: RequestType, failedWithError: NSError) {
        switch requestType {
        case .inTheater:
            handleInTheaterError()
        case .search:
            handleSearchError()
        case .subject(_):
            handleSubjectError()
        case .celebrity(_):
            handleCelebrityError()
        }
    }
    
    func handleInTheaterError() {
        NSLog("handleIntheaterError")
    }
    
    func handleSearchError() {
        NSLog("handleSearchError")
    }
    
    func handleSubjectError() {
        NSLog("handleSubjectError")
    }
    
    func handleCelebrityError() {
        NSLog("handleCelebrityError")
    }
    
}
