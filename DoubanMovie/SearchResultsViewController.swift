//
//  SearchResultsViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchResultsViewController: ClearTransitionTableViewController {
    
    /// SearchResultController 控件
    private lazy var searchController: UISearchController = {
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
    
    private let searchScopeButtonTitles = ["全部", "电影", "电视剧", "其他"]
    
    /// 选中的过滤条件的index
    private var selectedScopeIndex: Int {
        return searchController.searchBar.selectedScopeButtonIndex
    }
    
    /// searbar上的搜索文字
    private var queryText: String {
        guard let query = searchController.searchBar.text else { return _lastQueryText }
        return  query.isEmpty ? _lastQueryText : query
    }
    
    private var _lastQueryText: String = ""
    
    /// 搜索返回的结果集
    private var searchResultsSet: DoubanResultsSet? {
        didSet {
            tableView.scrollEnabled = searchResultsSet?.subjects.count > 0
        }
    }
    
    /// 原始结果集
    private var searchResults: [DoubanMovie] {
        return searchResultsSet?.subjects ?? []
    }
    /// 过滤后的结果集
    private var filteredSearchResults = [DoubanMovie]()
    
    private let DetailCellHeight: CGFloat = 165
    private let BaseCellHeight: CGFloat = 120
    private let FirstSearchCellIdentifier = "FirstSearchResultCell"
    private let SecondSearchCellIdentifier = "SecondSearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
        tableView.scrollEnabled = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if searchResults.count > 0 {
            return
        }
        searchController.active = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let toVC = segue.destinationViewController as? MovieDetailViewController,
            cell = sender as? UITableViewCell,
            selectedRow = tableView.indexPathForCell(cell)?.row else {
                return
        }
        toVC.detailMovie = filteredSearchResults[selectedRow]
    }
    
}

// MARK: - UITableViewDataSource
extension SearchResultsViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredSearchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? FirstSearchCellIdentifier : SecondSearchCellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let movie = filteredSearchResults[indexPath.row]
        
        if indexPath.row == 0 {
            if let detailCell = cell as? DetailMovieCell {
                detailCell.configureCell(withMovie: movie)
            }
        } else {
            if let baseCell = cell as? BaseMovieCell {
                baseCell.configureCell(withMovie: movie)
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SearchResultsViewController {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? DetailCellHeight : BaseCellHeight
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
        filterResults(withQuery: queryText, atScopeIndex: selectedScope)
    }
    
    
    /**
     过滤搜索结果
     
     - parameter query: 过滤的关键字
     - parameter index: 当前选中的scopeButtonIndex
     */
    func filterResults(withQuery query: String, atScopeIndex index: Int) {
        guard let subjects = searchResultsSet?.subjects where subjects.count > 0 else { return }
        
        var subtype = ""
        switch index {
        case 1:
            subtype = "movie"
        case 2:
            subtype = "tv"
        default:
            break
        }
        
        let filteredResults = subjects.filter{
            return $0.title.lowercaseString.containsString(query.lowercaseString) ||
                $0.originalTitle.lowercaseString.containsString(query.lowercaseString)
        }
        if subtype.isEmpty {
            self.filteredSearchResults = filteredResults
        } else {
            self.filteredSearchResults = filteredResults.filter({ (movie) -> Bool in
                return movie.subType.lowercaseString.containsString(subtype)
            })
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // DoubanService.search....
        guard let queryString = searchBar.text else { return }
        _lastQueryText = queryString
        
        searchMovie(with: queryString)
        
    }
    
    func searchMovie(with query: String) {
        
        DoubanService.sharedService.searchMovies(withQuery: query, at: 0, resultCount: 20) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }
            
            if let error = error {
                
                NSLog("error!\(error)")
                Snackbar.make("搜索失败", duration: .Short).show()
                
            }
            
            if let results = Mapper<DoubanResultsSet>().map(responseJSON) where results.subjects.count > 0 {
                
                self.searchResultsSet = results
                self.updateSearchResultsForSearchController(self.searchController)
                
            } else {
                
                Snackbar.make("没有搜索到结果", duration: .Short).show()
                
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterResults(withQuery: queryText, atScopeIndex: selectedScopeIndex)
    }
}
