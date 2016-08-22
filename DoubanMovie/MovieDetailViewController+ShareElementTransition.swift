//
//  MovieDetailViewController+ShareElementTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

extension MovieDetailViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Pop && fromVC is MovieDetailViewController && toVC is HomeViewController {
            return ShareElementPopTransition()
        } else {
            return nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
}