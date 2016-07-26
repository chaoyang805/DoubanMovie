//
//  HomeViewController+MenuViewControllerDelegate.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/26.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

extension HomeViewController: MenuViewControllerDelegate {
    func menuViewController(_ controller: MenuViewController, didClickButtonWithType type: MenuButtonType) {
        switch type {
        case .now:
            
            break
        case .all:
            presentNowTableViewController()
        case .search:
            break
        case .favorite:
            break
        }
    }
    
    func presentNowTableViewController() {
        self.performSegue(withIdentifier: "AllMovieSegue", sender: self)
    }
}
