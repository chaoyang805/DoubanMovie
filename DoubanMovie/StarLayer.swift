//
//  StarLayer.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/27.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class StarLayer: CALayer {
    
    var ratingLayer: CALayer?
    
    private(set) var appearence: StarLayerAppearence
    
    private var ratingLayerFullWidth: CGFloat = 0
    
    private var starWidth: CGFloat {
        return 23.78
    }
    
    private var starHeight: CGFloat {
        return 22.61
    }
    
    private var gray: CGColor {
        return UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
    }
    
    private var yellow: CGColor {
        return UIColor(red: 1.0, green: 0.678, blue: 0.043, alpha: 1).cgColor
    }
    
    init(frame: CGRect, appearence: StarLayerAppearence) {
        self.appearence = appearence
        super.init()
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        drawStar()
    }
    
    private func drawStar() {
    
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
        
        let scale = self.frame.width / starWidth
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        bezier.apply(scaleTransform)
        
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.frame = bezier.bounds
        
        ratingLayer = CALayer()
        if let layer = ratingLayer {
            switch appearence {
            case .full:
                layer.backgroundColor = yellow
                layer.frame = CGRect(x: 0, y: 0, width: shape.frame.width, height: shape.frame.height)
            case .half:
                
                let shapeCopy = CAShapeLayer()
                shapeCopy.fillColor = gray
                shapeCopy.path = bezier.cgPath
                shapeCopy.contentsScale = scale
                self.addSublayer(shapeCopy)
                
                layer.backgroundColor = yellow
                layer.frame = CGRect(x: 0, y: 0, width: shape.frame.width / 2, height: shape.frame.height)
            case .empty:
                layer.backgroundColor = gray
                layer.frame = CGRect(x: 0, y: 0, width: shape.frame.width, height: shape.frame.height)
            }
            layer.mask = shape
            self.addSublayer(layer)
            
        }

    }
}

enum StarLayerAppearence: String {
    case full
    case half
    case empty
}
