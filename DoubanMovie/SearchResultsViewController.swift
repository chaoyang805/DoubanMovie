//
//  SearchResultsViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    lazy var searchController: UISearchController = {
        let _searchController = UISearchController(searchResultsController: nil)
        _searchController.searchResultsUpdater = self
        let scopeButtonTitles = ["全部", "电影", "电视剧", "其他"]
        _searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        _searchController.searchBar.delegate = self
        _searchController.dimsBackgroundDuringPresentation = false
        return _searchController
    }()
    let searchScopeButtonTitles = ["全部", "电影", "电视剧", "其他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    let firstSearchCellIdentifier = "FirstSearchResultCell"
    let secondSearchCellIdentifier = "SecondSearchResultCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: firstSearchCellIdentifier, for: indexPath)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: secondSearchCellIdentifier, for: indexPath)
        }
        
        if cell is DetailMovieCell {
            (cell as! DetailMovieCell).configureCell(withMovie: MovieSubject())
        }
        
        return cell!
    }
}
// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // DoubanService.search....
        
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
