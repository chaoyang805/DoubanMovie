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

class DetailMovieCell: BaseMovieCell {
    
    @IBOutlet weak var ratingInfo: RatingBar!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var castsLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var emptyRatingPlaceholderLabel: UILabel!
    
    override func configureCell(withMovie movie: DoubanMovie) {
        super.configureCell(withMovie: movie)
        
        ratingInfo.ratingScore = movie.rating?.average
        ratingInfo.isHidden = movie.rating?.average ?? 0 == 0
        emptyRatingPlaceholderLabel.isHidden = !(movie.rating?.average == 0)
        
        directorsLabel.text = movie.directorsDescription + " "
        castsLabel.text = movie.castsDescription + " "
        yearLabel.text = "\(movie.year)"
    }
    
}
