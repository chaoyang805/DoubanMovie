//
//  MenuViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func inTheaterButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .now)
        }
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .search)
        }
    }
    
    @IBAction func allMovieButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .all)
        }
    }
    
    @IBAction func favoritesButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .favorite)
        }
    }
    
    // MARK: - Segues
    
    override func unwindSegue(sender: UIStoryboardSegue) {
        super.unwindSegue(sender)
    }
}
