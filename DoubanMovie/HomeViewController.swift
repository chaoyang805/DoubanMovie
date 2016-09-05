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
    
    @IBOutlet weak var movieInfoDialog: MovieInfoView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: LoadingPageControl!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
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
    
    var shouldShowLoadingView: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieInfoDialog.addTarget(self, action: #selector(HomeViewController.movieInfoDialogDidTouch(_:)), for: .TouchUpInside)
        
        animator = UIDynamicAnimator(referenceView: self.view)

        self.fetchData()
    }
    
    func movieInfoDialogDidTouch(sender: AnyObject) {
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
        
//        self.fetchData(true)
        Snackbar.make("请求失败", duration: 1.5).show()
    }
    
    func fetchData(force: Bool = false) {
        
        doubanService.getInTheaterMovies(at: 0, resultCount:5,forceReload: force) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }
            self.shouldShowLoadingView = false
            self.endLoading()
            
            if error != nil {
                self.handleError(error!)
            }
            if responseJSON != nil {
                self.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
            }

            
        }
        // 延时 0.5s 如果还没加载出来，就显示加载界面
        self.shouldShowLoadingView = true
        delay(500) {
            if self.shouldShowLoadingView {
                self.beginLoading()
                
            } else {
                NSLog("not show loading")
            }
        }
    }
    
    func beginLoading() {
        UIView.animateWithDuration(0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 0
            
        }
        self.refreshBarButtonItem.enabled = false
        self.movieInfoDialog.beginLoading()
        self.pageControl.beginLoading()
    }
    
    func endLoading() {

        UIView.animateWithDuration(0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.backgroundImageView.alpha = 1
            
        }
        self.refreshBarButtonItem.enabled = true
        self.movieInfoDialog.endLoading()
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
    
    func handleError(error: NSError) {
        
        switch doubanService.requestType {
        case RequestType.inTheater:
            Snackbar.make("请求失败", duration: 1.5).show()
        default:
            break
        }
    }
    
}


// MARK: - Pages
extension HomeViewController {
    
    @IBAction func handleGestures(sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(movieInfoDialog)
        let myView = movieInfoDialog
        
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
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: CGPoint(x: view.center.x, y: view.center.y + 20))
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
        snapBehavior = UISnapBehavior(item: movieInfoDialog, snapToPoint: view.center)
        movieInfoDialog.center = CGPoint(x: view.center.x, y: view.center.y + 20)
        attachmentBehavior.anchorPoint = CGPoint(x: view.center.x, y: view.center.y + 20)
        
        animateShowDialog()
    }
    
    func animateShowDialog() {
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let offsetX = gravityBehavior.gravityDirection.dx < 0 ? self.view.frame.width + 200 : -200
        let translation = CGAffineTransformMakeTranslation(offsetX, 0)
        movieInfoDialog.transform = CGAffineTransformConcat(scale, translation)
        
        if gravityBehavior.gravityDirection.dx < 0 {
            currentPage = (currentPage + 1) % movieCount
            
        } else {
            currentPage = currentPage <= 0 ? movieCount - 1 : currentPage - 1
        }
        
        showCurrentMovie()
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.movieInfoDialog.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func showCurrentMovie() {
        guard movieCount > 0 && currentPage < movieCount else { return }
        
        pageControl.currentPage = currentPage
        
        let currentMovie = resultsSet.subjects[currentPage]
        movieInfoDialog.movie = currentMovie
        backgroundImageView.sd_setImageWithURL(NSURL(string: currentMovie.images!.mediumImageURL), placeholderImage: placeHolderImage)
    }
    
}