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
    
    @IBAction func inTheaterButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .now)
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .search)
        }
    }
    
    @IBAction func allMovieButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .all)
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false) {
            self.delegate?.menuViewController(self, didClickButtonWithType: .favorite)
        }
    }
    
    // MARK: - Segues
    
    override func unwindSegue(_ sender: UIStoryboardSegue) {
        super.unwindSegue(sender)
    }
}
