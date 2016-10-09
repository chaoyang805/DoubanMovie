//
//  MovieDialogView.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/10/9.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MovieDialogView: UIView, LoadingEffect {

    var titleLabel: UILabel!
    var collectCountLabel: UILabel!
    var ratingInfoView: RatingStar!
    var posterImageButton: UIButton!
    var titleBarView: UIVisualEffectView!
    var loadingImageView: UIImageView!
    
    var movie: DoubanMovie? {
        didSet {
            guard let m = movie else { return }
            configureWithMovie(m)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
        initSubviews()
    }
    
    private func initSubviews() {
        // addBackgroundImageButton
        addBackgroundButton()
        
        // initTitlebar
        addTitlebar()
        
    }
    
    func configureWithMovie(movie: DoubanMovie) {
        titleLabel.text = movie.title
        collectCountLabel.text = String(format: "%d人看过", movie.collectCount)
        ratingInfoView.ratingScore = CGFloat(movie.rating?.average ?? 0)
        ratingInfoView.hidden = false
        posterImageButton.imageView?.contentMode = .ScaleAspectFill
        posterImageButton.contentHorizontalAlignment = .Fill
        posterImageButton.sd_setImageWithURL(NSURL(string: movie.images!.largeImageURL), forState: .Normal)
    }
    
    func addTarget(target: AnyObject?, action: Selector, for controlEvents: UIControlEvents) {
        if posterImageButton != nil {
            posterImageButton.addTarget(target, action: action, forControlEvents: controlEvents)
        }
    }
    
    private func addBackgroundButton() {
        posterImageButton = UIButton(type: .Custom)
        posterImageButton.frame = self.bounds
        addSubview(posterImageButton)
    }
    
    private func addTitlebar() {
        
        titleBarView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        titleBarView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
        
        // add title label
        titleLabel = UILabel(frame: CGRect(x: 20, y: 18, width: 190, height: 26))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "PingFang SC", size: 18)
        titleBarView.contentView.addSubview(titleLabel)
        
        // add collect count label
        collectCountLabel = UILabel(frame: CGRect(x: 20, y: 49, width: 150, height: 14))
        collectCountLabel.textColor = UIColor.whiteColor()
        collectCountLabel.font = UIFont(name: "PingFang SC", size: 10)
        titleBarView.contentView.addSubview(collectCountLabel)
        
        // add ratingbar
        ratingInfoView = RatingStar(ratingScore: 0, style: .small)
        let ratingBarX = self.bounds.width - ratingInfoView.bounds.width - 20
        let ratingBarY: CGFloat = 18
        ratingInfoView.frame.origin = CGPoint(x: ratingBarX, y: ratingBarY)
        titleBarView.contentView.addSubview(ratingInfoView)
        
        // add loading imageView default hidden
        loadingImageView = UIImageView(image: UIImage(named: "loading")!)
        loadingImageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        loadingImageView.center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
        loadingImageView.hidden = true
        self.addSubview(loadingImageView)
        
        self.addSubview(titleBarView)
    }
    
    private func setupAppearence() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
        
        self.backgroundColor = UIColor.lightGrayColor()
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // LoadingEffect
    private(set) var isLoading: Bool = false
    
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
        if isLoading {
            return
        }
        
        self.isLoading = true
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
        
        if !isLoading {
            return
        }
        
        self.loadingImageView.layer.removeAllAnimations()
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            
            guard let `self` = self else { return }
            self.loadingImageView.alpha = 0
            self.titleBarView.alpha = 1
            self.posterImageButton.alpha = 1
            
        }) {  [weak self](done) in
            
            guard let `self` = self else { return }
            self.loadingImageView.hidden = true
            self.isLoading = false
        }
    }
    
}