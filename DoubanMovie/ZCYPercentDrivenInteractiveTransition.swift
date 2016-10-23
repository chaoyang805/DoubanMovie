//
//  ZCYPercentDrivenInteractiveTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/10/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ZCYPercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {

    weak var animator: UIViewControllerAnimatedTransitioning?
    var isInteracting = false
    var displayLink: CADisplayLink!
    
    var transitionContext: UIViewControllerContextTransitioning!
    
    var duration: CGFloat!
    var percentComplete: CGFloat! {
        didSet {
            self.setTimeOffset(timeOffset: TimeInterval(self.percentComplete * self.duration))
        }
    }
    
    var animationCurve: UIViewAnimationCurve {
        return .linear
    }
    
    init(animator: UIViewControllerAnimatedTransitioning) {
        super.init()
        self.animator = animator
    }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {
        self.percentComplete = max(min(percentComplete, 1), 0)
        
    }
    
    func cancelInteractiveTransition() {
        self.transitionContext.cancelInteractiveTransition()
        self.completeTransition()
    }
    
    func completeTransition() {
        displayLink = CADisplayLink(target: self, selector: #selector(ZCYPercentDrivenInteractiveTransition.tickAnimation))
    }
    
    func tickAnimation() {
        let timeOffset = self.timeOffset()! as TimeInterval
//        let tick = displayLink.duration * self.completionSpeed()
    }
    
    func timeOffset() -> CFTimeInterval? {
        return transitionContext.containerView.layer.timeOffset
    }
    
    func finishInteractiveTransition() {
        
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        assert(animator != nil, "The animator property must be set at the start of an interactive transition.")
        
        self.transitionContext = transitionContext
        
        self.transitionContext.containerView.layer.speed = 0
        animator?.animateTransition(using: transitionContext)
    }
    var completionSpeed: CGFloat = 1.0
    
    var completionCurve: UIViewAnimationCurve = .linear
    
    func setTimeOffset(timeOffset: TimeInterval) {
        self.transitionContext.containerView.layer.timeOffset = timeOffset
        
    }
}
