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
import RxSwift
import RxCocoa

extension Reactive where Base: LoadingEffect {
    
    var refreshing: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base) { (loadingView, refreshing) in
            if refreshing {
                loadingView.beginLoading()
            } else {
                loadingView.endLoading()
            }
        }
    }
}

extension Reactive where Base: MovieDialogView {
    var tap: ControlEvent<Void> {
        return base.posterImageButton.rx.tap
    }
}

class MovieDialogView: UIView, LoadingEffect {

    var titleLabel: UILabel!
    var collectCountLabel: UILabel!
    var ratingInfoView: RatingStar!
    var posterImageButton: UIButton!
    var titleBarView: UIVisualEffectView!
    var loadingImageView: UIImageView!
    
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
    
    func configureWith(_ movie: DoubanMovie) {
        titleLabel.text = movie.title
        collectCountLabel.text = String(format: "%d人看过", movie.collectCount)
        
        ratingInfoView.ratingScore = CGFloat(movie.rating?.average ?? 0)
        ratingInfoView.isHidden = false
        posterImageButton.imageView?.contentMode = .scaleAspectFill
        posterImageButton.contentHorizontalAlignment = .fill
        posterImageButton.sd_setImage(with: URL(string: movie.images!.largeImageURL), for: .normal)
    }
    
    func addTarget(target: AnyObject?, action: Selector, for controlEvents: UIControlEvents) {
        if posterImageButton != nil {
            posterImageButton.addTarget(target, action: action, for: controlEvents)
        }
    }
    
    private func addBackgroundButton() {
        posterImageButton = UIButton(type: .custom)
        posterImageButton.frame = self.bounds
        addSubview(posterImageButton)
    }
    
    private func addTitlebar() {
        
        titleBarView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        titleBarView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
        
        // add title label
        titleLabel = UILabel(frame: CGRect(x: 20, y: 18, width: 190, height: 26))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "PingFang SC", size: 18)
        titleBarView.contentView.addSubview(titleLabel)
        
        // add collect count label
        collectCountLabel = UILabel(frame: CGRect(x: 20, y: 49, width: 150, height: 14))
        collectCountLabel.textColor = UIColor.white
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
        loadingImageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        loadingImageView.isHidden = true
        self.addSubview(loadingImageView)
        
        self.addSubview(titleBarView)
    }
    
    private func setupAppearence() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.backgroundColor = UIColor.lightGray
        self.clipsToBounds = true
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
        animation.isCumulative = true
        
        let angle = -CGFloat(2 * M_PI / 5)
        let transform = CATransform3DMakeRotation(angle, 0, 0, -1)
        animation.byValue = NSValue(caTransform3D: transform)
        return animation
    }
    
    func beginLoading() {
        if isLoading {
            return
        }
        
        self.isLoading = true
        self.loadingImageView.alpha = 0
        self.loadingImageView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let `self` = self else { return }
            self.loadingImageView.alpha = 1
            self.titleBarView.alpha = 0
            self.posterImageButton.alpha = 0
            self.loadingImageView.layer.add(self.rotateAnimation(), forKey: "rotateAnimation")
        }
    }
    
    func endLoading() {
        
        if !isLoading {
            return
        }
        
        self.loadingImageView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            guard let `self` = self else { return }
            self.loadingImageView.alpha = 0
            self.titleBarView.alpha = 1
            self.posterImageButton.alpha = 1
            
        }) {  [weak self](done) in
            
            guard let `self` = self else { return }
            self.loadingImageView.isHidden = true
            self.isLoading = false
        }
    }
    
}
