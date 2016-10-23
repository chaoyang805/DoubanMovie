//
//  DoubanImage.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class DoubanImage: Object, Mappable {
    
    dynamic var smallImageURL = ""
    dynamic var mediumImageURL = ""
    dynamic var largeImageURL = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        smallImageURL <- map["small"]
        mediumImageURL <- map["medium"]
        largeImageURL <- map["large"]
    }
}

extension DoubanImage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DoubanImage()
        
        copy.smallImageURL = smallImageURL
        copy.mediumImageURL = mediumImageURL
        copy.largeImageURL = largeImageURL
        return copy
    }

}
