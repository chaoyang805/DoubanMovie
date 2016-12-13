//
//  DetailMovieBindingExtensions.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 2016/12/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SDWebImage


extension Reactive where Base: UIBarButtonItem {
    
    var buttonState: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base) { barButton, isBeingLiked in
            if isBeingLiked {
                barButton.image = UIImage(named: "icon-liked")!
            } else {
                barButton.image = UIImage(named: "icon-like-normal")!
            }
        }
    }
}

extension Reactive where Base: UIImageView {
    var imageUrl: UIBindingObserver<Base, URL?> {
        return UIBindingObserver(UIElement: base) { (imageView, imageUrl: URL?) in
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
