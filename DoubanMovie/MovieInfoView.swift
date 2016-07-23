//
//  MovieInfoView.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/23.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MovieInfoView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingInfoView: Ratingbar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        if let view = Bundle.main().loadNibNamed("MovieInfoView", owner: self, options: nil).first as? UIView {
            self.backgroundColor = UIColor.clear()
            self.addSubview(view)
        }
    }
    
}
