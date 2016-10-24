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
import SDWebImage

class BaseMovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    
    var movie: DoubanMovie?
    
    func configureCell(withMovie movie: DoubanMovie) {
        self.movie = movie
        posterImageView.sd_setImage(with: URL(string: movie.images!.largeImageURL))
        titleLabel.text = movie.title
        movieGenresLabel.text = movie.genres
        collectCountLabel.text = String(format: "%d人看过", movie.collectCount)

    }
    
}
