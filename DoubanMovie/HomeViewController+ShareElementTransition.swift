//
//  HomeViewController+ShareElementTransition.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/22.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit


extension HomeViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,animationControllerFor operation: UINavigationControllerOperation,from fromVC: UIViewController,to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && fromVC is HomeViewController && toVC is MovieDetailViewController {
            return ShareElementPushTransition()
        } else {
            return nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        
    }
}

