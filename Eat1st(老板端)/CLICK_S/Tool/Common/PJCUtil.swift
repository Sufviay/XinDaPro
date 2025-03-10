//
//  PJCUtil.swift
//  SheepStoreMer
//
//  Created by 岁变 on 10/25/19.
//  Copyright © 2019 岁变. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import AVFAudio

class PJCUtil: NSObject {
    //private let bag = DisposeBag()
    
    
    /// 正则表达式验证
    static func predicate(text:String,regex:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
        
    }
    
    //MARK: - 处理转化Html
    
    ///处理转化Html
    static func dealWith(webStr: String) -> NSMutableAttributedString {
        
        var content = webStr.replacingOccurrences(of: "&amp;quot", with: "'")
         
        content = content.replacingOccurrences(of: "&lt;", with: "<")
         
        content = content.replacingOccurrences(of: "&gt;", with: ">")
         
        content = content.replacingOccurrences(of: "&quot;", with: "\"")
         
        let htmlStr = "<html> \n<head> \n<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"/> \n<style type=\"text/css\"> \nbody {font-size:15px;}\n</style> \n</head> \n<body><script type='text/javascript'>window.onload = function(){\nvar $img = document.getElementsByTagName('img');\nfor(var p in  $img){\n$img[p].style.width = '100%%';\n$img[p].style.height ='auto'\n}\n}</script>" + content + "</body></html>"
        let attStr = try? NSMutableAttributedString.init(data: htmlStr.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attStr ?? NSMutableAttributedString()
    }
    
    
    //MARK: - 处理字符串中的HTML转义字符
    static func dealHtmlZhuanYiString(contentStr: String) -> String {
        
        var tStr = contentStr.replacingOccurrences(of: "&amp;", with: "&")
        
        tStr = tStr.replacingOccurrences(of: "&lt;", with: "<")
         
        tStr = tStr.replacingOccurrences(of: "&gt;", with: ">")
         
        tStr = tStr.replacingOccurrences(of: "&quot;", with: "“")
        
        tStr = tStr.replacingOccurrences(of: "&nbsp;", with: " ")
        
        return tStr
        
    }
    
    
    ///获取富文本高度
    static func getCountentH(attrStr: NSMutableAttributedString, width: CGFloat)->CGFloat {
        let contentHegiht = attrStr.boundingRect(with: CGSize(width:  S_W, height: 100000), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).height
        return contentHegiht
    }
    
    ///复制文本
    static func wishSeed(str: String) {
        let pas = UIPasteboard.general
        pas.string = str
        HUD_MB.showSuccess("已复制", onView: PJCUtil.getWindowView())
    }
    
    //MARK: - 获取Windwo层
    ///获取Window层
    static func getWindowView() -> UIView {
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin
                    break
                }
            }
        }
        return window!
    }
    
    //MARK: - 获取当前VC
    ///获取当前VC
    static func currentVC(base: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentVC(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentVC(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentVC(base: presented)
        }
        return base
    }
    
    //MARK: - 购买成功跳转订单列表
    static func jumpOrderListVC(idx: Int) {
        
//        let orderListVC = MyOrderController()
//        orderListVC.scrollIdx = idx
//
//        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! MainNaviController
//        let tabVC = rootVC.viewControllers[0] as! MainTabBarController
//        tabVC.selectedIndex = 4
//        let vcs = [tabVC, orderListVC]
//        currentVC()?.navigationController?.setViewControllers(vcs, animated: true)
    }
    
    
    //MARK: - 系统登出
    static func logOutWithAlert() {
//        //获取当前VC
//        let vc = PJCUtil.currentVC()
//        if vc == nil {
//            return
//        }
//
//        let alertVC = UIAlertController(title: "提示", message: "是否退出登录", preferredStyle: .alert)
//        let sureAction = UIAlertAction(title: "确定", style: .default) { [unowned vc] (_) in
//
//            HUD_MB.showMessage("已退出", getWindowView())
//            UserDefaults.removeAll()
//            let vcs = vc?.navigationController?.viewControllers
//            let tab = vcs![0] as! MainTabBarController
//            tab.selectedIndex = 0
//            vc?.navigationController?.popToRootViewController(animated: true)
//        }
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        alertVC.addAction(sureAction)
//        alertVC.addAction(cancelAction)
//
//        DispatchQueue.main.async {
//            vc?.present(alertVC, animated: true, completion: nil)
//        }
    }
    
    //MARK: - 播放视频
    static func playVideo(url: String) {
        let video = AVPlayerViewController()
        video.player = AVPlayer.init(url: URL(string: url)!)
        currentVC()?.present(video, animated: true, completion: nil)
    }
    
    //MARK: - 登出
    static func logOut() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logOut"), object: nil)
        
        UserDefaults.standard.isLogin = false
        UserDefaults.standard.removeObject(forKey: Keys.userName)
        UserDefaults.standard.removeObject(forKey: Keys.token)
        UserDefaults.standard.removeObject(forKey: Keys.userType)
        UserDefaults.standard.removeObject(forKey: Keys.userAuth)
        PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
        
    }
    
    //MARK: - 检查是否登录
    static func checkLoginStatus() -> Bool {
        if !UserDefaults.standard.isLogin {
//            let alert = ReminLogInAlert()
//            alert.clickBlock = { (_) in
//                let loginVC = LogInController()
//                loginVC.modalPresentationStyle = .fullScreen
//                PJCUtil.currentVC()?.present(loginVC, animated: true, completion: nil)
//            }
//
//            alert.appearAction()
            return false
        }
        return true
    }
    
    //MARK: - 拨打电话
    static func callPhone(phone: String) {
        
        if phone == "" {
            return
        }
        //获取当前VC
        let vc = PJCUtil.currentVC()
        if vc == nil {
            return
        }
        //弹出提示框
        let alertVC = UIAlertController(title: "Phone: \(phone)", message: "", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "Call", style: .default) { (_) in
            UIApplication.shared.open(URL(string: "tel://\(phone)")!, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(sureAction)
        alertVC.addAction(cancelAction)

        DispatchQueue.main.async {
            vc?.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - 字典转JSON
    static func convertDictionaryToString(dict:[String:Any]) -> String {
      var result:String = ""
      do {
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
     
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
          result = JSONString
        }
     
      } catch {
        result = ""
      }
      return result
    }
    
    
    ///返回订单状态
    static func getOrderStatus(StatusString: String) -> OrderStatus {
        //订单状态（1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成）
        
        if StatusString == "1" {
            return .pay_wait
        }
        if StatusString == "2" {
            return .pay_ing
        }
        if StatusString == "3" {
            return .pay_fail
        }
        if StatusString == "4" {
            return .user_cancel
        }
        if StatusString == "5" {
            return .shops_cancel
        }
        if StatusString == "6" {
            return .system_cancel
        }
        if StatusString == "7" {
            return .reject
        }
        if StatusString == "8" {
            return .pay_success
        }
        if StatusString == "9" {
            return .takeOrder
        }
        if StatusString == "10" {
            return .cooked
        }
        if StatusString == "11" {
            return .paiDan
        }
        if StatusString == "12" {
            return .delivery_ing
        }
        if StatusString == "13" {
            return .finished
        }
    
        return .unKnown
    }

    
    
    ///跳转导航
    static func goDaohang(lat: Double, lng: Double) {
        let url = URL(string: "http://maps.google.com/maps?f=d&daddr=\(lat),\(lng)&sspn=0.2,0.1&nav=1")
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    
    //播放声音
    static func playVoice(name: String, type: String) -> AVAudioPlayer? {
               
        guard let path = Bundle.main.path(forResource: "voice_order_pay_succeed", ofType: "mp3") else {
            print("音频文件未找到！")
            return nil
        }
        let url = NSURL.fileURL(withPath: path)

        let player = try? AVAudioPlayer.init(contentsOf: url)

        player?.prepareToPlay()

        return player
        
    }
    
    //MARK: - 获取当前系统语言版本
    static func getCurrentLanguage() -> String {
        
        if let lang = Locale.preferredLanguages.first {
            if lang.hasPrefix("zh") {
                if lang.contains("Hant") || lang.contains("Trad") {
                    return "zh_HK"
                }
                return "zh_CN"
            } else if lang.contains("en") {
                return "en_GB"
            } else {
                return "en_GB"
            }
        } else {
            return "en_GB"
        }
    }
    
    //MARK: - 获取版本号
    static func getCurentVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    

    //MARK: - 获取本地Gif图片
    static func getGifImg(name: String) -> UIImage? {
        let path = Bundle.main.path(forResource: name, ofType: "gif")
        let url = URL.init(fileURLWithPath: path!)
        let imgeData = try? Data(contentsOf: url)
        return UIImage.sd_image(withGIFData: imgeData)
    }



    
}


///订单状态  1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
enum OrderStatus {
    case pay_wait        ///待支付
    case pay_ing         ///支付中
    case pay_fail        ///支付失败
    case user_cancel     ///用户取消
    case system_cancel   ///系统取消
    case shops_cancel    ///商家取消
    case reject          ///商家拒接
    case pay_success     ///支付成功
    case takeOrder       ///接单
    case paiDan          ///派单
    case cooked          ///已出餐
    case delivery_ing    ///配送中
    case finished        ///已完成
    case unKnown
}
