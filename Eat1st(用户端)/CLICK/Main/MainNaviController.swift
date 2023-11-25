//
//  MainNaviController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import RxSwift

class MainNaviController: UINavigationController {
    
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BACKCOLOR

        
        
        //登录逻辑
        /**
         1.判断是否已经登陆
         2.登录后判断用户是否绑定过店铺
         绑定：进入店铺首页
         未绑定：进入店铺展示首页
         3.店铺列表展示页面判断地理位置信息
         有位置信息：展示数据
         没有位置信息：请求位置信息页面
        */
        
        
        /**
         
         1.如果是isLogin 判断是否有绑定的店铺
         有绑定的进入店铺主页
         没有绑定的进入店铺展示页
         2.如果是noLogin 进入店铺展示页
         
         */
        
        
        
        //self.setViewControllers([LogInController()], animated: false)
        
            self.setViewControllers([FirstController()], animated: false)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        handle = Auth.auth().addStateDidChangeListener({ auth, user in
//            print("监听状态")
//        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
//    //MARK: - 注册通知中心
//    private func addNotificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessAction), name: NSNotification.Name(rawValue: "loginSuccess"), object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(notificationLogoutAction), name: NSNotification.Name(rawValue: "logout"), object: nil)
//
//    }
//
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("loginSuccess"), object: nil)
////        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logout"), object: nil)
//    }
    
    
    
    
    //MARK: - 登录成功
    @objc private func loginSuccessAction() {
        checkUserBindingStore()
    }
    
    
    private func checkUserBindingStore() {
        //登录成功后 判断用户是否绑定过店铺
        HTTPTOOl.userBindingOrNot().subscribe(onNext: { (json) in
            let storID = json["data"]["storeId"].stringValue
            print(storID)
            if storID != "" {
                //已绑定
                let storeVC = StoreMainController()
                storeVC.storeID = storID
                self.setViewControllers([FirstController(), storeVC], animated: false)
            } else {
                self.setViewControllers([FirstController()], animated: true)
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
        }).disposed(by: bag)
    }
    

}
