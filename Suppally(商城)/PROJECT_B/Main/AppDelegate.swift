//
//  AppDelegate.swift
//  PROJECT_B
//
//  Created by 肖扬 on 2023/1/3.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: - IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        Thread.sleep(forTimeInterval: 1) // 添加这行代码
        return true
    }
    


}

