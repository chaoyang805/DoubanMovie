//
//  BaseTableViewCell.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class BaseMovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    
    var movieSubject: DoubanMovie?
    
    func configureCell(withMovie movie: DoubanMovie) {
        self.movieSubject = movie
        posterImageView.image = UIImage(named: "now-you-see-me")
        titleLabel.text = "惊天魔盗团2"
        movieGenresLabel.text = "动作/喜剧"
        let collectCount = 142192
        collectCountLabel.text = "\(collectCount)人看过"
    }
    
    
}
