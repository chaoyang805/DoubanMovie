/*
 * Copyright 2016 chaoyang805 zhangchaoyang805@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import ObjectMapper
import RealmSwift

class DoubanCelebrity: Object, Mappable {
    
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
