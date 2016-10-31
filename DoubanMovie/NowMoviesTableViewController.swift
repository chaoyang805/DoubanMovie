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
import RxSwift

class NowMoviesTableViewController: ClearTransitionTableViewController {
    
    fileprivate var movies: [DoubanMovie] = []
    
    /// 请求数据的偏移量根据当前已有数据的数量
    fileprivate var fetchOffset: Int {
        return movies.count
    }
    
    /// 每次请求数据的数量为20
    fileprivate var fetchResultCount: Int {
        return 20
    }
    
    /// 重新刷新时请求的条目数量
    fileprivate let refetchResultCount = 20

    fileprivate var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    fileprivate lazy var afService: RxAlamofireService = {
        return RxAlamofireService.shared
    }()
    
    fileprivate var disposeBag = DisposeBag()
    
    private lazy var refreshingTitle = {
        return NSAttributedString(string: "正在刷新", attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Light", size: 14)!])
    }()
    
    private lazy var pullToRefreshTitle = {
        return NSAttributedString(string: "下拉刷新", attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Light", size: 14)!])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NowMoviesTableViewController.onPullToRefresh), for: .valueChanged)
        reloadData(false)
    }

    private func reloadData(_ force: Bool) {
        
        afService
            .loadMovies(at: 0, resultCount: fetchResultCount, forceReload: force)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: onLoaded,
                onError: nil,
                onCompleted: endLoading,
                onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    private lazy var onLoaded: ([DoubanMovie]) -> Void = {
        
        return {
        
            self.navigationItem.title = "全部上映中"
            self.movies = $0
            self.tableView.reloadData()
            
        }
        
    }()
    
    private lazy var endLoading: () -> Void = {
    
        return {
            
            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = self.pullToRefreshTitle
            
        }
    }()
    
    @objc private func onPullToRefresh() {
        self.refreshControl?.attributedTitle = refreshingTitle
        reloadData(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NowTableToDetail" {
            guard let toVC = segue.destination as? MovieDetailViewController, let cell = sender as? DetailMovieCell else { return }
            guard let selectedRow = tableView.indexPath(for: cell)?.row else { return }
            
            toVC.detailMovie = movies[selectedRow]
        }

    }
    
    // MARK: UITableViewControllerDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    let DetailCellIdentifier = "DetailMovieCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCellIdentifier, for: indexPath)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let detailCell = cell as? DetailMovieCell else { return }
        detailCell.configureCell(with: movies[indexPath.row])
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
                
//                scrollView.bounces = true
                if count > 0 {
                    self.loadMoreFooter.endLoadMore()
                    self.loadMoreFooter.changeHeight(0)
                    scrollView.bounces = true
                } else {
                    self.loadMoreFooter.nomoreData()
                    delay(timeInterval: 1) { [weak self] in
                        
                        guard let `self` = self else { return }
                        scrollView.bounces = true
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
        
        let onLoaded: ([DoubanMovie]) -> Void = {
            NSLog("onLoaded \($0.count)")
            if $0.count > 0 {
                completion($0.count)
                self.movies.append(contentsOf: $0)
                self.tableView.reloadData()
            } else {
                completion(0)
            }
        }
        
        afService
            .loadMovies(at: fetchOffset, resultCount: fetchResultCount, forceReload: true)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext:onLoaded,
                onError: nil,
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(disposeBag)

    }
}
