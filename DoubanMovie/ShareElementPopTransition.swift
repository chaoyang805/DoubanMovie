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
class ShareElementPopTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? HomeViewController else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? MovieDetailViewController else { return }
        
        let container = transitionContext.containerView
        
        let snapshotView = UIImageView(image: fromVC.posterImageView.image)
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.frame = container.convert(fromVC.posterImageView.frame, from: fromVC.scrollView)
        
        fromVC.posterImageView.isHidden = true
        fromVC.view.alpha = 1
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.movieDialogView.isHidden = true
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseInOut,
            animations: {

                snapshotView.frame = container.convert(toVC.movieDialogView.posterImageButton.frame, from: toVC.movieDialogView)
                snapshotView.layer.cornerRadius = 10
                fromVC.view.alpha = 0
        
            },
            completion: { (done) in
        
                toVC.movieDialogView.isHidden = false
                toVC.movieDialogView.titleBarView.effect = nil
                UIView.animate(withDuration: 0.2, animations: {
            
                    toVC.movieDialogView.titleBarView.effect = UIBlurEffect(style: .light)
                })
        
                snapshotView.removeFromSuperview()
                fromVC.posterImageView.isHidden = false
                fromVC.view.alpha = 1

                let transitionCancelled = transitionContext.transitionWasCancelled
                if transitionCancelled {
                    transitionContext.cancelInteractiveTransition()
                }
                transitionContext.completeTransition(!transitionCancelled)
                
            })

    }
    
}
