//
//  BaseTableViewCell.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

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
