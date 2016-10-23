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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationTransition()
    }
    
    func setupNavigationTransition() {
        
        if isFromHomeViewController() {
            
            self.navigationController?.delegate = self
            let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MovieDetailViewController.handleEdgePanGesture(_:)))
            edgePanGesture.edges = .left
            self.view.addGestureRecognizer(edgePanGesture)
            
        }
    }
    
    func isFromHomeViewController() -> Bool {
        guard let naviVC = navigationController else { return false }
        return naviVC.viewControllers.count == 2
    }
    
    func handleEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let progress = sender.translation(in: self.view).x / self.view.bounds.width
        let velocityX = sender.velocity(in: self.view).x
        switch sender.state {
        case .began:
            
            percentDrivenInteractiveController = AWPercentDrivenInteractiveTransition(animator: shareElementPopTransition)
            let _ = navigationController?.popViewController(animated: true)
        case .changed:
            percentDrivenInteractiveController.update(progress)
        case .ended, .cancelled:
            progress > 0.3 || velocityX > 500 ?
                percentDrivenInteractiveController.finish()
                :
                percentDrivenInteractiveController.cancel()
            
            percentDrivenInteractiveController = nil
        default:
            break
        }
    }
    
    // MARK - <UINavigationControllerDelegate>
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is ShareElementPopTransition {
            return percentDrivenInteractiveController
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop && fromVC is MovieDetailViewController && toVC is HomeViewController {
            if shareElementPopTransition == nil {
                shareElementPopTransition = ShareElementPopTransition()
            }
            return shareElementPopTransition
        } else {
            return nil
        }
    }

}
