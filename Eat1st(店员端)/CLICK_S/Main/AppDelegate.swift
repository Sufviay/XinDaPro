//
//  AppDelegate.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseMessaging
import Firebase
import RxSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    private let bag = DisposeBag()
    
    
    //版本提示框
    private lazy var versonAlert: VersionAlert = {
        let alert = VersionAlert()
        return alert
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //设置版本号
        UserDefaults.standard.verID = VERID
        
        //MARK: - IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
            
        //MARK: - 检查版本
        checkVerson_Net()
        
        print("----------W:\(UIScreen.main.bounds.width)\n----------H:\(UIScreen.main.bounds.height)")
        
        return true
    }
    
    
    //从后台进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        //checkVerson_Net()
    }

    
    func checkVerson_Net() {
        //检查版本
        HTTPTOOl.checkAppVer().subscribe(onNext: { [unowned self] (json) in
            if json["data"]["verId"].stringValue != "" {
                versonAlert.appUrlStr = json["data"]["url"].stringValue
                versonAlert.isMust = json["data"]["updateType"].stringValue == "1" ? true : false
                versonAlert.showAction()
            }
        }, onError: { (error) in
            print(ErrorTool.errorMessage(error))
        }).disposed(by: self.bag)
    }
    
}


