//
//  RealmHelper.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/8.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift

class RealmHelper: NSObject {
    
    private(set) var realm: Realm
    
    override init() {
        let config = Realm.Configuration(inMemoryIdentifier: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: true, objectTypes: nil)
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
     */
    func addFavoriteMovie(movie: DoubanMovie) {
        realm.beginWrite()
        realm.add(movie, update: true)
        do {
            try realm.commitWrite()
        } catch {
            print("error occured while add movie \(error)")
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
            print("error occured while add movies \(error)")
            realm.cancelWrite()
        }
    }

    /**
     从数据库中删除一条电影
     
     - parameter movie: 要删除的电影
     
     - returns: 删除是否成功
     */
    func deleteMovieFromFavorite(movie: DoubanMovie) {
        
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            print("error occured while delete a movie \(error)")
            realm.cancelWrite()
        }
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
    
}
