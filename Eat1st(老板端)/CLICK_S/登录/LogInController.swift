//
//  LogInController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import RxSwift

class LogInController: BaseViewController {
    
    
    private let bag = DisposeBag()

    private var isShow: Bool = true
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_back")
        img.contentMode = .scaleToFill
        return img
    }()
    
    
    private let textImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_text")
        img.contentMode = .scaleToFill
        return img
    }()

    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_14, .left)
        lab.text = "Account".local
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_14, .left)
        lab.text = "Password".local
        return lab
    }()

    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        return view
    }()
    
    private let canSeeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
    }()

    
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = TIT_14
        tf.textColor = TXTCOLOR_1
        tf.text = UserDefaults.standard.accountNum ?? ""
        //tf.placeholder = "Account"
        return tf
    }()
    
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = TIT_14
        tf.isSecureTextEntry = true
        tf.textColor = TXTCOLOR_1
        //tf.placeholder = "Password"
        return tf
    }()
    
    
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_but"), for: .normal)
        return but
    }()
    
    private let loginlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_16, .left)
        lab.text = "Sign in".local
        return lab
    }()
    
    

    
    private lazy var b_biew: LoginBottomView = {
        let view = LoginBottomView()
        
        view.clickBlock = { [unowned self] (type) in
            if type == "tk" {
                //MARK: -  Terms and Conditions
                print("Terms and Conditions")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Terms of Service".local
                nextVC.webUrl = "http://deal.foodo2o.com/terms_of_service.html"
                self.present(nextVC, animated: true, completion: nil)
                
            }
            
            if type == "Privacy" {
                //MARK: - Privacy Policy
                print("Privacy Policy")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Privacy Policy".local
                nextVC.webUrl = "http://deal.foodo2o.com/privacy_policy.html"
                self.present(nextVC, animated: true, completion: nil)
            }
        }
        return view
    }()
    
    
    
    override func setViews() {
        self.naviBar.isHidden = true
        self.setUpUI()
        
    }
    
    private func setUpUI() {
        
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                $0.width.equalToSuperview().multipliedBy(0.5)
                
            } else {
                $0.width.equalTo(R_W(338))
            }
            
            $0.height.equalTo(backImg.snp.width).multipliedBy(D_2(260 / 338))
        }
        
        
        backImg.addSubview(textImg)
        textImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.equalToSuperview().multipliedBy(D_2(178 / 338))
            $0.height.equalTo(textImg.snp.width).multipliedBy(D_2(55 / 178))
        }
        
        
        view.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                $0.top.equalTo(textImg.snp.bottom).offset(R_H(150))
            } else {
                $0.top.equalTo(backImg.snp.bottom).offset(R_H(30))
            }
        }
        
        view.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(tlab1.snp.bottom).offset(60)
            //$0.top.equalTo(backImg.snp.bottom).offset(105)
        }
        
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalTo(tlab1.snp.bottom).offset(40)
            $0.height.equalTo(1)
        }
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalTo(tlab2.snp.bottom).offset(40)
            $0.height.equalTo(1)
        }
        
        
        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(40)
        }
        
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.equalTo(line2)
            $0.right.equalTo(line2.snp.right).offset(-70)
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(40)
        }
        
        view.addSubview(canSeeBut)
        canSeeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalTo(passwordTF)
            $0.right.equalTo(line2)
        }
        
        view.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 280, height: 55))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(line2.snp.bottom).offset(R_H(70))
        }
        
        loginBut.addSubview(loginlab)
        loginlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        
        view.addSubview(b_biew)
        b_biew.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.equalTo(280)
        }
        

    
        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)
        canSeeBut.addTarget(self, action: #selector(hidePasswordAction), for: .touchUpInside)

    }
    
    
    
    //MARK: - 登录
    @objc private func clickLogInAction() {
        print("login")
        
        if emailTF.text == "" {
            HUD_MB.showWarnig("Please fill in your account number.".local, onView: self.view)
            return
        }
        
        if passwordTF.text == "" {
            HUD_MB.showWarnig("Please fill in your password.".local, onView: self.view)
            return
        }

        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLogIn(user: emailTF.text!, pw: passwordTF.text!).subscribe(onNext: { [unowned self] (json) in
            
            UserDefaults.standard.accountNum = emailTF.text!
            
            ///0销售 1老板
            let accoutType = json["data"]["accountType"].stringValue
            if accoutType == "0" {
                //销售 直接登录
                HUD_MB.showSuccess("Success".local, onView: view)
                UserDefaults.standard.token = json["data"]["token"].stringValue
                UserDefaults.standard.userName = json["data"]["name"].stringValue
                UserDefaults.standard.userRole = json["data"]["accountType"].stringValue
                UserDefaults.standard.isLogin = true
                UserDefaults.standard.loginDate = Date().getString("yyyy-MM-dd HH:mm:ss")
                DispatchQueue.main.after(time: .now() + 1) {
                    self.navigationController?.setViewControllers([SalesFirstController()], animated: false)
                }
                
            } else {
                //老板
                var tarr: [StoreModel] = []

                for jsonData in json["data"]["storeList"].arrayValue {
                    let model = StoreModel()
                    model.updateModel(json: jsonData)
                    tarr.append(model)
                }
                
                if tarr.count == 1 {
                    //只有一個直接登錄
                    HUD_MB.showSuccess("Success".local, onView: view)
                    UserDefaults.standard.token = json["data"]["token"].stringValue
                    UserDefaults.standard.userName = json["data"]["name"].stringValue
                    UserDefaults.standard.userRole = json["data"]["accountType"].stringValue
                    UserDefaults.standard.storeName = tarr.first?.storeName
                    UserDefaults.standard.userAuth = tarr.first?.auth
                    UserDefaults.standard.storeID = tarr.first?.storeId
                    UserDefaults.standard.isLogin = true
                    UserDefaults.standard.loginDate = Date().getString("yyyy-MM-dd HH:mm:ss")
                    
                    DispatchQueue.main.after(time: .now() + 1) {
                        self.navigationController?.setViewControllers([BossFirstController()], animated: false)
                    }

                } else if tarr.count == 0 {
                    HUD_MB.showWarnig("You do not have the permission for store.".local, onView: view)
                } else {
                    //登錄成功
                    HUD_MB.dissmiss(onView: view)
                    let nextVC = StoreListController()
                    nextVC.dataArr = tarr
                    nextVC.isLogin = true
                    nextVC.logininfo = json
                    navigationController?.pushViewController(nextVC, animated: true)
                }

            }
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }

    
    //MARK: - 忘记密码
    @objc private func clickForgetPwAciton() {
        
    }
    
    //MARK: - 联系我们
    @objc private func clickContactAction() {
        
    }
    
    //MARK: - 隐藏密码
    @objc private func hidePasswordAction() {
        
        isShow = !isShow
        self.passwordTF.isSecureTextEntry = isShow
        if isShow {
            self.canSeeBut.setImage(LOIMG("login_hide"), for: .normal)
        } else {
            self.canSeeBut.setImage(LOIMG("login_show"), for: .normal)
        }
        
    }
    
    

}

