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
    
    override func configureCell(withMovie movie: MovieSubject) {
        super.configureCell(withMovie: movie)
        ratingInfo.ratingScore = 2.3
        directorsLabel.text = "朱浩伟"
        castsLabel.text = "伍迪·哈里森/戴夫·弗兰科/杰西·艾森伯格"
        yearLabel.text = "\(2016)"
    }
    
}
