//
//  MovieInfoView.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/23.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MovieInfoView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    @IBOutlet weak var ratingInfoView: RatingStar!
    @IBOutlet weak var posterImageButton: UIButton!
    @IBOutlet weak var titleBarView: UIVisualEffectView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    var movie: DoubanMovie? {
        didSet {
            guard let m = movie  else { return }
            configure(withMovie: m)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init")
        setup()
    }
    func setup() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let view = NSBundle.mainBundle().loadNibNamed("MovieInfoView", owner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    func addTarget(target: AnyObject?, action: Selector, for controlEvents: UIControlEvents) {
        if posterImageButton != nil {
            posterImageButton.addTarget(target, action: action, forControlEvents: controlEvents)
        }
    }
    
    func configure(withMovie movie: DoubanMovie) {
        
        titleLabel.text = movie.title
        collectCountLabel.text = String(format: "%d人已看", movie.collectCount)
        ratingInfoView.ratingScore = CGFloat(movie.rating?.average ?? 0)
        ratingInfoView.hidden = false
        posterImageButton.imageView?.contentMode = .ScaleAspectFill
        posterImageButton.contentHorizontalAlignment = .Fill
        posterImageButton.sd_setImageWithURL(NSURL(string: movie.images!.largeImageURL), forState: .Normal)
    }
    
}
// MARK: - Loading
extension MovieInfoView {
    
    func rotateAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = 0.5
        animation.repeatCount = HUGE
        animation.cumulative = true
        
        let angle = -CGFloat(2 * M_PI / 5)
        let transform = CATransform3DMakeRotation(angle, 0, 0, -1)
        animation.byValue = NSValue(CATransform3D: transform)
        return animation
    }
    
    func beginLoading() {
        self.loadingImageView.alpha = 0
        self.loadingImageView.hidden = false
        UIView.animateWithDuration(0.2) { [weak self] in
            guard let `self` = self else { return }
            self.loadingImageView.alpha = 1
            self.titleBarView.alpha = 0
            self.posterImageButton.alpha = 0
            self.loadingImageView.layer.addAnimation(self.rotateAnimation(), forKey: "rotateAnimation")
        }
    }
    
    func endLoading() {
        self.loadingImageView.layer.removeAllAnimations()
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            
            guard let `self` = self else { return }
            self.loadingImageView.alpha = 0
            self.titleBarView.alpha = 1
            self.posterImageButton.alpha = 1
            }) {  [weak self](done) in
                guard let `self` = self else { return }
                self.loadingImageView.hidden = true
        }
    }
}

