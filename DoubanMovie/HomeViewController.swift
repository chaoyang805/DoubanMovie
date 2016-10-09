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
import RealmSwift

class HomeViewController: UIViewController{

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: LoadingPageControl!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
    var movieDialogView: MovieDialogView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
    var doubanService: DoubanService {
        return DoubanService.sharedService
    }
    
    lazy var realm: RealmHelper = {
        return RealmHelper()
    }()
    
    lazy var placeHolderImage: UIImage = {
    
        return UIImage(named: "placeholder")!
    }()
    
    var movieCount: Int {
        return resultsSet != nil ? resultsSet.subjects.count : 0
    }
    
    var resultsSet: DoubanResultsSet! {
        didSet {
            self.pageControl.numberOfPages = movieCount
            showCurrentMovie()
        }
    }
    
    var currentPage: Int = 0
    
    var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieDialogView()
        self.fetchData()
    }
    
    private func setupMovieDialogView() {
        
        let dialogWidth = screenWidth * 280 / 375
        let dialogHeight = dialogWidth / 280 * 373
        let x = (screenWidth - dialogWidth) / 2
        let y = (screenHeight - dialogHeight + 44) / 2
        movieDialogView = MovieDialogView(frame: CGRect(x: x, y: y, width: dialogWidth, height: dialogHeight))
        
        movieDialogView.addTarget(self, action: #selector(HomeViewController.movieDialogViewDidTouch(_:)), for: .TouchUpInside)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.handleGestures(_:)))
        self.movieDialogView.addGestureRecognizer(panGesture)
        
        self.view.addSubview(movieDialogView)
        
        animator = UIDynamicAnimator(referenceView: self.view)
    }
    
    func movieDialogViewDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    
    // MAKR: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetailSegue" {
            guard let toVC = segue.destinationViewController as? MovieDetailViewController else { return }
            toVC.detailMovie = resultsSet.subjects[currentPage]
        }
        
        if segue.identifier == "MenuSegue" {
            if let toVC = segue.destinationViewController as? MenuViewController {
                if toVC.delegate == nil {
                    toVC.delegate = self
                }
            }
        }
        
    }
}

// MARK: - refresh home view controller
extension HomeViewController {
    
    @IBAction func refreshButtonDidTouch(sender: UIBarButtonItem) {
        
        self.fetchData(true)
    }
    
    /**
     refresh home screen data
    
     - parameter force: force reload from internet or load local cache data
     */
    func fetchData(force: Bool = false) {
        
        doubanService.getInTheaterMovies(at: 0, resultCount:5,forceReload: force) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }

            self.endLoading()
            
            if error != nil {
                Snackbar.make("刷新失败，请稍后重试", duration: .Short).show()
            }
            if responseJSON != nil {
                self.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
            }

        }
        
        self.beginLoading()
    }
    
    func beginLoading() {
        UIView.animateWithDuration(0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 0
            
        }
        self.refreshBarButtonItem.enabled = false
        self.movieDialogView.beginLoading()
        self.pageControl.beginLoading()
    }
    
    func endLoading() {

        UIView.animateWithDuration(0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 1
            
        }
        self.refreshBarButtonItem.enabled = true
        self.movieDialogView.endLoading()
        self.pageControl.endLoading()
    }
    
    func performFetch(completion: () -> Void) {
        dispatch_async(dispatch_queue_create("network", DISPATCH_QUEUE_SERIAL)) {
            NSLog("perform loading start...")
            NSThread.sleepForTimeInterval(5)
            NSLog("perform loading completed")
            dispatch_sync(dispatch_get_main_queue(), { 
                completion()
            })
        }
    }
    
}


// MARK: - Pages
extension HomeViewController {
    
    @IBAction func handleGestures(sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let myView = movieDialogView
        
        let boxLocation = sender.locationInView(myView)
        
        switch sender.state {
        case .Began:
            if let snap = snapBehavior{
                animator.removeBehavior(snap)
            }
            let centerOffset = UIOffset(horizontal: boxLocation.x - myView.bounds.midX, vertical: boxLocation.y - myView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            animator.addBehavior(attachmentBehavior)
        case .Changed:
            attachmentBehavior.anchorPoint = location
        case .Ended:
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: CGPoint(x: view.center.x, y: view.center.y + 22))

            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)
            
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC * 300)), dispatch_get_main_queue(), {
                self.refreshData()
            })
        default:
            break
        }
        
    }
    
    func refreshData() {
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: movieDialogView, snapToPoint: view.center)
        movieDialogView.center = CGPoint(x: view.center.x, y: view.center.y + 20)
        attachmentBehavior.anchorPoint = CGPoint(x: view.center.x, y: view.center.y + 20)
        
        animateShowDialog()
    }
    
    func animateShowDialog() {
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let offsetX = gravityBehavior.gravityDirection.dx < 0 ? self.view.frame.width + 200 : -200
        let translation = CGAffineTransformMakeTranslation(offsetX, 0)
        movieDialogView.transform = CGAffineTransformConcat(scale, translation)
        
        if gravityBehavior.gravityDirection.dx < 0 {
            currentPage = (currentPage + 1) % movieCount
            
        } else {
            currentPage = currentPage <= 0 ? movieCount - 1 : currentPage - 1
        }
        
        showCurrentMovie()
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.movieDialogView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func showCurrentMovie() {
        guard movieCount > 0 && currentPage < movieCount else { return }
        
        pageControl.currentPage = currentPage
        
        let currentMovie = resultsSet.subjects[currentPage]
        movieDialogView.movie = currentMovie
        backgroundImageView.sd_setImageWithURL(NSURL(string: currentMovie.images!.mediumImageURL), placeholderImage: placeHolderImage)
    }
    
}