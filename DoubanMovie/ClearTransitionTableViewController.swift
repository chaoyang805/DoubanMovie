//
//  BaseViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ClearTransitionTableViewController: UITableViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 将navigationController 的 delegate 设置为 nil，重置之前 HomeViewController 的设置
        self.navigationController?.delegate = nil
    }
    
}
