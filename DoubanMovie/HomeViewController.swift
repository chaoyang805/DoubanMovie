//
//  HomeViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController{
    @IBOutlet weak var movieInfoDialog: MovieInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        movieInfoDialog.ratingInfoView.ratingScore = 5
        movieInfoDialog.addTarget(self, action: #selector(HomeViewController.movieInfoDialogDidTouch(_:)), for: .TouchUpInside)
        
        animator = UIDynamicAnimator(referenceView: self.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func movieInfoDialogDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    // MARK: - IBActions
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
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
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.movieInfoDialog.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    // MAKR: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetailSegue" {
            
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
