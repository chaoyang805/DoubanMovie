//
//  ShareElementPopTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ShareElementPopTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? HomeViewController, fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? MovieDetailViewController else {
            return
        }
        
        guard let container = transitionContext.containerView() else { return }
        
        let snapshotView = UIImageView(image: fromVC.posterImageView.image)
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.frame = container.convertRect(fromVC.posterImageView.frame, fromView: fromVC.view).offsetBy(dx: 0, dy: 64)
        
        fromVC.posterImageView.hidden = true
        fromVC.view.alpha = 1
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.movieInfoDialog.hidden = true
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0.7,
                                   options: .CurveEaseInOut,
                                   animations: {
            
                                    snapshotView.frame = container.convertRect(toVC.movieInfoDialog.posterImageButton.frame, fromView: toVC.movieInfoDialog)
                                    snapshotView.layer.cornerRadius = 10
                                    fromVC.view.alpha = 0
                                    
                                }) { (done) in
                                    
                                    toVC.movieInfoDialog.hidden = false
                                    snapshotView.removeFromSuperview()
                                    fromVC.posterImageView.hidden = false
                                    fromVC.view.alpha = 1
                                    
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                                    
                                }
    }
}
