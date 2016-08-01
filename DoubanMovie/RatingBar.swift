//
//  RatingBar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/27.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class RatingBar: UIView {
    /// 电影的评分信息
    var ratingScore: Float? {
        didSet {
            changeRatingBarAppearence()
        }
    }
    /// 保存五个star
    private var stars: [StarLayer] = []
    /// 显示电影评分的label
    private var scoreLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 添加五个默认的star
        addStars()
        // 添加label
        addScoreLabel()
    }
    
    private func addStars() {
        for index in 0...4 {
            let starLayer = StarLayer(frame: CGRect(x: 0, y: 0, width: 16, height: 16), appearence: .full)
            let width = starLayer.frame.width
            starLayer.frame.origin = CGPoint(x: CGFloat(index) * width, y: 0)
            stars.append(starLayer)
            self.layer.addSublayer(starLayer)
        }
    }
    
    private func addScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel!.text = "\(10.0)"
        scoreLabel!.font = UIFont(name: "PingFang SC", size: 12)
        scoreLabel!.textColor = UIColor(red: 1.0, green: 0.678, blue: 0.043, alpha: 1)
        
        scoreLabel!.frame = CGRect(origin: CGPoint(x: 82, y: 1), size: (scoreLabel!.text! as NSString).sizeWithAttributes([NSFontAttributeName: scoreLabel!.font]))
        addSubview(scoreLabel!)
    }
    
    private func changeRatingBarAppearence() {
        
        guard let ratingScore = ratingScore else {
            return
        }
        
        let appearenceArray =  [StarLayerAppearence](count: 5, repeatedValue: .full)
        let yellowStarCount = Int(ratingScore / 2)
        
        for index in 0..<appearenceArray.count {
            if index < yellowStarCount {
                continue
                
            } else if index == yellowStarCount {
                
                let frame = stars[index].frame
                stars[index].removeFromSuperlayer()
                let newStar = StarLayer(frame: frame, appearence: hasHalfStar(ratingScore) ? .half : .full)
                
                stars[index] = newStar
                self.layer.addSublayer(newStar)
                
            } else {
                
                let frame = stars[index].frame
                stars[index].removeFromSuperlayer()
                let newStar = StarLayer(frame: frame, appearence: .empty)
                stars[index] = newStar
                self.layer.addSublayer(newStar)
            }
            
        }
        
        scoreLabel?.text = "\(ratingScore)"
        
    }

    /// 是否需要显示半星，ratingScore / 2 后的小数部分在(0.1, 0.6]之间的需要显示半星
    private func hasHalfStar(ratingScore: Float) -> Bool {
        let a = Int(ratingScore * 100) / 2 % 100
        return 10 < a && a <= 60
        
    }
}
