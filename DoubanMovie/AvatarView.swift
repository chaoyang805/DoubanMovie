/*
 * Copyright 2016 chaoyang805 zhangchaoyang805@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
