//
//  LoadingPageControl.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/19.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
@objc protocol LoadingEffect {
    optional func setLoading(loading: Bool)
}
class LoadingPageControl: UIPageControl {
    
    private(set) var isLoading: Bool = false
    private let animateDuration: NSTimeInterval = 0.3
    private let animateOffset: CGFloat = 8
    
    
    
    func beginLoading() {
        if isLoading {
            return
        }
        isLoading = true
        let dots = self.subviews
        
        for (index, dot) in dots.enumerate() {
            let delay = Double(index) * (animateDuration / 2)
            animateView(dot, withDuration: animateDuration, afterDelay: delay)
        }
    }
    
    func endLoading() {
        isLoading = false
    }
    
    func animateView(dot: UIView, withDuration duration: NSTimeInterval, afterDelay delay: NSTimeInterval) {
        return UIView.animateWithDuration(
            duration,
            delay: delay,
            options:[UIViewAnimationOptions.CurveEaseIn],
            animations: {
                dot.center.y -= self.animateOffset
            },
            completion: { done in
                
                return UIView.animateWithDuration(
                    duration,
                    delay: 0,
                    options: [UIViewAnimationOptions.CurveEaseOut],
                    animations: {
                        dot.center.y += self.animateOffset
                    },
                    completion: { [weak self](done) in
                        
                        guard let `self` = self where self.isLoading else { return }
                        self.animateView(dot,
                            withDuration: duration,
                            afterDelay: Double(self.subviews.count) / 2 * duration)
                        
                    })
                
            })
        
    }
    
}
