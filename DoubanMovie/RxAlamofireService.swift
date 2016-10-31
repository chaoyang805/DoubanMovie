//
//  RxAlamofireService.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/10/28.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class RxAlamofireService: NSObject {
    
    private lazy var alamofireManager: Alamofire.SessionManager = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    static let shared = RxAlamofireService()
    
    private override init() {}
    
    /// 请求电影条目列表
    ///
    /// - parameter city:        所在城市 默认北京
    /// - parameter start:       开始位置 默认为0
    /// - parameter count:       请求条目数量 默认为5
    /// - parameter forceReload: 是否强制刷新 默认为 false
    ///
    /// - returns: 返回 Observable<[DoubanMovie]>
    public func loadMovies(in city: String = "北京", at start: Int = 0, resultCount count: Int = 5, forceReload: Bool = false) -> Observable<[DoubanMovie]> {
        
        let parameters: [String : Any] = ["start" : start, "city" : city, "count" : count]
        
        return makeGetRequest(
                with: RequestType.inTheater,
                modelType: DoubanResultsSet.self,
                parameters: parameters,
                forceReload: forceReload)
                    .map { $0.subjects }
    }
    
    /// 根据关键字搜索电影
    ///
    /// - parameter query:       搜索关键字
    /// - parameter start:       开始位置
    /// - parameter count:       请求条目数
    /// - parameter forceReload: 是否强制刷新
    ///
    /// - returns: 返回 Observable<[DoubanMovie]>
    public func searchMovies(byQuery query: String, from start: Int = 0, resultCount count: Int = 20, forceReload: Bool = false) -> Observable<[DoubanMovie]> {
    
        let parameters: [String : Any] = ["q" : query, "start" : start, "count" : count]
        
        return makeGetRequest(
            with: RequestType.search,
            modelType: DoubanResultsSet.self,
            parameters: parameters,
            forceReload: forceReload)
            .map { $0.subjects }
    }
    
    /// 根据标签搜索电影
    ///
    /// - parameter tag:         根据标签搜索电影条目
    /// - parameter start:       开始位置
    /// - parameter count:       请求条目数
    /// - parameter forceReload: 是否强制刷新
    ///
    /// - returns: 返回 Observable<[DoubanMovie]>
    public func searchMovies(byTag tag: String, from start: Int = 0, resultCount count: Int = 20, forceReload: Bool = false) -> Observable<[DoubanMovie]> {
        
        let parameters: [String : Any] = ["tag" : tag, "start" : start, "count" : count]
        
        return makeGetRequest(
            with: RequestType.search,
            modelType: DoubanResultsSet.self,
            parameters: parameters,
            forceReload: forceReload)
            .map { $0.subjects }
    }
    
    /// 请求电影条目详情
    ///
    /// - parameter id: 条目 id
    ///
    /// - returns: 返回 Observable<DoubanMovie>
    public func getMovie(by id: String) -> Observable<DoubanMovie> {
        return makeGetRequest(with: .subject(subjectId: id), modelType: DoubanMovie.self)
    }
    
    
    /// 请求艺人条目详情
    ///
    /// - parameter id: 条目 id
    ///
    /// - returns: 返回 Observable<DoubanCelebrity>
    public func getCelebrity(by id: String) -> Observable<DoubanCelebrity> {
        return makeGetRequest(with: .celebrity(celebrityId: id), modelType: DoubanCelebrity.self)
    }
    
    /// 发送 GET 请求
    ///
    /// - parameter requestType: 请求的 API 类型
    /// - parameter modelType:   模型类的类型
    /// - parameter parameters:  参数
    /// - parameter forceReload: 是否强制刷新
    ///
    /// - returns: 返回 Observable<T>
    private func makeGetRequest<T>(with requestType: RequestType, modelType: T.Type, parameters: [String : Any]? = nil, forceReload: Bool = false) -> Observable<T> where T: BaseMappable {
        
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default)

        return alamofireManager.rx
            .json(.get, requestType.description, parameters: parameters)
            .map { Mapper<T>().map(JSONObject: $0) }
            .unwrap()
            .subscribeOn(backgroundScheduler)
    }


}
