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
    @IBOutlet weak var ratingInfoView: RatingStar!
    @IBOutlet weak var posterImageButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init")
        setup()
    }
    func setup() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGray().cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
        if let view = Bundle.main().loadNibNamed("MovieInfoView", owner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    func addTarget(target: AnyObject?, action: Selector, for controlEvents: UIControlEvents) {
        if posterImageButton != nil {
            posterImageButton.addTarget(target, action: action, for: controlEvents)
        } else {
            print("can't find button.")
        }
    }
    
}
