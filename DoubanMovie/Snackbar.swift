//
//  Snackbar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class Snackbar: NSObject {
    
    private(set) var view = SnackbarView()
    private(set) var duration: NSTimeInterval = 3
    private var showing: Bool = false
    class func make(text: String, duration: NSTimeInterval) -> Snackbar {
        
        let snackbar = Snackbar()
        snackbar.setSnackbarText(text)
        snackbar.duration = duration
        return snackbar
    }
    
    func setSnackbarText(text: String) {
        view.messageView.text = text
    }
    
    func setAction(action: ((sender: AnyObject) -> Void)) -> Snackbar {
        let block = { (sender: AnyObject) in
            self.hideSnackbar()
            action(sender: sender)
        }
        view.setAction(block)
        return self
    }
    
    func show() {
        guard !showing ,let window = UIApplication.sharedApplication().keyWindow else { return }
        window.addSubview(view)
        UIView.animateWithDuration(0.4,
                                   animations: { [weak self] in
                                    
                                    guard let `self` = self else { return }
                                    self.view.frame.offsetInPlace(dx: 0, dy: -40)
                                    self.scheduleTimeout()
            
                                }) { (done) in
                                    
                                    self.showing = true
                                }
    }
    
    func scheduleTimeout() {
        
        dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(duration * 1000) * NSEC_PER_MSEC)),
        dispatch_get_main_queue()) {
            
            self.hideSnackbar()
            
        }
    }
    
    func hideSnackbar() {
        guard self.showing else { return }
        NSLog("hideSnackbar:\(showing)")
        UIView.animateWithDuration(0.4,
                                   animations: { [weak self] in
                                    
                                    guard let `self` = self else { return }
                                    self.view.frame.offsetInPlace(dx: 0, dy: 40)
                                    
                                }) { (done) in
                                    
                                    self.view.removeFromSuperview()
                                    self.showing = false
                                }
    }
}

class SnackbarView: UIView {
    
    
    var messageView: UILabel!
    
    var actionButton: UIButton!
    var actionBlock: ((sender: AnyObject) -> Void)?
    convenience init() {
        
        let x: CGFloat = 0
        let y = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        self.init(frame: CGRect(x: x, y: y, width: width, height: 40))
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        
        messageView = UILabel()
        messageView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        messageView.backgroundColor = UIColor.clearColor()
        messageView.font = UIFont(name: "PingFang SC", size: 14)
        messageView.text = "Placeholder text"
        messageView.sizeToFit()
        messageView.textColor = UIColor.whiteColor()
        self.addSubview(messageView)
        
        actionButton = UIButton(type: .System)
        actionButton.setTitle("OK", forState: .Normal)
        actionButton.tintColor = UIColor(red: 0.188, green: 0.688, blue: 0.296, alpha: 1)
        actionButton.sizeToFit()
        self.addSubview(actionButton)
        self.actionButton.addTarget(self, action: #selector(SnackbarView.actionSelector(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func setAction(block: (sender: AnyObject) -> Void) {
        self.actionBlock = block
    }
    
    func actionSelector(sender: AnyObject) {
        self.actionBlock?(sender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 8
        var y = self.bounds.height / 2 - self.messageView.bounds.height / 2
        
        messageView.frame.origin = CGPoint(x: x, y: y)
        
        x = self.bounds.width - actionButton.bounds.width - 8
        y = self.bounds.height / 2 - actionButton.bounds.height / 2
        actionButton.frame.origin = CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
