//
//  Artist.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift
class Artist: Object {
    
    dynamic var id: String = ""
    
    dynamic var name: String = ""
    
    dynamic var nameEn: String = ""
    
    dynamic var alt: String = ""
    
    dynamic var mobileURL: String = ""
    
    dynamic var avatars = MovieImage()
    
    dynamic var gender: String = "男"
    
    dynamic var bornPlace: String = ""
    
    dynamic var aka: String = ""
    
    dynamic var akaEn: String = ""
    
    let works = List<Work>()
    
    // Ignored
    var akaArray: [String] = []
    
    var akaEnArray: [String] = []
    
    override class func ignoredProperties() -> [String] {
        return ["akaArray", "akaEnArray"]
    }
    
    
}