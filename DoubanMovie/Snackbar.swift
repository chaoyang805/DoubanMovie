//
//  Snackbar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/5.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

let SnackbarShouldShowNotification = "show snackbar"
let SnackbarShouldDismissNotification = "dismiss snackbar"
let SnackbarUserInfoKey = "targetSnackbar"

@objc protocol SnackbarDelegate: NSObjectProtocol {
    
    optional func snackbarWillAppear(snackbar: Snackbar)
    optional func snackbarDidAppear(snackbar: Snackbar)
    optional func snackbarWillDisappear(snackbar: Snackbar)
    optional func snackbarDidDisappear(snackbar: Snackbar)
}

enum SnackbarDuration: NSTimeInterval {
    case Short = 1.5
    case Long = 3
}

class Snackbar: NSObject {
    
    private(set) lazy var view: SnackbarView = {
        let _barView = SnackbarView()
        // 为了Snackbar不被销毁
        _barView.snackbar = self
        return _barView
    }()
    
    private var showing: Bool = false
    
    private var dismissHandler: (() -> Void)?
    
    var duration: NSTimeInterval!
    
    private weak var delegate: SnackbarDelegate?
    
    class func make(text: String, duration: SnackbarDuration) -> Snackbar {
        return make(text, duration: duration.rawValue)
    }
    
    private class func make(text: String, duration: NSTimeInterval) -> Snackbar {
        let snackbar = Snackbar()
        
        snackbar.setSnackbarText(text)
        snackbar.duration = duration
        snackbar.registerNotification()
        snackbar.delegate = SnackbarManager.defaultManager()
    
        return snackbar
    }
    
    func show() {
        
        let record = SnackbarRecord(duration: duration, identifier: hash)
        SnackbarManager.defaultManager().show(record)
    }
    
    func dispatchDismiss() {
        let record = SnackbarRecord(duration: duration, identifier: hash)
        SnackbarManager.defaultManager().dismiss(record)
    }
    
    // MARK: - Notification
    func registerNotification() {
        let manager = SnackbarManager.defaultManager()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Snackbar.handleNotification(_:)), name: SnackbarShouldShowNotification, object: manager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Snackbar.handleNotification(_:)), name: SnackbarShouldDismissNotification, object: manager)
    }
    
    func unregisterNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    deinit {
        NSLog("deinit")
    }
    
    func handleNotification(notification: NSNotification) {
        guard let identifier = notification.userInfo?[SnackbarUserInfoKey] as? Int else {
            NSLog("not found snackbar in notification's userInfo")
            return
        }
        
        guard identifier == self.hash else {
            NSLog("not found specified snackbar:\(identifier)")
            return
        }
        
        switch notification.name {
        case SnackbarShouldShowNotification:
            
            handleShowNotification()
            
        case SnackbarShouldDismissNotification:
            
            handleDismissNotification()
            
        default:
            break
        }
    }
    
    func handleShowNotification() {
        
        self.showView()
    }
    
    func handleDismissNotification() {
        
        self.dismissView()
    }
    
    // MARK: - Configure Snackbar
    func setSnackbarText(text: String) {
        view.messageView.text = text
        view.messageView.sizeToFit()
    }
    // MARK: - Warning Retain cycle（solved）
    func setAction(title: String, action: ((sender: AnyObject) -> Void)) -> Snackbar {
        
        view.setAction(title) { (sender) in
            action(sender: sender)
            self.dispatchDismiss()
        }

        return self
    }
    
    func dismissHandler(block: (() -> Void)) -> Snackbar {
        self.dismissHandler = block
        return self
    }
    
    // MARK: - Snackbar View show & dismiss
    
    private func showView() {
        guard let window = UIApplication.sharedApplication().keyWindow else { return }
        
        self.delegate?.snackbarWillAppear?(self)
        
        window.addSubview(view)
        
        UIView
            .animateWithDuration(0.25,
                                 delay: 0,
                                 options: .CurveEaseIn,
                                 animations: { [weak self] in
                                    
                                    guard let `self` = self else { return }
                                    self.view.frame.offsetInPlace(dx: 0, dy: -40)
                                    
                }, completion: { (done ) in
                    
                    self.delegate?.snackbarDidAppear?(self)
                    self.showing = true
                    
            })
        
    }
    
    func dismissView() {
        
        guard self.showing else { return }
        self.delegate?.snackbarWillDisappear?(self)
        
        UIView
            .animateWithDuration(0.25,
                                 delay: 0,
                                 options: UIViewAnimationOptions.CurveEaseIn,
                                 animations: { [weak self] in
                                    
                                    guard let `self` = self else { return }
                                    self.view.frame.offsetInPlace(dx: 0, dy: 40)
                                    
                }, completion: { (done) in
                    
                    self.showing = false
                    
                    self.view.snackbar = nil
                    self.view.removeFromSuperview()
                    
                    self.dismissHandler?()
                    
                    self.delegate?.snackbarDidDisappear?(self)
                    self.delegate = nil
                    
                    self.unregisterNotification()
                    
            } )
        
    }
}