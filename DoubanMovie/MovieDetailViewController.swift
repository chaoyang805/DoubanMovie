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
    
    lazy var doubanService: DoubanService = {
    
        return DoubanService.sharedService
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("View did load")
        queryMovieDetail()
        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("View will appear")
    }
    
    func configureView() {
        guard let movie = detailMovie else { return }
        
        posterImageView.sd_setImageWithURL(NSURL(string: movie.images!.largeImageURL), placeholderImage: UIImage(named: "placeholder"))
        movieTitleLabel.text = movie.title
        movieCastsLabel.text = movie.castsDescription
        movieDirectorLabel.text = movie.directorsDescription
        movieGenresLabel.text = movie.genres
        movieCollectCountLabel.text = String(format: "%d人看过",movie.collectCount)
        movieYearLabel.text = movie.year
        
        NSLog("ScrollView child count: \(artistsScrollView.subviews.count)")
        
        // configure casts
        addAvatars(withMovie: movie)
        
    }
    
    func addAvatars(withMovie movie: DoubanMovie) {
        let artistCount = movie.directorsArray.count + movie.castsArray.count
        artistsScrollView.contentSize = CGSize(width: CGFloat(artistCount) * (60 + 20), height: artistsScrollView.frame.height)
        artistsScrollView.showsVerticalScrollIndicator = false
        artistsScrollView.showsHorizontalScrollIndicator = false
        artistsScrollView.bounces = false
        
        
        for (index, director) in movie.directors.enumerate() {
            guard let _ = director.avatars else { continue }
            addAvatarView(withCelebrity: director, at: index)
        }
        
        for (index, actor) in movie.casts.enumerate() {
            guard let _ = actor.avatars else { continue }
            addAvatarView(withCelebrity: actor, at: index + movie.directors.count)
        }
    }
    
    let vSpacing: CGFloat = 20
    let width: CGFloat = 60
    
    func addAvatarView(withCelebrity celebrity: DoubanCelebrity, at position: Int) {
        let position = CGPoint(x: CGFloat(position) * (width + vSpacing), y: 0)
        let avatarView = AvatarView(frame: CGRect(origin: position, size: CGSize(width: width, height: 90)), celebrity: celebrity)
        artistsScrollView.addSubview(avatarView)
    }
    
    func queryMovieDetail() {
        guard let id = detailMovie?.id else {return }
        weak var weakSelf = self
        doubanService.movie(forId: id) { (responseJSON, error) in
            
            let updatedMovie = Mapper<DoubanMovie>().map(responseJSON)
            weakSelf?.detailMovie?.summary = updatedMovie?.summary ?? ""
            weakSelf?.movieSummaryText.text = weakSelf?.detailMovie?.summary
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
