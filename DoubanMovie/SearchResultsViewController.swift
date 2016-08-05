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
        _searchController.delegate = self
        
        let scopeButtonTitles = ["全部", "电影", "电视剧", "其他"]
        _searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        
        _searchController.searchBar.delegate = self
        _searchController.searchBar.barTintColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
        _searchController.searchBar.tintColor = UIColor(red: 0.0823, green: 0.584, blue: 0.533, alpha: 1)
        _searchController.searchBar.placeholder = "输入搜索内容"
        _searchController.dimsBackgroundDuringPresentation = false
        return _searchController
    }()
    
    var datas: [String] = [] {
        didSet {
            tableView.scrollEnabled = datas.count != 0
        }
    }
    let searchScopeButtonTitles = ["全部", "电影", "电视剧", "其他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.scrollEnabled = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchController.active = true
        
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    let firstSearchCellIdentifier = "FirstSearchResultCell"
    let secondSearchCellIdentifier = "SecondSearchResultCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(firstSearchCellIdentifier, forIndexPath: indexPath)
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(secondSearchCellIdentifier, forIndexPath: indexPath)
        }
        
        if cell is DetailMovieCell {
            (cell as! DetailMovieCell).configureCell(withMovie: DoubanMovie())
        }
        if cell is BaseMovieCell {
            (cell as! BaseMovieCell).configureCell(withMovie: DoubanMovie())
        }
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 165
        } else {
            return 120
        }
    }
}

extension SearchResultsViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // DoubanService.search....
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.datas.append("new")
            self.datas.append("new2")
            NSLog("reload")
            self.tableView.reloadData()
        }
    }
    
    
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        NSLog("updateSearchResultsForSearchController")
    }
}
