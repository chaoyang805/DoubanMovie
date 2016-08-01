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
    
    var movie: MovieSubject?
    func configureCell(withMovie movie: MovieSubject) {
        self.movie = movie
        posterImageView.image = #imageLiteral(resourceName: "now-you-see-me")
        titleLabel.text = "忍者神龟2:破影而出"
        movieSummaryLabel.text = "城市在恢复平静后，大反派重新召集旧部卷土重来，并勾结外星恶势力朗格试图称霸地球，忍者神龟莱昂纳多（皮特·普劳泽克 Pete Ploszek 饰）、拉斐尔（阿兰·里奇森 Alan Ritchson 饰）…"
        collectDateLabel.text = "07-01 20:30"
    }
}
