//
//  AvatarView.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/25.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var avatarImageButton: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!

    private(set) var celebrity: DoubanCelebrity
    convenience init(celebrity: DoubanCelebrity) {
        self.init(frame: CGRect(x: 0, y: 0, width: 60, height: 90), celebrity: celebrity)
    }
    
    
    init(frame: CGRect, celebrity: DoubanCelebrity) {
        self.celebrity = celebrity
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AvatarView", owner: self, options: nil)
        self.addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        celebrity = DoubanCelebrity()
        super.init(coder: aDecoder)
        self.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageButton.layer.cornerRadius = 30
        avatarImageButton.sd_setImage(with: URL(string: celebrity.avatars!.mediumImageURL), for: .normal)
        avatarImageButton.imageView?.contentMode = .scaleAspectFill
        artistNameLabel.text = celebrity.name
        
    }
}

struct Avatar {
    var name: String
    var avatarURL: String
}
