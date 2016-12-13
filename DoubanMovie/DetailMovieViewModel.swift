//
//  DetailMovieViewModel.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 2016/12/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class DetailMovieViewModel {
    
    let movieTitle: Driver<String>
    let movieSummary: Driver<String> 
    let movieDirectors: Driver<String>
    let movieCasts: Driver<String>
    let movieYear: Driver<String>
    let movieGenres: Driver<String>
    let movieCollectionCount: Driver<String>
    let moviePoster: Driver<URL?>
    let movieLikedEvent: Driver<Bool>
    
    init(input: (
            model: Driver<DoubanMovie>,
            likeButtonTap: Driver<()>
        ),
         dependency: (
            realm: RealmHelper,
            alamofire: RxAlamofireService
        )
    ) {
        
        let realm = dependency.realm
        let alamofire = dependency.alamofire
        let localModel = input.model
        
        let remoteModel = localModel
            .map { $0.id }
            .flatMapLatest {
                alamofire
                    .getMovie(by: $0)
                    .asDriver(onErrorJustReturn: DoubanMovie())
            }
        
        let completeModel = Driver
            .combineLatest(localModel, remoteModel) { movie, remoteMovie -> DoubanMovie in
                let newMovie = movie.copy() as! DoubanMovie
                newMovie.summary = remoteMovie.summary
                
                return newMovie
            }
        
        
        do {
            
            movieSummary = completeModel
                .map { $0.id }
                .flatMapLatest {
                    alamofire
                        .getMovie(by: $0)
                        .asDriver(onErrorJustReturn: DoubanMovie())
                }
                .map { $0.summary }
        }
        
        do {
            movieTitle = localModel.map { $0.title }
            
            movieDirectors = localModel
                .map {
                    $0.directors
                        .map { $0.name }
                        .joined(separator: "/")
            }
            
            movieCasts = localModel
                .map {
                    $0.casts
                        .map { $0.name }
                        .joined(separator: "/")
            }
            
            movieYear = localModel.map { $0.year }
            
            movieGenres = localModel.map { $0.genres }
            
            movieCollectionCount = localModel
                .map { "\($0.collectCount)人看过" }
            
            moviePoster = localModel
                .map { $0.images }
                .flatMapLatest { Driver.just($0) }
                .map { URL(string: $0?.largeImageURL ?? "") }
        }
        
        do {
            
            let movieBeingLiked = localModel
                .map { realm.movieExists(id: $0.id) }
            
            let tapLikeEvent = Driver
                .combineLatest(
                    input.likeButtonTap,
                    localModel
                ) { _, movie -> Bool in
                    let liked = realm.movieExists(id: movie.id)
                    liked ?
                        realm.deleteMovieById(id: movie.id) :
                        realm.addFavoriteMovie(movie, copy: true)
                    
                    NotificationCenter.default.post(name: TableViewShouldReloadNotification, object: nil)
                    return !liked
            }
            
            movieLikedEvent = Observable
                .from([movieBeingLiked, tapLikeEvent])
                .merge()
                .asDriver(onErrorJustReturn: false)
            
        }
    }
}



