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
    
    private var grayColor: CGColor {
        return UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
    }
    
    private var yellowColor: CGColor {
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
        
        let scale = self.frame.width / starWidth
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0 * scale, y: 8.64 * scale))
        bezier.addLine(to: CGPoint(x: 5.94 * scale, y: 14.43 * scale))
        bezier.addLine(to: CGPoint(x: 4.54 * scale, y: 22.61 * scale))
        bezier.addLine(to: CGPoint(x: 11.89 * scale, y: 18.75 * scale))
        bezier.addLine(to: CGPoint(x: 19.24 * scale, y: 22.61 * scale))
        bezier.addLine(to: CGPoint(x: 17.83 * scale, y: 14.43 * scale))
        bezier.addLine(to: CGPoint(x: 23.78 * scale, y: 8.64 * scale))
        bezier.addLine(to: CGPoint(x: 15.56 * scale, y: 7.44 * scale))
        bezier.addLine(to: CGPoint(x: 11.89 * scale, y: 0 * scale))
        bezier.addLine(to: CGPoint(x: 8.21 * scale, y: 7.44 * scale))
        bezier.addLine(to: CGPoint(x: 0 * scale, y: 8.64 * scale))
        
        let shape = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.frame = bezier.bounds
        
        ratingLayer = CALayer()
        if let layer = ratingLayer {
            switch appearence {
            case .full:
                layer.backgroundColor = yellowColor
                layer.frame = CGRect(x: 0, y: 0, width: shape.frame.width, height: shape.frame.height)
            case .half:
                
                let shapeCopy = CAShapeLayer()
                shapeCopy.fillColor = grayColor
                shapeCopy.path = bezier.cgPath
                shapeCopy.contentsScale = scale
                self.addSublayer(shapeCopy)
                
                layer.backgroundColor = yellowColor
                layer.frame = CGRect(x: 0, y: 0, width: shape.frame.width / 2, height: shape.frame.height)
            case .empty:
                layer.backgroundColor = grayColor
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
