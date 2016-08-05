//
//  DoubanImage.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
class DoubanImage: Object, Mappable {
    
    dynamic var smallImageURL = ""
    dynamic var mediumImageURL = ""
    dynamic var largeImageURL = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        smallImageURL <- map["small"]
        mediumImageURL <- map["medium"]
        largeImageURL <- map["large"]
    }
}