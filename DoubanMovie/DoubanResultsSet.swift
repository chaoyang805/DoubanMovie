//
//  DoubanResultsSet.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
/// 封装请求豆瓣API的 搜索、正在上映 接口返回的电影结果集合
class DoubanResultsSet: NSObject, Mappable {
    
    var count: Int = 0
    var start: Int = 0
    var total: Int = 22
    var title: String = ""
    var subjects: [DoubanMovie] = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        title <- map["title"]
        subjects <- map["subjects"]
    }
}