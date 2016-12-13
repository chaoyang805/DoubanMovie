//
//  HomeViewController+Paging.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 2016/11/9.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

// MARK: - Pages
extension HomeViewController {
    
    func handleGestures(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        guard let myView = movieDialogView else { return }
        
        let boxLocation = sender.location(in: myView)
        
        switch sender.state {
        case .began:
            if let snap = snapBehavior{
                animator.removeBehavior(snap)
            }
            let centerOffset = UIOffset(horizontal: boxLocation.x - myView.bounds.midX, vertical: boxLocation.y - myView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            animator.addBehavior(attachmentBehavior)
        case .changed:
            attachmentBehavior.anchorPoint = location
        case .ended:
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapTo: CGPoint(x: view.center.x, y: view.center.y + 22))
            
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translation(in: view)
            
            if abs(translation.x) < 150 {
                return
            }
            animator.removeAllBehaviors()
            if gravityBehavior == nil {
                gravityBehavior = UIGravityBehavior(items: [myView])
            }
            if translation.x < -150 {
                // 左
                gravityBehavior.gravityDirection = CGVector(dx: -20.0, dy: 0)
            } else if translation.x > 150 {
                // 右
                gravityBehavior.gravityDirection = CGVector(dx: 20.0, dy: 0)
            }
            animator.addBehavior(gravityBehavior)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(300), execute: {
                self.refreshData()
            })
        default:
            break
        }
        
    }
    
    private func refreshData() {
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: movieDialogView, snapTo: view.center)
        movieDialogView.center = CGPoint(x: view.center.x, y: view.center.y + 20)
        attachmentBehavior.anchorPoint = CGPoint(x: view.center.x, y: view.center.y + 20)
        
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let offsetX = gravityBehavior.gravityDirection.dx < 0 ? self.view.frame.width + 200 : -200
        let translation = CGAffineTransform(translationX:offsetX, y: 0)
        
        movieDialogView.transform = scale.concatenating(translation)
        
        if gravityBehavior.gravityDirection.dx < 0 {
            currentPage = (currentPage + 1) % movieCount
            
        } else {
            currentPage = currentPage <= 0 ? movieCount - 1 : currentPage - 1
        }
        
        showCurrentMovie(animated: true)
    }
    
    func showCurrentMovie(animated: Bool) {
        guard movieCount > 0 && currentPage < movieCount else { return }
        
        pageControl.currentPage = currentPage
        
        let currentMovie = movies[currentPage]
        movieDialogView.configureWith(currentMovie)

        backgroundImageView.sd_setImage(with: URL(string: currentMovie.images!.mediumImageURL), placeholderImage: placeHolderImage)
        if animated {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.movieDialogView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
}
