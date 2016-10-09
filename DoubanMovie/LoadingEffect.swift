//
//  LoadingEffect.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/10/9.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation
// UIViews that have a loading effect should confirm to this protocol
protocol LoadingEffect {
    
    var isLoading: Bool { get }
    
    func beginLoading()
    
    func endLoading()
    
}