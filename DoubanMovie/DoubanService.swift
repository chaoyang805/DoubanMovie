//
//  DoubanService.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/20.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import AFNetworking
import ObjectMapper

class DoubanService: DoubanAPI {
    
    typealias ResponseHandler = ((responseJSON: NSDictionary?, error: NSError?) -> Void)
    
    static let sharedService = DoubanService()
    
    private(set) var requestType: RequestType = .inTheater
    
    var errorHandler: ErrorHandler?
    
    var requestURLString: String {
        return requestType.description
    }
    
    private init() {}
    
    private lazy var manager: AFHTTPSessionManager = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = .ReturnCacheDataElseLoad
        
        let _manager = AFHTTPSessionManager(sessionConfiguration: config)
        
        _manager.responseSerializer = AFJSONResponseSerializer(readingOptions: .AllowFragments)
        return _manager
    }()
    
    
    /**
     请求正在上映的电影
     
     - parameter city:              请求数据所在的城市
     - parameter start:             返回数据的起始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func getInTheaterMovies(inCity city: String = "北京", at start: Int, resultCount count: Int, forceReload: Bool = false, completionHandler: ResponseHandler?) {
        
        self.requestType = RequestType.inTheater
        
        let parameters = ["start": start, "city": city, "count":count]

        let task = makeGETRequest(
            withURL: self.requestURLString,
            parameters: parameters,
            forceReload: forceReload,
            completionHandler: completionHandler)
        task?.resume()
    }
    
    /**
     根据关键字搜索电影
     
     - parameter query:             关键字
     - parameter start:             开始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func searchMovies(withQuery query: String, at start: Int, resultCount count: Int, forceReload: Bool = false, completionHandler: ResponseHandler?) {
        
        self.requestType = RequestType.search
    
        let parameters = ["q": query, "start": start, "count": count]
        makeGETRequest(
            withURL: self.requestURLString,
            parameters: parameters,
            forceReload: forceReload,
            completionHandler: completionHandler)?
            .resume()
    }
    
    /**
     根据标签搜索电影
     
     - parameter tag:               搜索标签
     - parameter start:             开始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func searchMovies(withTag tag: String, at start: Int, resultCount count: Int, forceReload: Bool = false, completionHandler: ResponseHandler?) {
        
        self.requestType = RequestType.search
        
        let parameters = ["tag" : tag, "start": start, "count": count]
        makeGETRequest(
            withURL: self.requestURLString,
            parameters: parameters,
            forceReload: forceReload,
            completionHandler: completionHandler)?
            .resume()
    }
    
    /**
     根据 id 获取对应电影条目
     
     - parameter id:                电影 id
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHanlder: 请求完成的回调
     */
    func movie(forId id: String, forceReload: Bool = false, completionHandler: ResponseHandler?) {
        self.requestType = .subject(subjectId: id)
        makeGETRequest(
            withURL: self.requestURLString,
            parameters: nil,
            forceReload: forceReload,
            completionHandler: completionHandler)?
            .resume()
    }
    
    /**
     根据 id 获取影人条目
     
     - parameter id:                影人 id
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func celebrity(forId id: String, forceReload: Bool = false, completionHandler: ResponseHandler?) {
        
        self.requestType = RequestType.celebrity(celebritId: id)
        
        makeGETRequest(
            withURL: self.requestURLString,
            parameters: nil,
            forceReload: forceReload,
            completionHandler: completionHandler)?
            .resume()
    }
    /**
     创建 GET 请求
     
     - parameter url:               请求的 url
     - parameter parameters:        请求参数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 完成时的回调
     
     - returns: 返回创建好的task
     */
    private func makeGETRequest(withURL url: String, parameters: AnyObject?, forceReload: Bool, completionHandler: ResponseHandler?) -> NSURLSessionDataTask? {
        NSLog("request url: \(url)")
        if forceReload {
            manager.requestSerializer.cachePolicy = .ReloadIgnoringLocalCacheData
        } else {
            manager.requestSerializer.cachePolicy = .ReturnCacheDataElseLoad
        }
        return manager.GET(url, parameters: parameters,
                    progress: { (progress: NSProgress) in
                        
                    },
                    success: { (task: NSURLSessionDataTask, object:AnyObject?) in
                        NSLog("request success")
                        completionHandler?(responseJSON: object as? NSDictionary, error: nil)
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        NSLog("request failed")
                        completionHandler?(responseJSON: nil, error: error)
                    })
    }
    
    deinit{
        for task in manager.dataTasks {
            task.suspend()
        }
    }
}

/**
 网络请求的类型
 
 - inTheater: 请求正在热映
 - search:    搜索电影
 - subject:   指定的电影条目
 - celebrity: 指定的影人条目
 */
enum RequestType: CustomStringConvertible {
    case inTheater
    case search
    case subject(subjectId: String)
    case celebrity(celebritId: String)
    
    var baseURL: String {
        return "http://api.douban.com/v2/movie/"
    }
    
    var description: String {
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