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
import AFNetworking
import ObjectMapper
import RxSwift
import RxAlamofire
import Alamofire

class DoubanService: DoubanAPI {
    
    typealias ResponseHandler = ((_ responseJSON: [String : Any]?, _ error: Error?) -> Void)
    
    static let sharedService = DoubanService()
    
    private(set) var requestType: RequestType = .inTheater
    
    var errorHandler: ErrorHandler?
    
    var requestURLString: String {
        return requestType.description
    }
    
    private init() {}
    
    private lazy var manager: AFHTTPSessionManager = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        let _manager = AFHTTPSessionManager(sessionConfiguration: config)
        
        _manager.responseSerializer = AFJSONResponseSerializer(readingOptions: .allowFragments)
        return _manager
    }()
    
    private lazy var alamofireManager: Alamofire.SessionManager = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
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

        let parameters: [String : Any] = ["start": start, "city": city, "count":count]
        
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
    
        let parameters: [String : Any] = ["q": query, "start": start, "count": count]
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
        
        let parameters: [String : Any] = ["tag" : tag, "start": start, "count": count]
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
        
        self.requestType = RequestType.celebrity(celebrityId: id)
        
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
    private func makeGETRequest(withURL url: String, parameters: Any?, forceReload: Bool, completionHandler: ResponseHandler?) -> URLSessionDataTask? {
        NSLog("request url: \(url)")
        if forceReload {
            manager.requestSerializer.cachePolicy = .reloadIgnoringLocalCacheData
        } else {
            manager.requestSerializer.cachePolicy = .returnCacheDataElseLoad
        }
        return manager.get(url, parameters: parameters,
                    progress: { (progress) in
                        
                    },
                    success: { (task, object) in
                        NSLog("request success")
                        completionHandler?(object as! [String : Any]?, nil)
                    },
                    failure: { (task, error) in
                        NSLog("request failed")
                        completionHandler?(nil, error)
                    })
    }
    
    deinit{
        manager.invalidateSessionCancelingTasks(true)
//        for task in manager.dataTasks {
//            task.suspend()
//        }
    }
}
