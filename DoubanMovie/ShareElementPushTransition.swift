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
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? HomeViewController, toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? MovieDetailViewController else {
            return
        }
        guard let container = transitionContext.containerView() else { return }

        let snapshotView = UIImageView(image: fromVC.movieInfoDialog.posterImageButton.imageView?.image)
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.layer.cornerRadius = 10
        
        snapshotView.frame = container.convertRect(fromVC.movieInfoDialog.posterImageButton.frame, fromView: fromVC.movieInfoDialog)
        
        fromVC.movieInfoDialog.hidden = true
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
                                   delay: 0,
                                   
                                   options: .CurveEaseOut,
                                   animations: {
                                    
                                    snapshotView.frame = toVC.posterImageView.frame.offsetBy(dx: 0, dy: 64)
                                    toVC.view.alpha = 1
        
                                }) { (finished) in
                                    
                                    fromVC.movieInfoDialog.hidden = false
                                    snapshotView.removeFromSuperview()
                                    
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                                    
                                }
        
    }

}
