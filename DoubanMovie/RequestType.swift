//
//  RequestType.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/10/28.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

/**
 网络请求的类型
 
 - inTheater: 请求正在热映
 - search:    搜索电影
 - subject:   指定的电影条目
 - celebrity: 指定的影人条目
 */
public enum RequestType: CustomStringConvertible {
    case inTheater
    case search
    case subject(subjectId: String)
    case celebrity(celebrityId: String)
    
    var baseURL: String {
        return "https://api.douban.com/v2/movie/"
    }
    
    public var description: String {
        switch self {
        case .inTheater:
            return baseURL + "in_theaters"
        case .search:
            return baseURL + "search"
        case .celebrity(let id):
            return baseURL + "celebrity/\(id)"
            
        case .subject(let id):
            return baseURL + "subject/\(id)"
        }
    }
}
