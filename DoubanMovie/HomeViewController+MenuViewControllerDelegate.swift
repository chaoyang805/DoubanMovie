/*
 * Copyright 2016 chaoyang805 zhangchaoyang805@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

extension HomeViewController: MenuViewControllerDelegate {
    
    // MARK - MenuViewControllerDelegate
    func menuViewController(_ controller: MenuViewController, didClickButtonWithType type: MenuButtonType) {
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
    
    private func presentNowTableViewController() {
        self.performSegue(withIdentifier: "AllMoviesSegue", sender: self)
    }
    
    private func presentFavoritesTableViewController() {
        self.performSegue(withIdentifier: "FavoritesSegue", sender: self)
    }
    
    private func presentSearchTableViewController() {
        self.performSegue(withIdentifier: "SearchSegue", sender: self)
    }
    
}
