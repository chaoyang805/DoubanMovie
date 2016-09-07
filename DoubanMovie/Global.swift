//
//  Global.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

// Global Constant
let DBMMovieDidDeleteNotificationName = "MovieDidDelete"
let DBMMovieDeleteNotificationKey = "IsMovieDeleted"

// Global Functions

func delay(timeInterval: NSTimeInterval, block: dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(timeInterval) * NSEC_PER_SEC)), dispatch_get_main_queue(), block)
}