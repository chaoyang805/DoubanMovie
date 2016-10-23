//
//  ShareElementPushTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ShareElementPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController else { return }
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MovieDetailViewController else { return }
        
        let container = transitionContext.containerView

        let snapshotView = UIImageView(image: fromVC.movieDialogView.posterImageButton.imageView?.image)
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.layer.cornerRadius = 10
        snapshotView.frame = container.convert(fromVC.movieDialogView.posterImageButton.frame, from: fromVC.movieDialogView)
        
        fromVC.movieDialogView.isHidden = true
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseInOut,
            animations: {

                snapshotView.frame = toVC.posterImageView.frame.offsetBy(dx: 0, dy: 64)
                toVC.view.alpha = 1
            }) { done in
                
                fromVC.movieDialogView.isHidden = false
                snapshotView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            }
        
    }

}
