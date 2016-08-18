//
//  LoadMoreFooter.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class LoadMoreFooter: UIView {
    
    private var loadingLabel: UILabel
    private var indicator: UIActivityIndicatorView
    private(set) var state: LoadMoreFooterState {
        get {
            return _state
        }
        set {
            if newValue == _state {
                return
            }
            _state = newValue
            switch _state {
            case .prepare:
                NSLog("prepare")
                self.title = "释放加载更多"
                self.indicator.startAnimating()
            case .began:
                NSLog("began")
                self.title = "正在加载"
            case .cancelled:
                NSLog("cancelled")
                self.title = "加载更多"
                self.indicator.stopAnimating()
            case .nomoredata:
                self.title = "已全部加载"
                self.indicator.stopAnimating()
            case .ended:
                NSLog("ended")
                self.title = "加载更多"
                self.indicator.stopAnimating()
            }
        }
    }
    
    private var _state: LoadMoreFooterState = .ended
    
    var title: String {
        get {
            return loadingLabel.text ?? ""
        }
        set {
            loadingLabel.text = newValue
        }
    }
    
    private(set) var isLoadingMore: Bool
    
    override init(frame: CGRect) {
        loadingLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 90, height: 20))
        loadingLabel.textAlignment = .Center
        loadingLabel.text = "加载更多"
        loadingLabel.font = UIFont(name: "Helvetica-Light", size: 14)
        loadingLabel.textColor = UIColor.blackColor()
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRect(x: 0, y: 45, width: 20, height: 20)
        indicator.hidesWhenStopped = false
        
        isLoadingMore = false
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        
        addSubview(loadingLabel)
        addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func willLoadMore() {
        self.state = .prepare
    }
    
    func beginLoadMore() {
        self.state = .began
    }
    
    func cancelLoadMore() {
        self.state = .cancelled
    }
    
    func endLoadMore() {
        self.state = .ended
    }
    
    func nomoreData() {
        self.state = .nomoredata
    }
    
    func changeHeight(height: CGFloat) {
        let temp = self.frame
        self.frame = CGRect(x: temp.origin.x, y: temp.origin.y, width: temp.width, height: height)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        loadingLabel.center.x = self.center.x
        indicator.center.x = self.center.x
    }
}

enum LoadMoreFooterState: Int {
    case prepare
    case began
    case cancelled
    case ended
    case nomoredata
    
}
