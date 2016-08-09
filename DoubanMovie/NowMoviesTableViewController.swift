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

class NowMoviesTableViewController: UITableViewController {
    
    var resultsSet: DoubanResultsSet?
    var fetchOffset = 0
    var fetchResultCount = 20
    
    lazy var doubanService: DoubanService = {
        
        return DoubanService.sharedService
        
    }()
    
    var movieCount: Int {
        return resultsSet == nil ? 0 : resultsSet!.subjects.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(NowMoviesTableViewController.fetchData), forControlEvents: .ValueChanged)
        fetchData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchData() {
        doubanService.getInTheaterMovies(at: fetchOffset, resultCount: fetchResultCount) { [weak self](responseJSON, error) in
            self?.resultsSet = Mapper<DoubanResultsSet>().map(responseJSON)
            self?.tableView.reloadData()
            
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepare for segue:\(segue.identifier)")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected indexpaht:\(indexPath.row)")
    }
    
}
