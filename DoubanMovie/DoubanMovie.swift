//
//  MovieSubject.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class DoubanMovie: Object, Mappable {

    dynamic var id: String = ""
    
    /// The movie's rating info
    dynamic var rating: MovieRating?
    
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
    
    dynamic var images: DoubanImage?
    
    /// The detail page on Douban
    dynamic var alt = ""
    
    dynamic var collectDate = Date()
    
    // MARK - One to many properties
    
    /// The movie's actors
    let casts = List<DoubanCelebrity>()
    
    /// Directors who made this movie
    let directors = List<DoubanCelebrity>()
    
    dynamic var genres: String = ""
    
    dynamic var contries: String = ""
    
    dynamic var castsDescription: String = ""
    
    dynamic var directorsDescription: String = ""
    
    // MARK - Ignored Properties
    /// The movie's genres should be ignored by Realm
    var genresArray: [String] = [] {
        didSet {
            self.genres = genresArray.isEmpty ? "" : genresArray.reduce("") { $0 + "/" + $1 }.stringByRemoveFirstCharacter()
        }
    }
    
    var contriesArray: [String] = [] {
        didSet {
            self.contries = contriesArray.isEmpty ? "" : contriesArray.reduce("") { $0 + "/" + $1 }.stringByRemoveFirstCharacter()
        }
    }
    
    var castsArray: [DoubanCelebrity] = [] {
        didSet {
            casts.removeAll()
            casts.append(objectsIn: castsArray)
            self.castsDescription = castsArray.isEmpty ? "" : castsArray.reduce("") { $0 + "/" + $1.name }.stringByRemoveFirstCharacter()
        }
    }
    
    var directorsArray: [DoubanCelebrity] = [] {
        didSet {
            directors.removeAll()
            directors.append(objectsIn: directorsArray)
            
            self.directorsDescription = directorsArray.isEmpty ? "" : directorsArray.reduce("") { $0 + "/" + $1.name }.stringByRemoveFirstCharacter()
        }
    }
    
    override class func ignoredProperties() -> [String] {
        return ["genresArray", "contriesArray", "castsArray", "directorsArray"]
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["title", "originalTitle", "year"]
    }
    // MARK - Mappable
    required convenience init?(map: Map) {
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

extension DoubanMovie: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DoubanMovie()
        copy.id = self.id
        if let rating = self.rating {
            copy.rating = rating.copy() as? MovieRating
        }
        copy.title = self.title
        copy.originalTitle = self.originalTitle
        copy.subType = self.subType
        copy.year = self.year
        copy.collectCount = self.collectCount
        copy.wishCount = self.wishCount
        copy.commentsCount = self.commentsCount
        copy.ratingsCount = self.ratingsCount
        copy.summary = self.summary
        if let images = self.images {
            copy.images = images.copy() as? DoubanImage
        }
        copy.alt = self.alt
        copy.collectDate = self.collectDate
        copy.castsArray = self.castsArray
        copy.directorsArray = self.directorsArray
        copy.genresArray = self.genresArray
        copy.contriesArray = self.contriesArray
        
        return copy
    }

}


