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
