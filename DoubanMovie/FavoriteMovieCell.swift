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

class FavoriteMovieCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    @IBOutlet weak var collectDateLabel: UILabel!
    
    func configureCell(with movie: DoubanMovie) {
        posterImageView.sd_setImage(with: URL(string: movie.images!.mediumImageURL))
        titleLabel.text = movie.title
        movieSummaryLabel.text = movie.summary
        collectDateLabel.text = formatDate(movie.collectDate)
        
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
