//
//  NowTableViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class NowMoviesTableViewController: ClearTransitionTableViewController {
    
    private var resultsSet: DoubanResultsSet?
    
    /// 初始的偏移量，永远是0
    private var initialFetchOffset = 0
    
    /// 请求数据的偏移量根据当前已有数据的数量
    private var fetchOffset: Int {
        return movieCount
    }

    /// 每次请求数据的数量根据当前展示的数据量和总数据量决定
    private var fetchResultCount: Int {
        return totalMovieCount - movieCount > 20 ? 20 : totalMovieCount - movieCount
    }
    
    /// 重新刷新时请求的条目数量
    private let refetchResultCount = 20
    
    private var totalMovieCount: Int {
        return resultsSet?.total ?? 0
    }
    private var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    private lazy var doubanService: DoubanService = {
        
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
        self.refreshControl?.addTarget(self, action: #selector(NowMoviesTableViewController.onPullToRefresh), forControlEvents: .ValueChanged)
        reloadData(false)
    }

    private func reloadData(force: Bool) {
        doubanService.getInTheaterMovies(at: initialFetchOffset, resultCount: refetchResultCount, forceReload: force) { [weak self](responseJSON, error) in
            
            guard let `self` = self else { return }
            self.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
            self.navigationItem.title = self.resultsSet?.title ?? "全部热映"
            self.tableView.reloadData()
            
            if self.refreshControl!.refreshing {
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = self.pullToRefreshTitle
            }
        }
    }
    
    @objc private func onPullToRefresh() {
        self.refreshControl?.attributedTitle = refreshingTitle
        reloadData(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NowTableToDetail" {
            guard let toVC = segue.destinationViewController as? MovieDetailViewController, cell = sender as? DetailMovieCell else { return }
            guard let selectedRow = tableView.indexPathForCell(cell)?.row else { return }
            
            toVC.detailMovie = resultsSet?.subjects[selectedRow]
        }
    }
    
    // MARK: UITableViewControllerDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieCount
    }
    
    let DetailCellIdentifier = "DetailMovieCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailCellIdentifier, forIndexPath: indexPath)

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let detailCell = cell as? DetailMovieCell, subjects = self.resultsSet?.subjects where subjects.count > 0 else { return }
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
    
    override func scrollViewDidScroll(scrollView: UIScrollView){
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
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
                } else {
                    self.loadMoreFooter.nomoreData()
                    delay(1) { [weak self] in
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
    
    private func loadMore(completion: (count: Int) -> Void) -> Void {
        doubanService.getInTheaterMovies(at: fetchOffset, resultCount: fetchResultCount, forceReload: true) { [weak self](responseJSON, error) in
            guard let `self` = self else { return }
            
            if let resultsSet = Mapper<DoubanResultsSet>().map(responseJSON) where resultsSet.subjects.count > 0 {
                
                completion(count: resultsSet.subjects.count)
                self.resultsSet?.subjects.appendContentsOf(resultsSet.subjects)
                self.tableView.reloadData()
            } else {
                completion(count: 0)
            }
        }

    }
}
