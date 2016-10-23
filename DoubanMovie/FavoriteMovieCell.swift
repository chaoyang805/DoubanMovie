//
//  FavoriteMovieCell.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/20.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

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
