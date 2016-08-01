//
//  HomeViewController+MenuViewControllerDelegate.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/26.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

extension HomeViewController: MenuViewControllerDelegate {
    
    // MARK - MenuViewControllerDelegate
    func menuViewController(controller: MenuViewController, didClickButtonWithType type: MenuButtonType) {
        switch type {
        case .now:
            break
        case .all:
            presentNowTableViewController()
        case .search:
            presentSearchTableViewController()
        case .favorite:
            presentFavoritesTableViewController()
        
        }
    }
    
    func presentNowTableViewController() {
        self.performSegueWithIdentifier("AllMoviesSegue", sender: self)
    }
    
    func presentFavoritesTableViewController() {
        self.performSegueWithIdentifier("FavoritesSegue", sender: self)
    }
    
    func presentSearchTableViewController() {
        self.performSegueWithIdentifier("SearchSegue", sender: self)
    }
    
}
