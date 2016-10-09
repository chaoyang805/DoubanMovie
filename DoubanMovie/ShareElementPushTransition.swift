//
//  ShareElementPushTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ShareElementPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? HomeViewController, toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? MovieDetailViewController else {
            return
        }
        guard let container = transitionContext.containerView() else { return }

        let snapshotView = UIImageView(image: fromVC.movieDialogView.posterImageButton.imageView?.image)
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.layer.cornerRadius = 10
        
        snapshotView.frame = container.convertRect(fromVC.movieDialogView.posterImageButton.frame, fromView: fromVC.movieDialogView)
        
        fromVC.movieDialogView.hidden = true
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0.7,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    
                                    snapshotView.frame = toVC.posterImageView.frame.offsetBy(dx: 0, dy: 64)
                                    toVC.view.alpha = 1
        
                                }) { (finished) in
                                    
                                    fromVC.movieDialogView.hidden = false
                                    snapshotView.removeFromSuperview()
                                    
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                                    
                                }
        
    }

}
