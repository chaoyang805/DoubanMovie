//
//  FavoritesTableViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesTableViewController: ClearTransitionTableViewController {
    
    let FavoriteMovieCellIdentifier = "FavoriteMovieCell"
    
    fileprivate var favoriteMovies: Results<DoubanMovie>?
    
    fileprivate lazy var realmHelper: RealmHelper = {
        return RealmHelper()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesTableViewController.onReceiveItemDeleteNotification(_:)), name: DBMMovieDidDeleteNotificationName, object: nil)
        
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
    
    @objc private func onReceiveItemDeleteNotification(_ notification: NSNotification) {
        guard let deleted = notification.userInfo?[DBMMovieDeleteNotificationKey] as? Bool else { return }
        if deleted {
            tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
