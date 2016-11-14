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
        
        scoreLabel!.frame = CGRect(origin: CGPoint(x: 82, y: 1), size: (scoreLabel!.text! as NSString)
            .size(attributes: [NSFontAttributeName: scoreLabel!.font]))
        addSubview(scoreLabel!)
    }
    
    private func changeRatingBarAppearence() {
        
        guard let ratingScore = ratingScore else {
            return
        }

        let appearenceArray =  [StarLayerAppearence](repeating: .full, count: 5)
        let yellowStarCount = Int(ratingScore / 2)
        
        for index in 0..<appearenceArray.count {
            if index < yellowStarCount {
                if stars[index].appearence != .full {
        
                    let frame = stars[index].frame
                    stars[index].removeFromSuperlayer()
                    let newStar = StarLayer(frame: frame, appearence: .full)
                    stars[index] = newStar
                    self.layer.addSublayer(newStar)
                } else {
                    continue
                }
                
            } else if index == yellowStarCount {
                
                let frame = stars[index].frame
                stars[index].removeFromSuperlayer()
                let newStar = StarLayer(frame: frame, appearence: middleStarType(ratingScore))
                
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

    /// 是否需要显示半星，ratingScore / 2 后的小数部分在(0.1, 0.6]之间的需要显示半星，[0, 0.1]显示空星，（0.6，1)显示满星
    private func hasHalfStar(ratingScore: Float) -> Bool {
        let a = Int(ratingScore * 100) / 2 % 100
        return 10 < a && a < 60
        
    }

    private func middleStarType(_ ratingScore: Float) -> StarLayerAppearence {
        let a = Int(ratingScore * 100) / 2 % 100
        if 10 < a && a < 60 {
            return .half
        } else if 0 <= a && a <= 10 {
            return .empty
        } else {
            return .full
        }
    }
}
