//
//  Global.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

// Global Constant
let DBMMovieDidDeleteNotificationName = Notification.Name("MovieDidDelete")
let DBMMovieDeleteNotificationKey = "IsMovieDeleted"

// Global Functions

func delay(timeInterval: TimeInterval, block: @escaping () -> Void) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(Int(timeInterval)), execute: block)
}
