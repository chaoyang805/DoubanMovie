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

let SnackbarShouldShowNotification = Notification.Name("show snackbar")
let SnackbarShouldDismissNotification = Notification.Name("dismiss snackbar")
let SnackbarUserInfoKey = "targetSnackbar"

@objc protocol SnackbarDelegate: NSObjectProtocol {
    
    @objc optional func snackbarWillAppear(_ snackbar: Snackbar)
    @objc optional func snackbarDidAppear(_ snackbar: Snackbar)
    @objc optional func snackbarWillDisappear(_ snackbar: Snackbar)
    @objc optional func snackbarDidDisappear(_ snackbar: Snackbar)
}

enum SnackbarDuration: TimeInterval {
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
    
    var duration: TimeInterval!
    
    private weak var delegate: SnackbarDelegate?
    
    class func make(text: String, duration: SnackbarDuration) -> Snackbar {
        return make(text, duration: duration.rawValue)
    }
    
    private class func make(_ text: String, duration: TimeInterval) -> Snackbar {
        let snackbar = Snackbar()
        
        snackbar.setSnackbarText(text: text)
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
        NotificationCenter.default.addObserver(self, selector: #selector(Snackbar.handleNotification(_:)), name: SnackbarShouldShowNotification, object: manager)
        NotificationCenter.default.addObserver(self, selector: #selector(Snackbar.handleNotification(_:)), name: SnackbarShouldDismissNotification, object: manager)
    }
    
    func unregisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NSLog("deinit")
    }
    
    func handleNotification(_ notification: NSNotification) {
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
    func setAction(title: String, action: @escaping ((_ sender: AnyObject) -> Void)) -> Snackbar {
        view.setAction(title: title) { (sender) in
            action(sender)
            self.dispatchDismiss()
        }
        return self
    }
    
    func dismissHandler(block: @escaping (() -> Void)) -> Snackbar {
        self.dismissHandler = block
        return self
    }
    
    // MARK: - Snackbar View show & dismiss
    
    private func showView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.delegate?.snackbarWillAppear?(self)
        
        window.addSubview(view)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseIn,
            animations: { [weak self] in
            
                guard let `self` = self else { return }
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -40)
            },
            completion: { (done ) in
                    
                self.delegate?.snackbarDidAppear?(self)
                self.showing = true
            })
        
    }
    
    func dismissView() {
        
        guard self.showing else { return }
        self.delegate?.snackbarWillDisappear?(self)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseIn,
                animations: { [weak self] in
                    
                    guard let `self` = self else { return }
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 40)
                    
                },
                completion: { (done) in
                    
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
