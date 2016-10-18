//
//  MovieDetailViewController+ShareElementTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import AWPercentDrivenInteractiveTransition

extension MovieDetailViewController: UINavigationControllerDelegate {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationTransition()
    }
    
    func setupNavigationTransition() {
        
        if isFromHomeViewController() {
            
            self.navigationController?.delegate = self
            let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MovieDetailViewController.handleEdgePanGesture(_:)))
            edgePanGesture.edges = .Left
            self.view.addGestureRecognizer(edgePanGesture)
            
        }
    }
    
    func isFromHomeViewController() -> Bool {
        guard let naviVC = navigationController else { return false }
        return naviVC.viewControllers.count == 2
    }
    
    func handleEdgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let progress = sender.translationInView(self.view).x / self.view.bounds.width
        let velocityX = sender.velocityInView(self.view).x
        switch sender.state {
        case .Began:
            
            percentDrivenInteractiveController = AWPercentDrivenInteractiveTransition(animator: shareElementPopTransition)
            navigationController?.popViewControllerAnimated(true)
        case .Changed:
            percentDrivenInteractiveController.updateInteractiveTransition(progress)
        case .Ended, .Cancelled:
            progress > 0.3 || velocityX > 500 ?
                percentDrivenInteractiveController.finishInteractiveTransition()
                :
                percentDrivenInteractiveController.cancelInteractiveTransition()
            
            percentDrivenInteractiveController = nil
        default:
            break
        }
    }
    
    // MARK - <UINavigationControllerDelegate>
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController is ShareElementPopTransition {
            return percentDrivenInteractiveController
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Pop && fromVC is MovieDetailViewController && toVC is HomeViewController {
            if shareElementPopTransition == nil {
                shareElementPopTransition = ShareElementPopTransition()
            }
            return shareElementPopTransition
        } else {
            return nil
        }
    }

}