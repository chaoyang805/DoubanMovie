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
import ObjectMapper
import RxSwift

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
    
    fileprivate var disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var afService: RxAlamofireService = {
        return RxAlamofireService.shared
    }()
    
    fileprivate var resultsMovie: [DoubanMovie] = [] {
        didSet {
            tableView.isScrollEnabled = resultsMovie.count > 0
        }
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

        if resultsMovie.count > 0 {
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
                detailCell.configureCell(with: movie)
            }
            
        } else {
            
            if let baseCell = cell as? BaseMovieCell {
                baseCell.configureCell(with: movie)
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
        
        var subtype = ""
        switch index {
        case 1:
            subtype = "movie"
        case 2:
            subtype = "tv"
        default:
            break
        }
        
        let filteredResults = resultsMovie.filter{
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
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // DoubanService.search....
        guard let query = searchBar.text else { return }
        _lastQueryText = query
        
        afService
            .searchMovies(byQuery: query, from: 0, resultCount: 20, forceReload: true)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: onLoadSearchResult,
                onError: onLoadSearchError,
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(disposeBag)
        
    }
    
    private var onLoadSearchResult: ([DoubanMovie]) -> Void {
        return {
            self.resultsMovie = $0
            self.updateSearchResults(for: self.searchController)
        }
    }
    
    private var onLoadSearchError: (Error) -> Void {
        return {
            NSLog("search failed:\($0.localizedDescription)")
            Snackbar.make(text: "搜索失败", duration: .Short).show()
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterResults(withQuery: queryText, atScopeIndex: selectedScopeIndex)
    }
}
