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
