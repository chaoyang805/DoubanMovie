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

class RatingStar: UIView {
    
    private var ratingbarStyle: RatingbarStyle
    
    private var gray: CGColor {
        return UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
    }
    
    private var yellow: CGColor {
        return UIColor(red: 1.0, green: 0.678, blue: 0.043, alpha: 1).cgColor
    }
    
    private var starWidth: CGFloat {
        return 23.78
    }
    
    private var starHeight: CGFloat {
        return 22.61
    }
    
    private var ratingLayer: CALayer?
    
    private var ratingLabel: UILabel!
    
    var ratingScore: CGFloat {
        get {
            return _ratingScore
        }
        set {
            if newValue > 10 {
                _ratingScore = 10
            } else {
                _ratingScore = newValue
            }
        }
    }
    
    private var _ratingScore: CGFloat = 10 {
        didSet {
            let widthRatio = _ratingScore / 10
            ratingLayer?.frame = CGRect(x: 0, y: 0, width: self.starWidth * widthRatio, height: 22.61)
            let score = String(format: "%.1f", _ratingScore)
            ratingLabel.text = score
        }
    }
    
    init(ratingScore: CGFloat, style: RatingbarStyle) {
        self.ratingbarStyle = style
        _ratingScore = ratingScore
        var frame: CGRect!
        switch style {
        case .small:
            frame = CGRect(x: 0, y: 0, width: 26, height: 44)
        case .large:
            frame = CGRect(x: 0, y: 0, width: 108, height: 16)
        }
        super.init(frame: frame)
        initViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    private func initViews() {
        ratingLayer = CALayer()
        let widthRatio = _ratingScore / 10
        ratingLayer?.frame = CGRect(x: 0, y: 0, width: self.starWidth * widthRatio, height: self.starHeight)
        ratingLayer?.backgroundColor = yellow
        
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 8.64))
        
        bezier.addLine(to: CGPoint(x: 5.94, y: 14.43))
        bezier.addLine(to: CGPoint(x: 4.54, y: 22.61))
        bezier.addLine(to: CGPoint(x: 11.89, y: 18.75))
        bezier.addLine(to: CGPoint(x: 19.24, y: 22.61))
        bezier.addLine(to: CGPoint(x: 17.83, y: 14.43))
        bezier.addLine(to: CGPoint(x: 23.78, y: 8.64))
        bezier.addLine(to: CGPoint(x: 15.56, y: 7.44))
        bezier.addLine(to: CGPoint(x: 11.89, y: 0))
        bezier.addLine(to: CGPoint(x: 8.21, y: 7.44))
        bezier.addLine(to: CGPoint(x: 0, y: 8.64))
        
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        
        let shapeCopy = CAShapeLayer()
        shapeCopy.fillColor = gray
        shapeCopy.path = bezier.cgPath

        self.layer.addSublayer(shapeCopy)
        
        if let layer = ratingLayer {
            self.layer.addSublayer(layer)
            layer.mask = shape
        }
        
        ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: 14))
        ratingLabel.text = String(format: "%.1f", _ratingScore)
        ratingLabel.textColor = UIColor(cgColor: yellow)
        ratingLabel.font = UIFont(name: "PingFang SC", size: 10)
        ratingLabel.textAlignment = .center
        ratingLabel.tag = 0x0001
        self.addSubview(ratingLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        ratingbarStyle = .small
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewWithTag(0x0001)?.frame.origin = CGPoint(x: 0, y: self.frame.height - 14)
    
    }

}

enum RatingbarStyle {
    case small
    case large
}
