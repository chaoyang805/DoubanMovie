//
//  HomeViewController+ShareElementTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit


extension HomeViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController,animationControllerForOperation operation: UINavigationControllerOperation,fromViewController fromVC: UIViewController,toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push && fromVC is HomeViewController && toVC is MovieDetailViewController {
            return ShareElementPushTransition()
        } else {
            return nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        
    }
}

