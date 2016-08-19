//
//  DetailMovieCell.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/20.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

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
        emptyRatingPlaceholderLabel.hidden = !(movie.rating?.average == 0)
        directorsLabel.text = movie.directorsDescription + " "
        castsLabel.text = movie.castsDescription + " "
        yearLabel.text = "\(movie.year)"
    }
    
}
