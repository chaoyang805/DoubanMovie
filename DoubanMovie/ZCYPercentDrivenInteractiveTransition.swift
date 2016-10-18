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
            self.setTimeOffset(NSTimeInterval(self.percentComplete * self.duration))
        }
    }
    
    var animationCurve: UIViewAnimationCurve {
        return .Linear
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
        let timeOffset = self.timeOffset()! as NSTimeInterval
//        let tick = displayLink.duration * self.completionSpeed()
    }
    
    func timeOffset() -> CFTimeInterval? {
        return transitionContext.containerView()?.layer.timeOffset
    }
    
    func finishInteractiveTransition() {
        
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        assert(animator != nil, "The animator property must be set at the start of an interactive transition.")
        
        self.transitionContext = transitionContext
        
        self.transitionContext.containerView()?.layer.speed = 0
        animator?.animateTransition(transitionContext)
    }
    
    func completionSpeed() -> CGFloat {
        return 1
    }
    
    func completionCurve() -> UIViewAnimationCurve {
        return .Linear
    }
    
    func setTimeOffset(timeOffset: NSTimeInterval) {
        
        self.transitionContext.containerView()?.layer.timeOffset = timeOffset
        
    }
}
