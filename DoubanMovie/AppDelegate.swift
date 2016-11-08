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
import RxAlamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum ShortcutIdentifier: String {
        case share
        case favorite
        case search
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: last)
        }
        
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    var window: UIWindow?
    private var launchedShortcutItem: UIApplicationShortcutItem?
    
    @discardableResult
    private func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false

        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        switch shortcutItem.type {
        case ShortcutIdentifier.favorite.type:
            handled = true
            handleFavoriteShortcut()
        case ShortcutIdentifier.search.type:
            handled = true
            handleSearchShortcut()
        case ShortcutIdentifier.share.type:
            handled = true
            handleShareShortcut()
        default:
            break
        }
        return handled
    }
    
    private func handleShareShortcut() {
        guard let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController as? UINavigationController else { return }
    }
    
    private func handleFavoriteShortcut() {
        guard let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController as? UINavigationController else { return }
        rootVC.popToRootViewController(animated: false)
        
        if let homeVC = rootVC.topViewController as? HomeViewController {
            homeVC.performSegue(withIdentifier: "FavoritesSegue", sender: rootVC)
        }
    }
    
    private func handleSearchShortcut() {
        guard let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController as? UINavigationController else { return }
        
        rootVC.popToRootViewController(animated: false)
        
        if let homeVC = rootVC.topViewController as? HomeViewController {
            homeVC.performSegue(withIdentifier: "SearchSegue", sender: rootVC)
        }
    }
    // 程序运行在后台时通过 shortcut 恢复时调用
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let handledShortcutItem = handleShortcutItem(shortcutItem)
        completionHandler(handledShortcutItem)
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // return false 不调用 applicationPerformAction ，一般在程序通过 shortcut 启动时 return false 然后在 application didBecomeActive
        var shouldPerformAdditionalDelegateHandling = true
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            shouldPerformAdditionalDelegateHandling = false
        }
        
        return shouldPerformAdditionalDelegateHandling
    }

    //  application didFinishLaunchingWithOptions return false 时，说明是通过 shortcut 启动，在这里处理 shortcut
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        guard let shortcutItem = launchedShortcutItem else { return }
        
        handleShortcutItem(shortcutItem)
        launchedShortcutItem = nil
    }

}

