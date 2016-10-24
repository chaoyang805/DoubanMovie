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


import Foundation

protocol DoubanAPI {
    associatedtype ResponseHandler
    
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
