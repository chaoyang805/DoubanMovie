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
import SDWebImage

class NowMoviesTableViewController: ClearTransitionTableViewController {
    
    fileprivate var resultsSet: DoubanResultsSet?
    
    /// 初始的偏移量，永远是0
    fileprivate var initialFetchOffset = 0
    
    /// 请求数据的偏移量根据当前已有数据的数量
    fileprivate var fetchOffset: Int {
        return movieCount
    }

    /// 每次请求数据的数量根据当前展示的数据量和总数据量决定
    fileprivate var fetchResultCount: Int {
        return totalMovieCount - movieCount > 20 ? 20 : totalMovieCount - movieCount
    }
    
    /// 重新刷新时请求的条目数量
    fileprivate let refetchResultCount = 20
    
    fileprivate var totalMovieCount: Int {
        return resultsSet?.total ?? 0
    }
    fileprivate var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    fileprivate lazy var doubanService: DoubanService = {
        
        return DoubanService.sharedService
        
    }()
    
    private lazy var refreshingTitle = {
        return NSAttributedString(string: "正在刷新", attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Light", size: 14)!])
    }()
    
    private lazy var pullToRefreshTitle = {
        return NSAttributedString(string: "下拉刷新", attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Light", size: 14)!])
    }()
    
    private var movieCount: Int {
        return resultsSet?.subjects.count ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NowMoviesTableViewController.onPullToRefresh), for: .valueChanged)
        reloadData(false)
    }

    private func reloadData(_ force: Bool) {
        doubanService.getInTheaterMovies(at: initialFetchOffset, resultCount: refetchResultCount, forceReload: force) { [weak self](responseJSON, error) in
            
            guard let `self` = self else { return }
            self.resultsSet = Mapper<DoubanResultsSet>().map(JSON: responseJSON!)
            self.navigationItem.title = self.resultsSet?.title ?? "全部热映"
            self.tableView.reloadData()
            
            if self.refreshControl!.isRefreshing {
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = self.pullToRefreshTitle
            }
        }
    }
    
    @objc private func onPullToRefresh() {
        self.refreshControl?.attributedTitle = refreshingTitle
        reloadData(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NowTableToDetail" {
            guard let toVC = segue.destination as? MovieDetailViewController, let cell = sender as? DetailMovieCell else { return }
            guard let selectedRow = tableView.indexPath(for: cell)?.row else { return }
            
            toVC.detailMovie = resultsSet?.subjects[selectedRow]
        }

    }
    
    // MARK: UITableViewControllerDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieCount
    }

    let DetailCellIdentifier = "DetailMovieCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCellIdentifier, for: indexPath)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let detailCell = cell as? DetailMovieCell, let subjects = self.resultsSet?.subjects , subjects.count > 0 else { return }
        detailCell.configureCell(withMovie: subjects[indexPath.row])
    }
    
    lazy var loadMoreFooter: LoadMoreFooter = {
    
        let footer = LoadMoreFooter(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0))
        return footer
    }()
    
    let maxFooterHeight: CGFloat = 85
    
}
// MARK: - Pull up to load more
extension NowMoviesTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentSize.height < screenHeight - maxFooterHeight || loadMoreFooter.isLoadingMore {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let delta = offsetY - (scrollView.contentSize.height - screenHeight)
        
        if delta > 0 {
            if tableView.tableFooterView == nil {
                tableView.tableFooterView = loadMoreFooter
            }
            loadMoreFooter.changeHeight(delta)
        }
        
        if delta >= maxFooterHeight {
            loadMoreFooter.willLoadMore()
        } else if delta > maxFooterHeight - 10 {
            loadMoreFooter.cancelLoadMore()
        }
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentSize.height < screenHeight - maxFooterHeight || loadMoreFooter.isLoadingMore {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let delta = offsetY - (scrollView.contentSize.height - screenHeight)
        if delta >= maxFooterHeight {
            
            loadMoreFooter.beginLoadMore()
            scrollView.bounces = false
            
            self.tableView.contentSize.height += self.maxFooterHeight
    
            scrollView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - screenHeight), animated: true)
            
            loadMore { (count: Int) in
                
                scrollView.bounces = true
                if count > 0 {
                    self.loadMoreFooter.endLoadMore()
                    self.loadMoreFooter.changeHeight(0)
                } else {
                    self.loadMoreFooter.nomoreData()
                    delay(timeInterval: 1) { [weak self] in
                        
                        guard let `self` = self else { return }
                        self.tableView.contentSize.height -= self.maxFooterHeight
                        self.loadMoreFooter.endLoadMore()
                    }
                }
                
            }
            
        } else if delta > maxFooterHeight - 10 {
            self.loadMoreFooter.cancelLoadMore()
        }
        
    }
    
    private func loadMore(completion: @escaping (_ count: Int) -> Void) -> Void {
        doubanService.getInTheaterMovies(at: fetchOffset, resultCount: fetchResultCount, forceReload: true) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }
            
            if let resultsSet = Mapper<DoubanResultsSet>().map(JSON: responseJSON!) , resultsSet.subjects.count > 0 {
                
                completion(resultsSet.subjects.count)
                self.resultsSet?.subjects.append(contentsOf: resultsSet.subjects)
                self.tableView.reloadData()
            } else {
                completion(0)
                
            }
        }

    }
}
