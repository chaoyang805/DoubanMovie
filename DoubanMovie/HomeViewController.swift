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
    @IBOutlet weak var pageControl: UIPageControl!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieInfoDialog.ratingInfoView.ratingScore = 5
        movieInfoDialog.addTarget(self, action: #selector(HomeViewController.movieInfoDialogDidTouch(_:)), for: .TouchUpInside)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        NSLog("loading...")
        DoubanService.sharedService.getInTheaterMovies(at: 0, resultCount:5) { [weak self](responseJSON, error) in
            NSLog("load completed")
            guard let `self` = self else { return }
            
            self.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)

        }
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

extension HomeViewController {
    
    @IBAction func refreshButtonDidTouch(sender: UIBarButtonItem) {
        NSLog("reloading...")
        DoubanService.sharedService.getInTheaterMovies(at: 0, resultCount: 5, forceReload: true) { [weak self](responseJSON, error) in
            NSLog("reload completed")
            guard let `self` = self else { return }
            self.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
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