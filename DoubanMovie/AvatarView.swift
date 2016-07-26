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

    var avatar: Avatar
    
    convenience init(avatar: Avatar) {
        self.init(frame: CGRect(x: 0, y: 0, width: 60, height: 90), avatar: avatar)
    }
    
    
    init(frame: CGRect, avatar: Avatar) {
        self.avatar = avatar
        super.init(frame: frame)
        Bundle.main().loadNibNamed("AvatarView", owner: self, options: nil)
        self.addSubview(containerView)
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        avatar = Avatar(name: "artist", avatarURL: "")
        super.init(coder: aDecoder)
        self.addSubview(containerView)
//        setup()
    }
    
    func setup() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGray().cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageButton.layer.cornerRadius = 30
        avatarImageButton.setImage(#imageLiteral(resourceName: "director"), for: [])
        artistNameLabel.text = avatar.name
        
    }
}

struct Avatar {
    var name: String
    var avatarURL: String
}
