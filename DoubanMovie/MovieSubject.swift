//
//  MovieSubject.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class MovieSubject: Object, Mappable{

    dynamic var id: String = ""
    
    /// The movie's rating info
    dynamic var rating: Rating?
    
    /// The movie's name
    dynamic var title: String = ""
    
    /// The original title of the movie
    dynamic var originalTitle: String = ""
    
    /// Explain this is a movie or a tv show
    dynamic var subType = ""
    
    dynamic var year = ""
    
    dynamic var collectCount: Int = 0
    
    dynamic var wishCount: Int = 0
    
    dynamic var commentsCount: Int = 0
    
    dynamic var ratingsCount: Int = 0
    
    dynamic var summary: String = ""
    
    dynamic var images: MovieImage?
    
    /// The detail page on Douban
    dynamic var alt = ""
    
    // MARK - One to many properties
    
    /// The movie's actors
    let casts = List<Artist>()
    
    /// Directors who made this movie
    let directors = List<Artist>()
    
    dynamic var genres: String = ""
    
    dynamic var contries: String = ""
    
    // MARK - Ignored Properties
    /// The movie's genres should be ignored by Realm
    var genresArray: [String] = []
    
    var contriesArray: [String] = []
    
    var castsArray: [Artist] = [] {
        didSet {
            if castsArray.count > 0 {
                for artist in castsArray {
                    casts.append(artist)
                }
            }
        }
    }
    
    var directorsArray: [Artist] = [] {
        didSet {
            if directorsArray.count > 0 {
                for artist in directorsArray {
                    directors.append(artist)
                }
            }
        }
    }
    
    override class func ignoredProperties() -> [String] {
        return ["genresArray", "contriesArray"]
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["title", "originalTitle", "year"]
    }
    // MARK - Mappable
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        rating <- map["rating"]
        originalTitle <- map["original_title"]
        subType <- map["subtype"]
        year <- map["year"]
        collectCount <- map["collect_count"]
        wishCount <- map["wish_count"]
        commentsCount <- map["comments_count"]
        ratingsCount <- map["ratings_count"]
        summary <- map["summary"]
        images <- map["images"]
        alt <- map["alt"]
        castsArray <- map["casts"]
        directorsArray <- map["directors"]
        genresArray <- map["genres"]
        contriesArray <- map["contries"]
        
    }
}


class MovieImage: Object, Mappable {
    dynamic var smallImageURL = ""
    dynamic var mediumImageURL = ""
    dynamic var largeImageURL = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        smallImageURL <- map["small"]
        mediumImageURL <- map["medium"]
        largeImageURL <- map["large"]
    }
}

class Rating: Object, Mappable {
    dynamic var max: Float = 0
    dynamic var average: Float = 0
    dynamic var stars: String = "0"
    dynamic var min: String = "0"
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        max <- map["max"]
        average <- map["average"]
        stars <- map["average"]
        min <- map["min"]
    }
}
