//
//  Artist.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class DoubanCelebrity:Object, Mappable {
    
    dynamic var id: String = ""
    
    dynamic var name: String = ""
    
    dynamic var nameEn: String = ""
    
    dynamic var alt: String = ""
    
    dynamic var mobileURL: String = ""
    
    dynamic var avatars: DoubanImage?
    
    dynamic var gender: String = "男"
    
    dynamic var bornPlace: String = ""
    
    dynamic var aka: String = ""
    
    dynamic var akaEn: String = ""
    
    let works = List<Work>()
    
    // Ignored
    var akaArray: [String] = [] {
        didSet {
            if akaArray.isEmpty {
                return
            }
            self.aka = akaArray.reduce(""){ $0 + "/" + $1 }.stringByRemoveFirstCharacter()
        }
    }
    
    var akaEnArray: [String] = [] {
        didSet {
            if akaEnArray.isEmpty {
                return
            }
            self.akaEn = akaEnArray.reduce(""){ $0 + "/" + $1 }.stringByRemoveFirstCharacter()
        }
    }
    
    var worksArray = [Work]() {
        didSet {
            works.removeAll()
            works.append(objectsIn: worksArray)
        }
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name", "nameEn"]
    }
    
    override class func ignoredProperties() -> [String] {
        return ["akaArray", "akaEnArray", "worksArray"]
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        nameEn <- map["name_en"]
        alt <- map["alt"]
        mobileURL <- map["mobile_url"]
        avatars <- map["avatars"]
        gender <- map["gender"]
        bornPlace <- map["born_place"]
        akaArray <- map["aka"]
        akaEnArray <- map["aka_en"]
        worksArray <- map["works"]
    }
    
    
}
