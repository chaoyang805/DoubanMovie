//
//  Ratingbar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/23.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class Ratingbar: UIView {

    private var ratingbarStyle: RatingbarStyle
    
    private var grayColor: CGColor {
        return UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
    }
    
    private var yellowColor: CGColor {
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
            print("widthRatio: \(widthRatio)")
            ratingLayer?.frame = CGRect(x: 0, y: 0, width: self.starWidth * widthRatio, height: 22.61)
            ratingLabel.text = "\(_ratingScore)"
        }
    }
    
    
    
    init(ratingScore: CGFloat, style: RatingbarStyle) {
        self.ratingbarStyle = style
        _ratingScore = ratingScore
        var frame: CGRect!
        switch style {
        case .small:
//            frame = CGRect(x: 0, y: 0, width: 23.78, height: 22.61)
            frame = CGRect(x: 0, y: 0, width: 26, height: 44)
        case .large:
            frame = CGRect(x: 0, y: 0, width: 108, height: 16)
        }
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        ratingbarStyle = .small
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingLayer = CALayer()
        let widthRatio = _ratingScore / 10
        print("widthRatio: \(widthRatio)")
        ratingLayer?.frame = CGRect(x: 0, y: 0, width: self.starWidth * widthRatio, height: self.starHeight)
        ratingLayer?.backgroundColor = yellowColor
        
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
        shapeCopy.fillColor = grayColor
        shapeCopy.path = bezier.cgPath
        self.layer.addSublayer(shapeCopy)
        
        if let layer = ratingLayer {
            self.layer.addSublayer(layer)
            layer.mask = shape
        }
        
        ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: 14))
        ratingLabel.text = "\(_ratingScore)"
        ratingLabel.textColor = UIColor(cgColor: yellowColor)
        ratingLabel.font = UIFont(name: "PingFang SC", size: 10)
        ratingLabel.textAlignment = .center
        ratingLabel.tag = 0x0001
//        ratingLabel.frame.origin = CGPoint(x: 0, y: self.frame.height - 14)
        self.addSubview(ratingLabel)
        print("awakeFromNib Ratingbar")
        
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
