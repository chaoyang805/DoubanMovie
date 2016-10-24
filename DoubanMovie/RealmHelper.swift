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
import RealmSwift

class RealmHelper: NSObject {
    
    private(set) var realm: Realm
    
    override init() {
        
        let migrationBlock: MigrationBlock = { (migration, oldSchemaVersion) in
        
            if oldSchemaVersion == 1 {
                migration.enumerateObjects(ofType: DoubanMovie.className(), { (oldObject, newObject) in
                    newObject!["collectDate"] = NSDate()
                })
            }
            if oldSchemaVersion == 2 {
                migration.enumerateObjects(ofType: DoubanMovie.className(), { (oldObject, newObject) in
                    
                    if let directors = oldObject?["directors"] as? List<DoubanCelebrity> {
                        newObject!["directorsDescription"] = (directors.reduce("") { $0 + "/" + $1.name }.stringByRemoveFirstCharacter() as AnyObject)
                    }
                    if let casts = oldObject?["casts"] as? List<DoubanCelebrity> {
                        newObject!["castsDescription"] = (casts.reduce("") { $0  + "/" + $1.name }.stringByRemoveFirstCharacter() as AnyObject)
                    }
                    
                })
            }
        }
        
        let config = Realm.Configuration(inMemoryIdentifier: nil, encryptionKey: nil, readOnly: false, schemaVersion: 3, migrationBlock: migrationBlock, deleteRealmIfMigrationNeeded: false, objectTypes: nil)
        
//            Realm.Configuration(inMemoryIdentifier: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: true, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
        
        super.init()
    }
    
    func getRealmLocation() {
        NSLog("realm path: \(realm.configuration.fileURL)")
    }
    
    /**
     添加电影到收藏里
     
     - parameter movie: 要添加的电影对象
     
     - parameter copy: 是否拷贝对象，如果拷贝的话，当删除后仍然可以访问原来的对象
     */
    func addFavoriteMovie(_ movie: DoubanMovie, copy: Bool = false) {
        realm.beginWrite()
        
        realm.add(copy ? movie.copy() as! DoubanMovie : movie, update: true)
        do {
            try realm.commitWrite()
        } catch {
            NSLog("error occured while add movie \(error)")
            realm.cancelWrite()
        }
    }
    
    /**
     添加多个电影到收藏里
     
     - parameter movies: 要添加的所有电影
     */
    func addFavoriteMovies(movies: [DoubanMovie]) {
        realm.beginWrite()
        realm.add(movies, update: true)
        do {
            try realm.commitWrite()
        } catch {
            NSLog("error occured while add movies \(error)")
            realm.cancelWrite()
        }
    }

    /**
     从数据库中删除一条电影
     
     - parameter movie: 要删除的电影
     
     - returns: 删除是否成功
     */
    func deleteMovieFromFavorite(_ movie: DoubanMovie) {
        
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            NSLog("error occured while delete a movie \(error)")
            realm.cancelWrite()
        }
    }
    
    /**
     根据提供的id从数据库中删除一个电影条目
     
     - parameter id: 电影的id
     */
    func deleteMovieById(id: String) {
        guard let movieToDel = realm.objects(DoubanMovie.self).filter("id = %s", id).first else { return }
        deleteMovieFromFavorite(movieToDel)
    }
    
    /**
     通过id 获得对应的电影条目
     
     - parameter id:         电影id
     - parameter completion: 查询完成的回调
     */
    func getFavoriteMovie(byId id: String, completion: ((DoubanMovie?) -> Void)?) {

        let movie = self.realm.objects(DoubanMovie.self).filter("id = %s", id).first
        completion?(movie)
    
    }
    
    /**
     获得所有收藏的电影
     
     - returns: 返回当前所有收藏
     */
    func getAllFavoriteMovies(completion: ((Results<DoubanMovie>) -> Void)?) {

        let results = self.realm.objects(DoubanMovie.self)
        completion?(results)
        
    }
    
    /**
     某个电影条目是否已经收藏
     
     - parameter id: 电影的id
    
     - returns: 如果存在则返回true
     */
    func movieExists(id: String) -> Bool {
        let exists = realm.objects(DoubanMovie.self).filter("id = %s", id).count > 0
        return exists
    }
    
    func updateMovieInfo(updateBlock: ()-> Void) {
        realm.beginWrite()
        updateBlock()
        do {
            try realm.commitWrite()
        } catch {
            NSLog("error occured while delete a movie \(error)")
            realm.cancelWrite()
        }
    }
    
}
