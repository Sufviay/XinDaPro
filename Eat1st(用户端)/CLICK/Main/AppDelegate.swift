//
//  AppDelegate.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/24.
//

import UIKit
import IQKeyboardManagerSwift

import GoogleMaps
import GooglePlaces
import Firebase
//import Stripe
import FirebaseMessaging
import RxSwift



let MYGG_APIKEY: String = "AIzaSyCV8CMkJ2li4bYE_ytW3HugCA6G_btll_I"

@main
class AppDelegate: UIResponder, UIApplicationDelegate{


    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    private let bag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //设置版本号
        UserDefaults.standard.verID = VERID
        
        //获取当前系统语言
        LocalizationTool.shared.checkLanguage()
        
        //MARK: - IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //MARK: - 高的地图
        GMSPlacesClient.provideAPIKey(MYGG_APIKEY)
        GMSServices.provideAPIKey(MYGG_APIKEY)
        
        //MARK: - Firebase
        FirebaseApp.configure()
    
        //MARK: - 推送
        
        Messaging.messaging().delegate = self
    
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
       
        //MARK: - 展示未读消息
        if UserDefaults.standard.isLogin {
            //是否有未读消息
            HTTPTOOl.getMessagesList(page: 1).subscribe(onNext: { (json) in
                
                for jsonData in json["data"].arrayValue {
                    if jsonData["readType"].stringValue == "1" {
                        //有未读消息展示消息弹窗
                        let model = MessageModel()
                        model.updateModel(json: jsonData)
                        let alert = MessageAlert()
                        alert.messageModel = model
                        alert.appearAction()
                        break
                    }
                }
    
            }).disposed(by: self.bag)
        }
        
    
        return true
    }
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    // [START receive_message]
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }
    
}




extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    //上传给服务器

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )

    UserDefaults.standard.tsToken = fcmToken ?? ""
    
    if UserDefaults.standard.isLogin {
        guard let token = fcmToken else {return}
        HTTPTOOl.updateTSToken(token: token).subscribe(onNext: { (json) in
            print("推送注册成功")
        }, onError: { (error) in
            print("推送注册失败")
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
        }).disposed(by: self.bag)
    }
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  // [END refresh_token]
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo
    
    

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
      completionHandler([.alert, .sound, .badge])
    
    
      let type = userInfo["pushType"]
      if type as? String == "1" {
          //推送来了 刷新订单列表 刷新
          NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
      }
      if type as? String == "2" {
          //活动 刷新钱包
          NotificationCenter.default.post(name: NSNotification.Name("wallet"), object: nil)
      }
      
      if type as? String == "3" {
          //系统消息
          NotificationCenter.default.post(name: NSNotification.Name("message"), object: nil)
      }
      
      
      
      print("推送来了")
    
    
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print(userInfo)

    completionHandler()
  }
}




