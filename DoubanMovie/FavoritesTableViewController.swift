//
//  FavoritesTableViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewControllerDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 15
    }
    
    
    let FavoriteMovieCellIdentifier = "FavoriteMovieCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FavoriteMovieCellIdentifier, forIndexPath: indexPath)
        if let favoriteCell  = cell as? FavoriteMovieCell {
            favoriteCell.configureCell(withMovie: DoubanMovie())
        }
        
        return cell
    }
}
