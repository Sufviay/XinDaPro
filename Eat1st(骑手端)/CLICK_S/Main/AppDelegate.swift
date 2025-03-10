//
//  AppDelegate.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import GooglePlaces
import GoogleMaps


let MYGG_APIKEY: String = "AIzaSyDg8t9-e2tvq5dmVzrRjonIujmC2Lihy-Y"


let JGAppKey: String = "0e1dde4fb59dec8a0ab01472"


@main
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!) async -> Int {
        
        print("收到通知了-----------------444")
        
        let userinfo = notification.request.content.userInfo
        
        guard let trigger = notification.request.trigger else { return 0 }
        
        
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userinfo)
        }
        
        let types : Int = Int(UNNotificationPresentationOptions.alert.rawValue)|Int(UNNotificationPresentationOptions.sound.rawValue)
        //|Int(UNNotificationPresentationOptions.badge.rawValue)
        return types
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!) async {
        print("收到通知了-----------------333")
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        print("收到通知了-----------------222")
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
        print("收到通知了-----------------1111")
        
        //推送来了 刷新订单列表
        //NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
        
    }
    
    
    
    
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    private let bag = DisposeBag()
    
    private lazy var player = PJCUtil.playVoice(name: "voice_order_pay_succeed", type: "mp3")
    
    
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
        
        //        //MARK: - Firebase
        //        FirebaseApp.configure()
        
        //MARK: - 高的地图
        GMSPlacesClient.provideAPIKey(MYGG_APIKEY)
        GMSServices.provideAPIKey(MYGG_APIKEY)
                
        
        //MARK: - 极光推送
        let entity = JPUSHRegisterEntity()
        entity.types =  Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.sound.rawValue)
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        //【初始化sdk】
        // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
        JPUSHService.setup(withOption: launchOptions, appKey: JGAppKey, channel: "App Store", apsForProduction: ISONLINE)
        
        //JPUSHService.setBadge(<#T##value: Int##Int#>)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
        
        //MARK: - 检查版本
        checkVerson_Net()
        
        return true
    }
    
    
    @objc private func networkDidReceiveMessage(notification: Notification) {
        
        let userInfo = notification.userInfo
        let content: String = userInfo?["content"] as? String ?? ""
        print(content)
        
        //推送来了 刷新订单列表
        NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
        
        
    }
    
    
    
    //从后台进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("进入前台刷新列表")
        NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
        checkVerson_Net()
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //sdk注册DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    
    ///检查版本
    private func checkVerson_Net() {
        //检查版本
        HTTPTOOl.CheckAppVer().subscribe(onNext: { [unowned self] (json) in
            if json["data"]["verId"].stringValue != "" {
                
                versonAlert.appUrlStr = json["data"]["url"].stringValue
                versonAlert.isMust = json["data"]["updateType"].stringValue == "1" ? true : false
                versonAlert.showAction()
            }
        }, onError: { (error) in
        }).disposed(by: self.bag)
    }
    
}
