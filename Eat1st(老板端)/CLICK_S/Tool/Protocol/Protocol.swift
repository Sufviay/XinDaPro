//
//  Protocol.swift
//  Demo
//
//  Created by 岁变 on 5/6/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import PhotosUI


let MBHUD_Hidetime: TimeInterval = 2

//MARK: - 菊花转Protocol
protocol HUDProtocol {
    
}

extension HUDProtocol where Self: Any {
    
    /**
    hud?.mode = .indeterminate  菊花
    hud?.mode = .annularDeterminate 进程
    hud?.mode = .customView   自定义
    hud?.mode = .determinate
    hud?.mode = .text
    **/
    
    
    ///菊花类型
    func showJHHud(_ view: UIView, _ hud: MBProgressHUD, _ titStr: String, _ detailStr: String = ""){
        hud.mode = .indeterminate
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.6)
        hud.contentColor = .white
        hud.label.text = titStr
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = detailStr
        hud.animationType = .zoom
        view.addSubview(hud)
        hud.show(animated: true)
    }
    
    ///文字类型
    func showTextHudWith(_ view: UIView, _ hud: MBProgressHUD, _ titStr: String, _ detailStr: String = "") {
        hud.mode = .text
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.6)
        hud.contentColor = .white
        hud.label.text = titStr
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = detailStr
        
        hud.animationType = .zoom
        view.addSubview(hud)
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: MBHUD_Hidetime)
    }
    
    
    ///文字类型
    func showTextHud(titStr: String, detailStr: String) {
        let hud = MBProgressHUD()
        hud.mode = .text
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.6)
        hud.contentColor = .white
        hud.label.text = titStr
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = detailStr
        
        hud.animationType = .zoom
        let window = UIApplication.shared.keyWindow
        window!.addSubview(hud)
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: MBHUD_Hidetime)

    }
    
    
    /// 立即消失
    func dismissHud(_ hud: MBProgressHUD) {
        hud.hide(animated: false)
    }
    
    /// 一段时间自动消失
    func dismissHudWithTime(_ hud: MBProgressHUD, _ delay: TimeInterval = MBHUD_Hidetime) {
        hud.hide(animated: false, afterDelay: MBHUD_Hidetime)
    }
}


//MARK: - 关于系统提示框
protocol SystemAlertProtocol {}

extension SystemAlertProtocol where Self: Any {
    ///展示系统提示框
    func showSystemAlert(_ title: String, _ message: String, _ butStr: String, _ action: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: butStr, style: .cancel) { (_) in
            action?()
        }
        alertController.addAction(cancelAction)
        let vc = PJCUtil.currentVC()
        if vc != nil {
            vc!.present(alertController, animated: true, completion: nil)
        }
    }

    func showSystemChooseAlert(_ title: String, _ message: String, _ l_str: String, _ r_str: String, _ doAction: @escaping () -> (), _ cancelAction: (() -> ())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let clAction = UIAlertAction(title: r_str, style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
            cancelAction?()
        }
        let doSomethingAction = UIAlertAction(title: l_str, style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
            doAction()
        }
        alertController.addAction(doSomethingAction)
        alertController.addAction(clAction)

        let vc = PJCUtil.currentVC()
        if vc != nil {
            vc!.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func showSelectImgSheetAlert(titStr: String, xcAction: @escaping () -> (), xjAction: @escaping () -> ()) {
        let alertController = UIAlertController(title: titStr, message: "", preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "Album", style: .default) { (alert) in
            xcAction()
        }
        let actionTwo = UIAlertAction(title: "Camera", style: .default) { (alert) in
            xjAction()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        alertController.addAction(cancel)
        let vc = PJCUtil.currentVC()
        if vc != nil {
            vc!.present(alertController, animated: true, completion: nil)
        }
    }
}




//MARK: - 通用的方法Protocol
protocol CommonToolProtocol {
    
    
}

extension CommonToolProtocol where Self: Any {

    ///  判断手机号是否合法
    func isPhoneBeUsed(number: String) -> Bool {
        return PJCUtil.predicate(text: number, regex:  "^1(3[0-9]|4[57]|5[0-35-9]|6[6]|8[0-9]|9[89]|7[0678])\\d{8}$")
    }
    
    /// 打开App进行登陆判断
//    func openAppDealLoginStatus() {
//        
//        //沙盒取出登录时间
//        guard let lastTime = UserDefaults.standard.loginTime else {
//            //第一次登陆按过期行为处理
//            UserDefaults.standard.isLogin = false
//            return
//        }
//        
//        //判断时间
//        let nowTime = Date().timeStampInt
//        let tempTime = nowTime - lastTime
//        if tempTime > 30 * 24 * 60 * 60 {
//            //过期
//            //清除一切缓存
//            UserDefaults.removeAll()
//            
//        } else {
//            //没有过期
//            //更新打开App时间
//            UserDefaults.standard.loginTime = nowTime
//        }
//    }
    
    
    ///保存图片到相册
//    func savePictureToPhoto(pic: UIImage, _ target: Any?, completionSelector: Selector) {
//        UIImageWriteToSavedPhotosAlbum(pic, target, completionSelector, nil)
//    }
//
    //MARK: - 相机相册相关
    //打开相机拍照
    func showCamera() {
        let currentVC = PJCUtil.currentVC()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pick:UIImagePickerController = UIImagePickerController()
            pick.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            pick.sourceType = .camera
            currentVC!.present(pick, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "提示", message: "未检测到相机", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            currentVC!.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func showPhotoLibrary() {
        let currentVC = PJCUtil.currentVC()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pick:UIImagePickerController = UIImagePickerController()
            pick.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            pick.sourceType = .photoLibrary
            currentVC!.present(pick, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "提示", message: "未检测到相册", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            currentVC!.present(alertController, animated: true, completion: nil)
        }
    }
    
    //打开相册
    /**
     0为图片  1为视频  2为视频和图片
     */
    func showAblum(_ selCount: Int = 1, _ pickerType: Int = 0) {
        let currentVC = PJCUtil.currentVC()
        let vc = HXAlbumListViewController()
        let phManager = HXPhotoManager()

        if pickerType == 0 {
            phManager.type = .photo
            phManager.configuration.photoMaxNum = UInt(selCount)
        }
        if pickerType == 1 {
            phManager.type = .video
            phManager.configuration.videoMaximumDuration = 30
            phManager.configuration.singleSelected = true
        }
        if pickerType == 2 {
            phManager.type = .photoAndVideo
        }

        phManager.configuration.saveSystemAblum = true
        phManager.configuration.navBarBackgroudColor = .white
        phManager.configuration.navigationTitleColor = FONTCOLOR
        phManager.configuration.requestImageAfterFinishingSelection = true
        vc.manager = phManager
        vc.delegate = self as? HXAlbumListViewControllerDelegate
        let nav = HXCustomNavigationController(rootViewController: vc)
        if #available(iOS 13.0, *) {
            nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        }
        currentVC!.present(nav, animated: true, completion: nil)
    }

    
    //展开图片
    func showImage(_ containerView: UIView, _ imageCount: Int = 1, _ currnetIndex: Int = 0) {
        let brower = SDPhotoBrowser()
        brower.delegate = self as? SDPhotoBrowserDelegate
        brower.sourceImagesContainerView = containerView
        brower.imageCount = imageCount
        brower.currentImageIndex = currnetIndex
        brower.show()
        
    }
    
    ///数组转JSON
    func getJSONStringFromArray(array:NSArray) -> String {
         
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
    
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
         
    }
    
}



