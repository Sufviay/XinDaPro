//
//  HUDManager_MB.swift
//  Demo
//
//  Created by 岁变 on 7/31/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit
import MBProgressHUD

enum ProgressHUDStatus {
    ///等待
    case waitting
    ///成功
    case success
    ///失败
    case error
    ///警告提示
    case info
    ///文字提示
    case onlyText
    ///过程
    case progess
}


class HUD_MB: NSObject {
    
    
    ///只显示文本
    static func showMessage(_ msg: String, _ view: UIView = getWindowView()) {
        showWithStatus(hudStatus: .onlyText, text: msg, progress: 0, onView: view)
    }
    
    ///展示错误
    static func showError(_ msg: String, onView view: UIView) {
        showWithStatus(hudStatus: .error, text: msg, progress: 0, onView: view)
    }
    
    ///展示成功
    static func showSuccess(_ msg: String, onView view: UIView) {
        showWithStatus(hudStatus: .success, text: msg, progress: 0, onView: view)
    }
    
    ///等待
    static func loading(_ msg: String, onView view: UIView) {
        showWithStatus(hudStatus: .waitting, text: msg, progress: 0, onView: view)
    }
    
    ///带警告的提示框
    static func showWarnig(_ msg: String, onView view: UIView) {
        showWithStatus(hudStatus: .info, text: msg, progress: 0, onView: view)
    }
    
    ///带进度条的
    static func showProgress(_ msg: String, progress: Float, onView view: UIView) {
        showWithStatus(hudStatus: .progess, text: msg, progress: progress, onView: view)
    }
    
    
    ///隐藏
    static func dissmiss(onView view: UIView) {
        let hud: MBProgressHUD = MBProgressHUD.forView(view) ?? MBProgressHUD()
        hud.hide(animated: true)
    }
    
    
    static private func showWithStatus(hudStatus status: ProgressHUDStatus, text msg: String?, progress: Float, onView view: UIView) {
            
        
        
        let path = Bundle.main.path(forResource: "HUD_MB", ofType: "bundle")
        let hud = MBProgressHUD.forView(view) ?? MBProgressHUD()
        hud.removeFromSuperViewOnHide = true
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.5)
        hud.contentColor = .white
        hud.label.text = msg
        hud.label.font = UIFont.systemFont(ofSize: 13)
        hud.bezelView.layer.cornerRadius = 15
        
        
        switch status {
        case .onlyText:
            hud.mode = .text
            hud.animationType = .zoom
            view.addSubview(hud)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
            break
            
        case .error:
            hud.mode = .customView
            let imgPath = path?.appendingFormat("/%@", "error.png")
            var img = UIImage(contentsOfFile: imgPath!)
            img = img?.withRenderingMode(.alwaysTemplate)
            let imgView = UIImageView()
            imgView.tintColor = .white
            imgView.image = img
            hud.customView = imgView
            view.addSubview(hud)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
            break

        case .success:
            hud.mode = .customView
            let imgPath = path?.appendingFormat("/%@", "success.png")
            var img = UIImage(contentsOfFile: imgPath!)
            img = img?.withRenderingMode(.alwaysTemplate)
            let imgView = UIImageView()
            imgView.tintColor = .white
            imgView.image = img
            hud.customView = imgView
            view.addSubview(hud)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
            break
            
        case .info:
            hud.mode = .customView
            let imgPath = path?.appendingFormat("/%@", "info.png")
            var img = UIImage(contentsOfFile: imgPath!)
            img = img?.withRenderingMode(.alwaysTemplate)
            let imgView = UIImageView()
            imgView.tintColor = .white
            imgView.image = img
            hud.customView = imgView
            view.addSubview(hud)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
            break
            
        case .waitting:
            hud.mode = .indeterminate
//            let imgView = UIImageView()
//            imgView.animationImages = animationImages as? [UIImage]
//            imgView.animationDuration = 1
//            hud.customView = imgView
            view.addSubview(hud)
            hud.show(animated: true)
//            imgView.startAnimating()
            break
            
        case .progess:
            hud.mode = .annularDeterminate
            hud.progress = progress
            view.addSubview(hud)
            hud.show(animated: true)
            break
        }
    }
    

    
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
}
