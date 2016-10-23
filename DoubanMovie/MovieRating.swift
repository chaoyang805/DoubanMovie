//
//  MovieRating.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class MovieRating: Object, Mappable {
    dynamic var max: Float = 0
    dynamic var average: Float = 0
    dynamic var stars: String = "0"
    dynamic var min: String = "0"
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        max <- map["max"]
        average <- map["average"]
        stars <- map["stars"]
        min <- map["min"]
    }
}

extension MovieRating: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MovieRating()
        
        copy.max = max
        copy.average = average
        copy.stars = stars
        copy.min = min
        return copy
    }
}
