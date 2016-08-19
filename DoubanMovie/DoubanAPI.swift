//
//  DoubanAPI.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

protocol DoubanAPI {
    associatedtype  ResponseHandler
    
    /**
     请求正在上映的电影
     
     - parameter city:              请求数据所在的城市
     - parameter start:             返回数据的起始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func getInTheaterMovies(inCity city: String, at start: Int, resultCount count: Int, forceReload: Bool, completionHandler: ResponseHandler?)
    
    /**
     根据关键字搜索电影
     
     - parameter query:             关键字
     - parameter start:             开始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func searchMovies(withQuery query: String, at start: Int, resultCount count: Int, forceReload: Bool, completionHandler: ResponseHandler?)
 
    /**
     根据标签搜索电影
     
     - parameter tag:               搜索标签
     - parameter start:             开始位置
     - parameter count:             请求结果数
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func searchMovies(withTag tag: String, at start: Int, resultCount count: Int, forceReload: Bool, completionHandler: ResponseHandler?)
    
    /**
     根据 id 获取对应电影条目
     
     - parameter id:                电影 id
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHanlder: 请求完成的回调
     */
    func movie(forId id: String, forceReload: Bool, completionHandler: ResponseHandler?)
    
    /**
     根据 id 获取影人条目
     
     - parameter id:                影人 id
     - parameter forceReload        是否忽略缓存强制刷新，默认为false
     - parameter completionHandler: 请求完成的回调
     */
    func celebrity(forId id: String, forceReload: Bool, completionHandler: ResponseHandler?)
    
    
}