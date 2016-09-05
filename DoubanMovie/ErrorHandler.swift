//
//  DoubanServiceErrorHandler.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

protocol ErrorHandler: class {
    
    func onDoubanService(service: DoubanService, request requestType: RequestType, failedWithError: NSError)
    
}