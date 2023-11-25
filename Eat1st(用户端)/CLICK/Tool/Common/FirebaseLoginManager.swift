//
//  FirebaseLoginManager.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/24.
//

import Foundation

import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI
import RxSwift

//import FirebaseFacebookAuthUI
//import FirebaseEmailAuthUI
//import FirebaseGoogleAuthUI

class FirebaseLoginManager: NSObject, FUIAuthDelegate {


    private let bag = DisposeBag()
    
    let authUI = FUIAuth.defaultAuthUI()

    static let shared = FirebaseLoginManager()
    
    private var successBlock: (()-> Void)?
    private var failBlock: ((String)-> Void)?
    
    
    private var isFirstLoginBack: Bool = true


    func doLogin(success: @escaping () -> Void) {
        
        isFirstLoginBack = true
        
        self.successBlock = success

        authUI?.delegate = self
        
        var providers: [FUIAuthProvider] = []
        
        
        if ISONLINE && ENV == "1" {
            providers = [FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
        } else {
            providers = [FUIEmailAuth(), FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
        }
                
//        if #available(iOS 13.0, *) {
//            providers = [FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
//        } else {
//            providers = [FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
//        }
        
        self.authUI?.providers = providers
        self.authUI?.shouldHideCancelButton = true
        
//        self.authUI?.tosurl = URL(string: "https://www.baidu.com")
//        self.authUI?.privacyPolicyURL = URL(string: "https://www.baidu.com")
        
        guard let authViewController = authUI?.authViewController() else { return }
        
        authViewController.modalPresentationStyle = .fullScreen
        PJCUtil.currentVC()?.present(authViewController, animated: true, completion: nil)
    
    }
    
    
    
//    func setLoginController(success: @escaping () -> Void) -> UIViewController? {
//
//        self.successBlock = success
//
//
//        authUI?.delegate = self
//
//        var providers: [FUIAuthProvider] = []
//
//        if #available(iOS 13.0, *) {
//            providers = [FUIEmailAuth(), FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)] //FUIOAuth.appleAuthProvider()
//        } else {
//            providers = [FUIEmailAuth(), FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
//        }
//
//        self.authUI?.providers = providers
//        self.authUI?.shouldHideCancelButton = true
//
//
//        self.authUI?.tosurl = nil
//        self.authUI?.privacyPolicyURL = nil
//        guard let authViewController = authUI?.authViewController() else { return nil }
//
//
//
//        return authViewController
//
//    }
//


    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CustomLoginController(authUI: authUI)
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //登录成功
        if error != nil {
            return
        }
        if authDataResult == nil {
            return
        }
        
        
        if isFirstLoginBack {
            isFirstLoginBack = false
            let cUser = authDataResult!.user
            let addUser = authDataResult!.additionalUserInfo
            
            UserDefaults.standard.userName = cUser.displayName
            UserDefaults.standard.userEmail = cUser.email
            UserDefaults.standard.userPhone = cUser.phoneNumber
            
            let isNewUser = addUser!.isNewUser
            
            
            cUser.getIDToken { token, error in

                if error != nil {
                    HUD_MB.showError(error?.localizedDescription ?? "", onView: PJCUtil.getWindowView())
                    return
                }
                
                guard let idtoken = token else {return}
                
                HUD_MB.loading("", onView: PJCUtil.getWindowView())
                
                HTTPTOOl.userLogIn(id: idtoken).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                    UserDefaults.standard.isLogin = true
                    UserDefaults.standard.token = json["data"].stringValue
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
                    self.successBlock?()
                    
                                        
                    //获取用户信息
                    HTTPTOOl.getUserInfo().subscribe(onNext: { (json) in
                        let name = json["data"]["name"].stringValue
                        if name != "" {
                            UserDefaults.standard.userName = name
                        }
                        
                    }).disposed(by: self.bag)
                    
            
                    //上传tsToken
                    let tsToken = UserDefaults.standard.tsToken ?? ""

                    if tsToken != "" {
                        HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
                            print("推送注册成功")
                        }, onError: { (error) in
                            print("推送注册失败")
                        }).disposed(by: self.bag)
                    }



                    //上传语言
                    HTTPTOOl.setLanguage().subscribe(onNext: { (json) in
                        print("语言设置成功")
                    }, onError: {_ in
                        
                    }).disposed(by: self.bag)
                    
                    
                    //如果是新用户进入用户信息编辑
                    if isNewUser {
                        let infoVC = PersonalInfoController()
                        infoVC.isCanEdite = true
                        PJCUtil.currentVC()?.present(infoVC, animated: true)
                    }
                    
//                    //查看是否有新的消息
//                    HTTPTOOl.getMessagesList(page: 1).subscribe(onNext: { (json) in
//
//                        for jsonData in json["data"].arrayValue {
//                            if jsonData["readType"].stringValue == "1" {
//                                //有未读消息展示消息弹窗
//                                let model = MessageModel()
//                                model.updateModel(json: jsonData)
//                                let alert = MessageAlert()
//                                alert.messageModel = model
//                                alert.appearAction()
//                                break
//                            }
//                        }
//
//                    }).disposed(by: self.bag)


                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
                }, onCompleted: {
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                }).disposed(by: self.bag)
            }
        }
        //self.isFirstLoginBack = false
    }
    
    
    
//    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//      // handle user and error as necessary
//
//        //登录成功
//        if error != nil {
//            return
//        }
//
//        guard let reUser = user  else {return}
//
//
//        reUser.getIDToken { token, error in
//
//            if error != nil {
//                HUD_MB.showError(error?.localizedDescription ?? "", onView: PJCUtil.getWindowView())
//                return
//            }
//
//            guard let idtoken = token else {return}
//
//            HUD_MB.loading("", onView: PJCUtil.getWindowView())
//
//            HTTPTOOl.userLogIn(id: idtoken).subscribe(onNext: { (json) in
//                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
//                UserDefaults.standard.isLogin = true
//                UserDefaults.standard.token = json["data"].stringValue
//
//                //上传tsToken
//                let tsToken = UserDefaults.standard.tsToken ?? ""
//
//                if tsToken != "" {
//                    HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
//                        print("推送注册成功")
//                    }, onError: { (error) in
//                        print("推送注册失败")
//                    }).disposed(by: self.bag)
//                }
//
//                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
//                self.successBlock?()
//
//                //上传语言
//                HTTPTOOl.setLanguage().subscribe(onNext: { (json) in
//                    print("语言设置成功")
//                }, onError: {_ in
//
//                }).disposed(by: self.bag)
//
//            }, onError: { (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
//            }, onCompleted: {
//                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
//            }).disposed(by: self.bag)
//        }
//    }
    
    
    func doLogout() {
        do {
            try self.authUI?.signOut()
        } catch {
            print(error)
        }
    }
}



