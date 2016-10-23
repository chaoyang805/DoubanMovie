//
//  Work.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

/// 描述艺人作品的字段
class Work: Object, Mappable {
    // json 数据中是一个String数组，将其转换为String，通过'/'隔开
    /// 表示艺人在当前作品的角色，如导演、演员
    dynamic var roles: String = ""
    /// 作品相关的电影信息
    dynamic var subject: DoubanMovie?
    /// 和 roles 字段对应,从 JSON 解析的内容放到此字段,然后转换为 String 更新到 roles 字段, 用于存放到数据库
    var rolesArray: [String] = [] {
        didSet {
            self.roles = rolesArray.reduce("") { $0 + "/" + $1 }.stringByRemoveFirstCharacter()
        }
    }
    
    override class func ignoredProperties() -> [String] {
        return ["rolesArray"]
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        rolesArray <- map["roles"]
        subject <- map["subject"]
    }

}
