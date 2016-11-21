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
import SDWebImage
import ObjectMapper
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class HomeViewController: UIViewController{

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: LoadingPageControl!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
    private(set) var movieDialogView: MovieDialogView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
    private var imagePrefetcher = SDWebImagePrefetcher()
    
    private var disposeBag = DisposeBag()
    
    lazy var placeHolderImage: UIImage = {
    
        return UIImage(named: "placeholder")!
    }()
    
    var movieCount: Int {
        return movies.count
    }
    
    var movies: [DoubanMovie] = []
    
    var currentPage: Int = 0
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    private var refreshing: UIBindingObserver<HomeViewController, Bool> {
        return UIBindingObserver(UIElement: self) { viewController, refresh in
            if refresh {
                viewController.beginLoading()
            } else {
                viewController.endLoading()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            setupMovieDialogView()
        }
        
        do {
            let activityIndicator = ActivityIndicator()
            
            self.refreshBarButtonItem.rx
                .tap
                .asObservable()
                .startWith(())
                .mapWithIndex { $1 != 0 }
                .flatMap {
                    RxAlamofireService.shared
                        .loadMovies(forceReload: $0)
                        .trackActivity(activityIndicator)
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: showMovies, onError: showLoadingError)
                .addDisposableTo(disposeBag)
            
            activityIndicator
                .asObservable()
                .bindTo(refreshing)
                .addDisposableTo(disposeBag)
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imagePrefetcher.cancelPrefetching()
    }
    
    private func setupMovieDialogView() {

        let dialogWidth = screenWidth * 280 / 375
        let dialogHeight = dialogWidth / 280 * 373
        let x = (screenWidth - dialogWidth) / 2
        let y = (screenHeight - dialogHeight + 44) / 2
        movieDialogView = MovieDialogView(frame: CGRect(x: x, y: y, width: dialogWidth, height: dialogHeight))
        movieDialogView.addTarget(target: self, action: #selector(HomeViewController.movieDialogViewDidTouch(_:)), for: .touchUpInside)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.handleGestures(_:)))
        self.movieDialogView.addGestureRecognizer(panGesture)
        
        self.view.addSubview(movieDialogView)
        
        animator = UIDynamicAnimator(referenceView: self.view)
    }
    
    func movieDialogViewDidTouch(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
    
    // MAKR: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetailSegue" {
            guard let toVC = segue.destination as? MovieDetailViewController else { return }
            toVC.detailMovie = movies[currentPage]
        }
        
        if segue.identifier == "MenuSegue" {
            if let toVC = segue.destination as? MenuViewController {
                if toVC.delegate == nil {
                    toVC.delegate = self
                }
            }
        }
        
    }
    
    private var showMovies: (([DoubanMovie]) -> Void) {
        return {
            NSLog("show movies")
            self.movies = $0
            self.pageControl.numberOfPages = self.movies.count
            self.showCurrentMovie(animated: false)
            self.endLoading()
            self.prefetchImages()
        }
    }
    
    private var showLoadingError: ((Error) -> Void) {
        
        return {
            NSLog("loading error:\($0.localizedDescription)")
            self.endLoading()
            Snackbar.make(text: $0.localizedDescription, duration: .Short).show()
        }
    }
    
    private func prefetchImages() {
        let urls = self.movies
            .map { URL(string: $0.images?.mediumImageURL ?? "") }
            .flatMap { $0 }
        self.imagePrefetcher.prefetchURLs(urls)
    }
    
    // MARK: - loading
    private func beginLoading() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 0
            
        }
        self.refreshBarButtonItem.isEnabled = false
        self.movieDialogView.beginLoading()
        self.pageControl.beginLoading()
    }
    
    private func endLoading() {

        UIView.animate(withDuration: 0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 1
            
        }
        self.refreshBarButtonItem.isEnabled = true
        self.movieDialogView.endLoading()
        self.pageControl.endLoading()
    }
    
}

