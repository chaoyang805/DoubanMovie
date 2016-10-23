//
//  SnackbarManager.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/6.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

/**
 1. 如果要显示的是当前正在显示的snackbar，那么更新当前bar的时间，并重新计时
 2. 如果传入的是下一个 snackbar，就直接更新显示时间
 3. 两种情况都不是，那就创建一个新的snackbar记录，添加到nextSnackbar上
 4. 如果正在显示Snackbar，就取消当前的Snackbar，并显示下一个
 5. 否则就直接显示下一个Snackbar
 */
class SnackbarManager: NSObject {

    private override init() { super.init() }
    
    private static let instance: SnackbarManager = SnackbarManager()
    
    static func defaultManager() -> SnackbarManager {
        return instance
    }
    
    fileprivate var currentSnackbar: SnackbarRecord?
    private var nextSnackbar: SnackbarRecord?
    
    func show(_ r: SnackbarRecord) {
        // 如果当前有显示的Snackbar
        if isCurrentSnackbar(r) {
             updateTimeout(r)
        } else if isNextSnackbar(r) {
            // reconfig timeout
            nextSnackbar?.duration = r.duration
        } else {
            nextSnackbar = r
        }
        
        if currentSnackbar != nil {
            cancelCurrentSnackbar()
            return
        } else {
            currentSnackbar = nil
            showNextSnackbar()
        }
        
    }
    
    func dismiss(_ r: SnackbarRecord) {
        if isCurrentSnackbar(r) {
            
            cancelCurrentSnackbar()
            
        } else if isNextSnackbar(r) {
            
            cancelNextSnackbar()
        }
    }
    
    func cancelCurrentSnackbar() {
        
        let notification = Notification(name: SnackbarShouldDismissNotification, object: self, userInfo: [SnackbarUserInfoKey: currentSnackbar!.identifier])
        
        NotificationCenter.default.post(notification)
        
    }
    
    func cancelNextSnackbar() {
        let notification = Notification(name: SnackbarShouldDismissNotification, object: self, userInfo: [SnackbarUserInfoKey: nextSnackbar!.identifier])
        
        NotificationCenter.default.post(notification)
    }
    
    func isCurrentSnackbar(_ r: SnackbarRecord) -> Bool {
        if currentSnackbar != nil && currentSnackbar!.identifier == r.identifier {
            return true
        }
        return false
    }
    
    func isNextSnackbar(_ r: SnackbarRecord) -> Bool {
        if nextSnackbar != nil && nextSnackbar!.identifier == r.identifier {
            return true
        }
        return false
    }

    func showNextSnackbar() {
        
        if nextSnackbar != nil {

            currentSnackbar = nextSnackbar
            nextSnackbar = nil
            let notification = Notification(name: SnackbarShouldShowNotification, object: self, userInfo: [SnackbarUserInfoKey: currentSnackbar!.identifier])

            NotificationCenter.default.post(notification)
        }
    }
    
    
    // MARK: - Scheduled Timer
    var timer: Timer!
    
    func scheduleTimeout(_ r: SnackbarRecord) {
        let duration = r.duration
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(SnackbarManager.onTimeout(_:)), userInfo: r.identifier, repeats: false)
    }
    
    func updateTimeout(_ record: SnackbarRecord) {
        timer.invalidate()
        scheduleTimeout(record)
    }
    
    func onTimeout(_ timer: Timer) {
        
        if let identifier = timer.userInfo as? Int {
            self.dismiss(SnackbarRecord(duration: 0, identifier: identifier))
        } else {
            NSLog("timeout couldn't find the snackbar in userInfo")
        }
        timer.invalidate()
    }
}
// MARK: - SnackbarDelegate
extension SnackbarManager: SnackbarDelegate {
    
    func snackbarDidAppear(_ snackbar: Snackbar) {
        let r = SnackbarRecord(duration: snackbar.duration, identifier: snackbar.hash)
        scheduleTimeout(r)
    }
    
    func snackbarDidDisappear(_ snackbar: Snackbar) {
        let r = SnackbarRecord(duration: snackbar.duration, identifier: snackbar.hash)
        if isCurrentSnackbar(r) {
            currentSnackbar = nil
        }
        showNextSnackbar()
    }
}
