//
//  Work.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift
class Work: Object {
    // json 数据中是一个String数组，将其转换为String，通过'/'隔开
    dynamic var roles: String = ""
    
    dynamic var subject: MovieSubject?
    
    var rolesArray: [String] = []
    
    override class func ignoredProperties() -> [String] {
        return ["rolesArray"]
    }
}
