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
import ObjectMapper
import RxSwift
import AWPercentDrivenInteractiveTransition

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate lazy var afService: RxAlamofireService = {
        return RxAlamofireService.shared
    }()
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate lazy var realmHelper: RealmHelper = {
        
        return RealmHelper()
    }()
    
    fileprivate lazy var likedImage: UIImage = {
        
        return UIImage(named: "icon-liked")!
    }()
    
    fileprivate lazy var normalImage: UIImage = {
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
    @IBOutlet weak var likeBarButton: UIBarButtonItem!
    
    var percentDrivenInteractiveController: AWPercentDrivenInteractiveTransition!
    var shareElementPopTransition: ShareElementPopTransition! = ShareElementPopTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryMovieDetail()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifyObserver()
    }
    
    fileprivate var deleted: Bool = false
    
    private func notifyObserver() {

        NotificationCenter.default.post(name: DBMMovieDidDeleteNotificationName, object: nil, userInfo: [DBMMovieDeleteNotificationKey: deleted])
    }
    
    @IBAction func favoriteBarButtonPressed(_ sender: UIBarButtonItem) {
        movieExistAtRealm() ? deleteMovieFromRealm() : addMovieToFavorite()
    }
    
    func configureView() {
        guard let movie = detailMovie else { return }
        
        let exists = realmHelper.movieExists(id: movie.id)
        if exists {
            likeBarButton.image = likedImage
        }
        
        posterImageView.sd_setImage(with: URL(string: movie.images!.largeImageURL), placeholderImage: UIImage(named: "placeholder"))
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
        artistsScrollView.layoutIfNeeded()
        artistsScrollView.contentSize = CGSize(width: CGFloat(artistCount) * (60 + 20), height: artistsScrollView.frame.height)
        
        artistsScrollView.showsVerticalScrollIndicator = true
        artistsScrollView.showsHorizontalScrollIndicator = true
        
        for (index, director) in movie.directors.enumerated() {
            guard let _ = director.avatars else { continue }
            addAvatarView(withCelebrity: director, at: index)
        }
        
        for (index, actor) in movie.casts.enumerated() {
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

        guard let movie = detailMovie, let id = detailMovie?.id else {return }
        
        /**
         *  如果summary不为空，说明已经更新过了
         */
        if !movie.summary.isEmpty {
            return
        }
        
        // 如果该条目是收藏的条目，直接从数据库中查询summary信息，不再请求网络
        if movieExistAtRealm() {
            realmHelper.getFavoriteMovie(byId: id, completion: { [weak self](movie) in
                guard let `self` = self, let movie = movie else { return }
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
        
        afService.getMovie(by: id)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: updateSummary,
                onError: self.onLoadingError,
                onCompleted: {
                    
                },
                onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    lazy var updateSummary: (DoubanMovie) -> Void = {
        return {
            let summary = $0.summary
            self.detailMovie?.summary = summary
            self.movieSummaryText.text = summary
        }
    }()
    
    lazy var onLoadingError: (Error) -> Void = {
        return {
            NSLog("\($0.localizedDescription)")
            Snackbar.make(text: "获取详情失败", duration: .Short).show()
        }
    }()
    
}

// Modify Favorite Movie
extension MovieDetailViewController {
    
    func movieExistAtRealm() -> Bool {
        guard let movie = detailMovie else { return false }
        return realmHelper.movieExists(id: movie.id)
    }
    
    /**
     取消收藏当前页面的电影
     */
    func deleteMovieFromRealm() {
        guard let movieId = detailMovie?.id else { return }
        realmHelper.deleteMovieById(id: movieId)
        likeBarButton.image = normalImage
        deleted = true
    }
    
    func addMovieToFavorite() {
        guard let movie = detailMovie else { return }
        movie.collectDate = Date()
        realmHelper.addFavoriteMovie(movie, copy: true)
        likeBarButton.image = likedImage
        deleted = false
    }

    
}
