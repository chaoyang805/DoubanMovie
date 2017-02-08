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

import AWPercentDrivenInteractiveTransition
import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import SafariServices

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
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
        
        let viewModel = DetailMovieViewModel(
            input: (
                model: Driver.just(detailMovie!),
                likeButtonTap: likeBarButton.rx.tap.asDriver()
            ),
            dependency: (
                realm: RealmHelper(),
                alamofire: RxAlamofireService.shared
            )
        )
        
        viewModel
            .movieTitle
            .drive(navigationItem.rx.title)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieTitle
            .drive(movieTitleLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieYear
            .drive(movieYearLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieDirectors
            .drive(movieDirectorLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieCasts
            .drive(movieCastsLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .moviePoster
            .drive(posterImageView.rx.imageUrl)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieGenres
            .drive(movieGenresLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieSummary
            .drive(movieSummaryText.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieCollectionCount
            .drive(movieCollectCountLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .movieLikedEvent
            .drive(likeBarButton.rx.buttonState)
            .addDisposableTo(disposeBag)
        
        addAvatars(withMovie: detailMovie!)
    }
    
    
    private func addAvatars(withMovie movie: DoubanMovie) {
        let artistCount = movie.directors.count + movie.casts.count
        artistsScrollView.layoutIfNeeded()
        artistsScrollView.contentSize = CGSize(width: CGFloat(artistCount) * (60 + 20), height: artistsScrollView.frame.height)
        
        for (index, director) in movie.directors.enumerated() {
            guard let _ = director.avatars else { continue }
            addAvatarView(with: director, at: index)
        }
        
        for (index, actor) in movie.casts.enumerated() {
            guard let _ = actor.avatars else { continue }
            addAvatarView(with: actor, at: index + movie.directors.count)
        }
    
    }
    
    private let vSpacing: CGFloat = 20
    private let width: CGFloat = 60
    
    private func addAvatarView(with celebrity: DoubanCelebrity, at position: Int) {
        let position = CGPoint(x: CGFloat(position) * (width + vSpacing), y: 0)
        let avatarView = AvatarView(frame: CGRect(origin: position, size: CGSize(width: width, height: 90)), celebrity: celebrity)
        artistsScrollView.addSubview(avatarView)
        
        avatarView.avatarImageButton.rx
            .tap
            .subscribe(onNext: {
                if let url = URL(string: celebrity.alt) {
                    
                    let safari = SFSafariViewController(url: url)
                    safari.modalPresentationStyle = .popover
                    self.present(safari, animated: true, completion: nil)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    
}
