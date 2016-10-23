//
//  HomeViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage
import ObjectMapper

class HomeViewController: UIViewController{

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: LoadingPageControl!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
    private(set) var movieDialogView: MovieDialogView!
    
    fileprivate var animator: UIDynamicAnimator!
    fileprivate var attachmentBehavior: UIAttachmentBehavior!
    fileprivate var gravityBehavior: UIGravityBehavior!
    fileprivate var snapBehavior: UISnapBehavior!
    
    fileprivate var imagePrefetcher = SDWebImagePrefetcher()
    
    fileprivate var doubanService: DoubanService {
        return DoubanService.sharedService
    }
    
    fileprivate lazy var realm: RealmHelper = {
        return RealmHelper()
    }()
    
    fileprivate lazy var placeHolderImage: UIImage = {
    
        return UIImage(named: "placeholder")!
    }()
    
    fileprivate var movieCount: Int {
        return resultsSet != nil ? resultsSet.subjects.count : 0
    }
    
    fileprivate var resultsSet: DoubanResultsSet! {
        didSet {
            self.pageControl.numberOfPages = movieCount
            showCurrentMovie(animated: false)
        }
    }
    
    fileprivate var currentPage: Int = 0
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieDialogView()
        self.fetchData()
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
            toVC.detailMovie = resultsSet.subjects[currentPage]
        }
        
        if segue.identifier == "MenuSegue" {
            if let toVC = segue.destination as? MenuViewController {
                if toVC.delegate == nil {
                    toVC.delegate = self
                }
            }
        }
        
    }
}

// MARK: - refresh home view controller
extension HomeViewController {
    
    @IBAction func refreshButtonDidTouch(_ sender: UIBarButtonItem) {
        
        self.fetchData(force: true)
    }
    
    /**
     refresh home screen data
    
     - parameter force: force reload from internet or load local cache data
     */
    fileprivate func fetchData(force: Bool = false) {
        
        doubanService.getInTheaterMovies(at: 0, resultCount:5,forceReload: force) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }

            self.endLoading()
            
            if error != nil {
                Snackbar.make(text: "刷新失败，请稍后重试", duration: .Short).show()
            }
            if responseJSON != nil {
                self.resultsSet = Mapper<DoubanResultsSet>().map(JSON: responseJSON!)
                self.prefetchImages()
    
            }

        }
        
        self.beginLoading()
    }
    
    private func prefetchImages() {
        let urls = self.resultsSet.subjects.map { URL(string: $0.images?.mediumImageURL ?? "") }.flatMap { $0 }
        self.imagePrefetcher.prefetchURLs(urls)
    }
    
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
    // test method
    private func performFetch(completion: @escaping () -> Void) {
        DispatchQueue(label: "network", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent).async {
            
            NSLog("perform loading start...")
            Thread.sleep(forTimeInterval: 5)
            DispatchQueue.main.sync {
                completion()
                NSLog("perform loading completed")
            }
            
        }
    }
    
}


// MARK: - Pages
extension HomeViewController {
    
    @IBAction func handleGestures(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        guard let myView = movieDialogView else { return }
        
        let boxLocation = sender.location(in: myView)
        
        switch sender.state {
        case .began:
            if let snap = snapBehavior{
                animator.removeBehavior(snap)
            }
            let centerOffset = UIOffset(horizontal: boxLocation.x - myView.bounds.midX, vertical: boxLocation.y - myView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            animator.addBehavior(attachmentBehavior)
        case .changed:
            attachmentBehavior.anchorPoint = location
        case .ended:
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapTo: CGPoint(x: view.center.x, y: view.center.y + 22))

            animator.addBehavior(snapBehavior)
            
            let translation = sender.translation(in: view)
            
            if abs(translation.x) < 150 {
                return
            }
            animator.removeAllBehaviors()
            if gravityBehavior == nil {
                gravityBehavior = UIGravityBehavior(items: [myView])
            }
            if translation.x < -150 {
                // 左
                gravityBehavior.gravityDirection = CGVector(dx: -20.0, dy: 0)
            } else if translation.x > 150 {
                // 右
                gravityBehavior.gravityDirection = CGVector(dx: 20.0, dy: 0)
            }
            animator.addBehavior(gravityBehavior)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(300), execute: {
                self.refreshData()
            })
        default:
            break
        }
        
    }
    
    private func refreshData() {
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: movieDialogView, snapTo: view.center)
        movieDialogView.center = CGPoint(x: view.center.x, y: view.center.y + 20)
        attachmentBehavior.anchorPoint = CGPoint(x: view.center.x, y: view.center.y + 20)
        
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let offsetX = gravityBehavior.gravityDirection.dx < 0 ? self.view.frame.width + 200 : -200
        let translation = CGAffineTransform(translationX:offsetX, y: 0)
        
        movieDialogView.transform = scale.concatenating(translation)
        
        if gravityBehavior.gravityDirection.dx < 0 {
            currentPage = (currentPage + 1) % movieCount
            
        } else {
            currentPage = currentPage <= 0 ? movieCount - 1 : currentPage - 1
        }
        
        showCurrentMovie(animated: true)
    }
    
    fileprivate func showCurrentMovie(animated: Bool) {
        guard movieCount > 0 && currentPage < movieCount else { return }
        
        pageControl.currentPage = currentPage
        
        let currentMovie = resultsSet.subjects[currentPage]
        
        movieDialogView.movie = currentMovie
    
        backgroundImageView.sd_setImage(with: URL(string: currentMovie.images!.mediumImageURL), placeholderImage: placeHolderImage)
        if animated {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.movieDialogView.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
}
