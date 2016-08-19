//
//  MovieDetailViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var doubanService: DoubanService = {
        
        return DoubanService.sharedService
    }()
    
    private lazy var realmHelper: RealmHelper = {
        
        return RealmHelper()
    }()
    
    private lazy var likedImage: UIImage = {
        
        return UIImage(named: "icon-liked")!
    }()
    
    private lazy var normalImage: UIImage = {
        return UIImage(named: "icon-like-normal")!
    }()
    
    var detailMovie: DoubanMovie?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var artistsScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieSummaryText: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieCastsLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieCollectCountLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var likeBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryMovieDetail()
        configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        notifyObserver()
    }
    
    private var deleted: Bool = false
    
    private func notifyObserver() {
        NSNotificationCenter.defaultCenter().postNotificationName(DBMMovieDidDeleteNotificationName, object: nil, userInfo: [DBMMovieDeleteNotificationKey : deleted])
    }
    
    @IBAction func favoriteBarButtonPressed(sender: UIBarButtonItem) {
        movieExistAtRealm() ? deleteMovieFromRealm() : addMovieToFavorite()
    }
    
    func configureView() {
        guard let movie = detailMovie else { return }
        
        let exists = realmHelper.movieExists(movie.id)
        if exists {
            likeBarButton.image = likedImage
        }
        
        posterImageView.sd_setImageWithURL(NSURL(string: movie.images!.largeImageURL), placeholderImage: UIImage(named: "placeholder"))
        navigationItem.title = movie.title
        movieTitleLabel.text = movie.title
        movieCastsLabel.text = movie.castsDescription
        movieDirectorLabel.text = movie.directorsDescription
        movieGenresLabel.text = movie.genres
        movieCollectCountLabel.text = String(format: "%d人看过",movie.collectCount)
        movieYearLabel.text = movie.year
        movieSummaryText.text = movie.summary
        // configure casts
        addAvatars(withMovie: movie)
        
    }
    
    func addAvatars(withMovie movie: DoubanMovie) {
        let artistCount = movie.directors.count + movie.casts.count
        artistsScrollView.contentSize = CGSize(width: CGFloat(artistCount) * (60 + 20), height: artistsScrollView.frame.height)

        artistsScrollView.showsVerticalScrollIndicator = false
        artistsScrollView.showsHorizontalScrollIndicator = false
        
        for (index, director) in movie.directors.enumerate() {
            guard let _ = director.avatars else { continue }
            addAvatarView(withCelebrity: director, at: index)
        }
        
        for (index, actor) in movie.casts.enumerate() {
            guard let _ = actor.avatars else { continue }
            addAvatarView(withCelebrity: actor, at: index + movie.directors.count)
        }
    }
    
    private let vSpacing: CGFloat = 20
    private let width: CGFloat = 60
    
    func addAvatarView(withCelebrity celebrity: DoubanCelebrity, at position: Int) {
        let position = CGPoint(x: CGFloat(position) * (width + vSpacing), y: 0)
        let avatarView = AvatarView(frame: CGRect(origin: position, size: CGSize(width: width, height: 90)), celebrity: celebrity)
        artistsScrollView.addSubview(avatarView)
    }
    
    func queryMovieDetail() {

        guard let movie = detailMovie, id = detailMovie?.id else {return }
        
        /**
         *  如果summary不为空，说明已经更新过了
         */
        if !movie.summary.isEmpty {
            return
        }
        
        // 如果该条目是收藏的条目，直接从数据库中查询summary信息，不再请求网络
        if movieExistAtRealm() {
            realmHelper.getFavoriteMovie(byId: id, completion: { [weak self](movie) in
                guard let `self` = self, movie = movie else { return }
                self.detailMovie?.summary = movie.summary
            })
        } else {
            loadMovieSummaryFromNetwork(byId:id)
        }
    }
    /**
     从网络请求电影的summary
    
     - parameter id: 电影的id
     */
    func loadMovieSummaryFromNetwork(byId id: String) {
        
        doubanService.movie(forId: id) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }
            let updatedMovie = Mapper<DoubanMovie>().map(responseJSON)
            
            self.detailMovie?.summary = updatedMovie?.summary ?? "暂无"
            self.movieSummaryText.text = self.detailMovie?.summary
        }
    }
    
}

// Modify Favorite Movie
extension MovieDetailViewController {
    
    func movieExistAtRealm() -> Bool {
        guard let movie = detailMovie else { return false }
        return realmHelper.movieExists(movie.id)
    }
    
    /**
     取消收藏当前页面的电影
     */
    func deleteMovieFromRealm() {
        guard let movieId = detailMovie?.id else { return }
        realmHelper.deleteMovieById(movieId)
        likeBarButton.image = normalImage
        deleted = true
    }
    
    func addMovieToFavorite() {
        guard let movie = detailMovie else { return }
        movie.collectDate = NSDate()
        realmHelper.addFavoriteMovie(movie, copy: true)
        likeBarButton.image = likedImage
        deleted = false
    }

    
}
