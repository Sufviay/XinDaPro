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
        lab.setCommentStyle(HCOLOR("#B9B9B9"), SFONT(14), .left)
        lab.text = "Account"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#B9B9B9"), SFONT(14), .left)
        lab.text = "Password"
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
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("#3A3A3A")
        //tf.placeholder = "Account"
        return tf
    }()
    
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.isSecureTextEntry = true
        tf.textColor = HCOLOR("#3A3A3A")
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
        lab.setCommentStyle(.white, BFONT(17), .left)
        lab.text = "Sign in"
        return lab
    }()
    
    

    
    private lazy var b_biew: LoginBottomView = {
        let view = LoginBottomView()
        
        view.clickBlock = { [unowned self] (type) in
            if type == "tk" {
                //MARK: -  Terms and Conditions
                print("Terms and Conditions")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Terms of Service"
                nextVC.webUrl = "http://deal.foodo2o.com/terms_of_service.html"
                self.present(nextVC, animated: true, completion: nil)
                
            }
            
            if type == "Privacy" {
                //MARK: - Privacy Policy
                print("Privacy Policy")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Privacy Policy"
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
            $0.width.equalTo(R_W(338))
            $0.height.equalTo(SET_H(260, 338))
        }
        
        view.addSubview(textImg)
        textImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(30))
            $0.top.equalTo(R_H(82))
        }
        
        
        view.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.top.equalTo(backImg.snp.bottom).offset(R_H(30))
        }
        
        view.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(backImg.snp.bottom).offset(105)
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
            $0.height.equalTo(38)
        }
        
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.equalTo(line2)
            $0.right.equalTo(line2.snp.right).offset(-70)
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(38)
        }
        
        view.addSubview(canSeeBut)
        canSeeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 30))
            $0.centerY.equalTo(passwordTF)
            $0.right.equalTo(line2)
        }
        
        view.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.top.equalTo(line2.snp.bottom).offset(R_H(70))
            $0.height.equalTo(55)
        }
        
        loginBut.addSubview(loginlab)
        loginlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
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
            HUD_MB.showWarnig("Please fill in your account number.", onView: self.view)
            return
        }
        
        if passwordTF.text == "" {
            HUD_MB.showWarnig("Please fill in your password.", onView: self.view)
            return
        }

        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLogIn(user: emailTF.text!, pw: passwordTF.text!).subscribe(onNext: { (json) in
            
            HUD_MB.showSuccess("Success!", onView: self.view)
            UserDefaults.standard.isLogin = true
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.userName = json["data"]["name"].stringValue
            UserDefaults.standard.userType = json["data"]["accountType"].stringValue
            UserDefaults.standard.userRole = json["data"]["accountTypeName"].stringValue
            UserDefaults.standard.accountNum = self.emailTF.text!
            UserDefaults.standard.storeLng = json["data"]["lng"].doubleValue
            UserDefaults.standard.storeLat = json["data"]["lat"].doubleValue
            UserDefaults.standard.userAuth = json["data"]["auth"].stringValue

            //上传tsToken
            let tsToken = UserDefaults.standard.tsToken ?? ""

            if tsToken != "" {
                HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
                    print("推送注册成功")
                    DispatchQueue.main.after(time: .now() + 1.5) {
                        self.navigationController?.setViewControllers([BossFirstController()], animated: false)
                    }
                }, onError: { (error) in
                    print("推送注册失败")
                }).disposed(by: self.bag)
            } else {
                DispatchQueue.main.after(time: .now() + 1.5) {
                    self.navigationController?.setViewControllers([BossFirstController()], animated: false)
                }
            }
            
            //上传语言
            HTTPTOOl.setLanguage().subscribe(onNext: { (json) in
                print("语言设置成功")
            }, onError: {_ in
                
            }).disposed(by: self.bag)
            
        }, onError: { (error) in
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
