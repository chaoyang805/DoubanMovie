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
    
    private var currentSnackbar: SnackbarRecord?
    private var nextSnackbar: SnackbarRecord?
    
    func show(r: SnackbarRecord) {
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
    
    func dismiss(r: SnackbarRecord) {
        if isCurrentSnackbar(r) {
            
            cancelCurrentSnackbar()
            
        } else if isNextSnackbar(r) {
            
            cancelNextSnackbar()
        }
    }
    
    func cancelCurrentSnackbar() {
        
        let notification = NSNotification(name: SnackbarShouldDismissNotification, object: self, userInfo: [SnackbarUserInfoKey: currentSnackbar!.identifier])
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
    }
    
    func cancelNextSnackbar() {
        let notification = NSNotification(name: SnackbarShouldDismissNotification, object: self, userInfo: [SnackbarUserInfoKey: nextSnackbar!.identifier])
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    func isCurrentSnackbar(r: SnackbarRecord) -> Bool {
        if currentSnackbar != nil && currentSnackbar!.identifier == r.identifier {
            return true
        }
        return false
    }
    
    func isNextSnackbar(r: SnackbarRecord) -> Bool {
        if nextSnackbar != nil && nextSnackbar!.identifier == r.identifier {
            return true
        }
        return false
    }

    func showNextSnackbar() {
        
        if nextSnackbar != nil {

            currentSnackbar = nextSnackbar
            nextSnackbar = nil
            let notification = NSNotification(name: SnackbarShouldShowNotification, object: self, userInfo: [SnackbarUserInfoKey: currentSnackbar!.identifier])

            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    
    
    // MARK: - Scheduled Timer
    var timer: NSTimer!
    
    func scheduleTimeout(r: SnackbarRecord) {
        let duration = r.duration
        
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(SnackbarManager.onTimeout(_:)), userInfo: r.identifier, repeats: false)
    }
    
    func updateTimeout(record: SnackbarRecord) {
        timer.invalidate()
        scheduleTimeout(record)
    }
    
    func onTimeout(timer: NSTimer) {
        
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
    
    func snackbarDidAppear(snackbar: Snackbar) {
        let r = SnackbarRecord(duration: snackbar.duration, identifier: snackbar.hash)
        scheduleTimeout(r)
    }
    
    func snackbarDidDisappear(snackbar: Snackbar) {
        let r = SnackbarRecord(duration: snackbar.duration, identifier: snackbar.hash)
        if isCurrentSnackbar(r) {
            currentSnackbar = nil
        }
        showNextSnackbar()
    }
}
