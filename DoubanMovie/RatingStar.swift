//
//  Ratingbar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/23.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class RatingStar: UIView {
    
    private var ratingbarStyle: RatingbarStyle
    
    private var grayColor: CGColor {
        return UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).CGColor
    }
    
    private var yellowColor: CGColor {
        return UIColor(red: 1.0, green: 0.678, blue: 0.043, alpha: 1).CGColor
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
            
            ratingLabel.text = String(format: "%.1f", _ratingScore)
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
        ratingLayer?.backgroundColor = yellowColor
        
        let bezier = UIBezierPath()
        bezier.moveToPoint(CGPoint(x: 0, y: 8.64))
        bezier.addLineToPoint(CGPoint(x: 5.94, y: 14.43))
        bezier.addLineToPoint(CGPoint(x: 4.54, y: 22.61))
        bezier.addLineToPoint(CGPoint(x: 11.89, y: 18.75))
        bezier.addLineToPoint(CGPoint(x: 19.24, y: 22.61))
        bezier.addLineToPoint(CGPoint(x: 17.83, y: 14.43))
        bezier.addLineToPoint(CGPoint(x: 23.78, y: 8.64))
        bezier.addLineToPoint(CGPoint(x: 15.56, y: 7.44))
        bezier.addLineToPoint(CGPoint(x: 11.89, y: 0))
        bezier.addLineToPoint(CGPoint(x: 8.21, y: 7.44))
        bezier.addLineToPoint(CGPoint(x: 0, y: 8.64))
        
        let shape = CAShapeLayer()
        shape.path = bezier.CGPath
        
        let shapeCopy = CAShapeLayer()
        shapeCopy.fillColor = grayColor
        shapeCopy.path = bezier.CGPath
        self.layer.addSublayer(shapeCopy)
        
        if let layer = ratingLayer {
            self.layer.addSublayer(layer)
            layer.mask = shape
        }
        
        ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: 14))
        ratingLabel.text = String(format: "%.1f", _ratingScore)
        ratingLabel.textColor = UIColor(CGColor: yellowColor)
        ratingLabel.font = UIFont(name: "PingFang SC", size: 10)
        ratingLabel.textAlignment = .Center
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
