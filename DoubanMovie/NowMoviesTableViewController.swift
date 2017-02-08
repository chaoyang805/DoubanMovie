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
import RxCocoa
import RxDataSources

let DetailCellIdentifier = "DetailMovieCell"

class NowMoviesTableViewController: ClearTransitionTableViewController {

    typealias MovieSectionModel = SectionModel<String, DoubanMovie>
    
    private let dataSource = RxTableViewSectionedReloadDataSource<MovieSectionModel>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            tableView.delegate = nil
            tableView.dataSource = nil
            tableView.tableFooterView = UIView()
        }
        
        do {
            dataSource.configureCell = { dataSource, tableView, indexPath, movie in
            
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailCellIdentifier, for: indexPath) as! DetailMovieCell
                cell.configureCell(with: movie)
                return cell
            }
            
        }
        
        do {
            tableView.rx
                .modelSelected(DoubanMovie.self)
                .map(detailVcForMovie)
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { (detailVC) in
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    },
                    onError: { (error) in
                        NSLog("error:\(error.localizedDescription)")
                    })
                .addDisposableTo(disposeBag)
        }
        
        do {
            let activityIndicator = ActivityIndicator()
            
            let refresh = self.refreshControl!.rx
                .controlEvent(.valueChanged)
                .startWith(())
                .shareReplay(1)
                .subscribeOn(MainScheduler.instance)
            
            refresh
                .mapWithIndex { $1 != 0 }
                .flatMap {
                    RxAlamofireService.shared
                        .loadMovies(at: 0, resultCount: 30, forceReload: $0)
                        .trackActivity(activityIndicator)
                }
                .map { (movies: [DoubanMovie]) -> [MovieSectionModel] in
                    return [MovieSectionModel(model: "", items: movies)]
                }
                .subscribeOn(MainScheduler.instance)
                .observeOn(MainScheduler.instance)
                .bindTo(tableView.rx.items(dataSource: dataSource))
                .addDisposableTo(disposeBag)
            
            activityIndicator
                .asObservable()
                .bindTo(refreshControl!.rx.refreshing)
                .addDisposableTo(disposeBag)
            
        }

    }
    
    private var detailVcForMovie : ((DoubanMovie) -> MovieDetailViewController) {
        
        return {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! MovieDetailViewController
            detailVC.detailMovie = $0
            return detailVC
        }
    }
}
