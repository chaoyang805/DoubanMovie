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
    fileprivate lazy var searchController: UISearchController = {
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
    fileprivate var selectedScopeIndex: Int {
        return searchController.searchBar.selectedScopeButtonIndex
    }
    
    /// searbar上的搜索文字
    fileprivate var queryText: String {
        guard let query = searchController.searchBar.text else { return _lastQueryText }
        return  query.isEmpty ? _lastQueryText : query
    }
    
    fileprivate var _lastQueryText: String = ""
    
    /// 搜索返回的结果集
    fileprivate var searchResultsSet: DoubanResultsSet? {
        didSet {
            tableView.isScrollEnabled = (searchResultsSet?.subjects.count)! > 0
        }
    }
    
    /// 原始结果集
    fileprivate var searchResults: [DoubanMovie] {
        return searchResultsSet?.subjects ?? []
    }
    /// 过滤后的结果集
    fileprivate var filteredSearchResults = [DoubanMovie]()
    
    fileprivate let DetailCellHeight: CGFloat = 165
    fileprivate let BaseCellHeight: CGFloat = 120
    fileprivate let FirstSearchCellIdentifier = "FirstSearchResultCell"
    fileprivate let SecondSearchCellIdentifier = "SecondSearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
        tableView.isScrollEnabled = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchResults.count > 0 {
            return
        }
        searchController.isActive = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let toVC = segue.destination as? MovieDetailViewController,
            let cell = sender as? UITableViewCell,
            let selectedRow = tableView.indexPath(for: cell)?.row else {
                return
        }
        toVC.detailMovie = filteredSearchResults[selectedRow]
    }
    
}

// MARK: - UITableViewDataSource
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSearchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? FirstSearchCellIdentifier : SecondSearchCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? DetailCellHeight : BaseCellHeight
    }
}

extension SearchResultsViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterResults(withQuery: queryText, atScopeIndex: selectedScope)
    }
    
    /**
     过滤搜索结果
     
     - parameter query: 过滤的关键字
     - parameter index: 当前选中的scopeButtonIndex
     */
    func filterResults(withQuery query: String, atScopeIndex index: Int) {
        guard let subjects = searchResultsSet?.subjects , subjects.count > 0 else { return }
        
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
            return $0.title.lowercased().contains(query.lowercased()) ||
            $0.originalTitle.lowercased().contains(query.lowercased())
        }
        if subtype.isEmpty {
            self.filteredSearchResults = filteredResults
        } else {
            self.filteredSearchResults = filteredResults.filter({ (movie) -> Bool in
                return movie.subType.lowercased().contains(subtype)
            })
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
                Snackbar.make(text: "搜索失败", duration: .Short).show()
                
            }
            
            if let results = Mapper<DoubanResultsSet>().map(JSON: responseJSON!) , results.subjects.count > 0 {
                
                self.searchResultsSet = results
                self.updateSearchResults(for: self.searchController)
                
            } else {
                
                Snackbar.make(text: "没有搜索到结果", duration: .Short).show()
                
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterResults(withQuery: queryText, atScopeIndex: selectedScopeIndex)
    }
}
