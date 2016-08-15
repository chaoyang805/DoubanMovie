//
//  FavoritesTableViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesTableViewController: UITableViewController {
    
    let FavoriteMovieCellIdentifier = "FavoriteMovieCell"
    
    private var favoriteMovies: Results<DoubanMovie>?
    
    private lazy var realmHelper: RealmHelper = {
        return RealmHelper()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FavoriteToDetail" {
            guard let toVC = segue.destinationViewController as? MovieDetailViewController, cell = sender as? FavoriteMovieCell, selectedRow = tableView.indexPathForCell(cell)?.row else {
                return
            }
            toVC.detailMovie = favoriteMovies?[selectedRow]
        }
    }
    
}
// MARK: - UITableView Datasource
extension FavoritesTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteMovies?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FavoriteMovieCellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let movie = favoriteMovies?[indexPath.row], cell = cell as? FavoriteMovieCell else { return }
        cell.configureCell(with: movie)
    }
}

// MARK: - Edit Cell
extension FavoritesTableViewController {
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.editButtonItem().title = "完成"
        } else {
            self.editButtonItem().title = "编辑"
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "取消收藏"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            realmHelper.deleteMovieById(favoriteMovies![indexPath.row].id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}

