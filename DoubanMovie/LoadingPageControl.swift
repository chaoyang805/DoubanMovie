//
//  LoadingPageControl.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/19.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class LoadingPageControl: UIPageControl, LoadingEffect {
    
    private(set) var isLoading: Bool = false
    private let animateDuration: TimeInterval = 0.3
    private let animateOffset: CGFloat = 8
    
    func beginLoading() {
        if isLoading {
            return
        }
        isLoading = true
        let dots = self.subviews
        
        for (index, dot) in dots.enumerated() {
            let delay = Double(index) * (animateDuration / 2)
            animateView(dot, withDuration: animateDuration, afterDelay: delay)
        }
    }
    
    func endLoading() {
        isLoading = false
    }
    
    func animateView(_ dot: UIView, withDuration duration: TimeInterval, afterDelay delay: TimeInterval) {
        return UIView.animate(
            withDuration: duration,
            delay: delay,
            options:[UIViewAnimationOptions.curveEaseIn],
            animations: {
                dot.center.y -= self.animateOffset
            },
            completion: { done in
                
                return UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: [UIViewAnimationOptions.curveEaseOut],
                    animations: {
                        dot.center.y += self.animateOffset
                    },
                    completion: { [weak self](done) in
                        
                        guard let `self` = self , self.isLoading else { return }
                        self.animateView(dot,
                            withDuration: duration,
                            afterDelay: Double(self.subviews.count) / 2 * duration)
                        
                    })
                
            })
        
    }
    
}
