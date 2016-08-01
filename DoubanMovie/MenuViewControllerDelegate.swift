//
//  MenuViewControllerDelegate.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/26.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewController(controller: MenuViewController, didClickButtonWithType type: MenuButtonType)
}

enum MenuButtonType {
    case now
    case all
    case favorite
    case search
}
