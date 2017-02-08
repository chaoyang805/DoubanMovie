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
import RealmSwift

class FavoritesTableViewController: ClearTransitionTableViewController {
    
    let FavoriteMovieCellIdentifier = "FavoriteMovieCell"
    
    fileprivate var favoriteMovies: Results<DoubanMovie>?
    
    fileprivate lazy var realmHelper: RealmHelper = {
        return RealmHelper()
    }()
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        observer = NotificationCenter.default.addObserver(forName: TableViewShouldReloadNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.title = "编辑"
        loadFavoriteMovies()
    }
    
    func loadFavoriteMovies() {
        realmHelper.getAllFavoriteMovies { [weak self](results) in
            guard let `self` = self else { return }
            self.favoriteMovies = results
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteToDetail" {
            guard let toVC = segue.destination as? MovieDetailViewController, let cell = sender as? FavoriteMovieCell, let selectedRow = tableView.indexPath(for: cell)?.row else { return }
            toVC.detailMovie = favoriteMovies?[selectedRow]
        }
    }
    
    // MARK: - Notification
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}
// MARK: - UITableView Datasource
extension FavoritesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteMovies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieCellIdentifier, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let movie = favoriteMovies?[indexPath.row], let cell = cell as? FavoriteMovieCell else { return }
        cell.configureCell(with: movie)
    }

}

// MARK: - Edit Cell
extension FavoritesTableViewController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.editButtonItem.title = "完成"
        } else {
            self.editButtonItem.title = "编辑"
        }
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmHelper.deleteMovieById(id: favoriteMovies![indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
