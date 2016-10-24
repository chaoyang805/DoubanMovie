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
