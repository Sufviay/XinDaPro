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
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("log_backimg")
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let titImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("hello")
        return img
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(15)
        tf.textColor = FONTCOLOR
        tf.placeholder = "Account"
        return tf
    }()
    
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(15)
        tf.isSecureTextEntry = true
        tf.textColor = FONTCOLOR
        tf.placeholder = "Password"
        return tf
    }()
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Login", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    private let forgetPwBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Forgot password？", HCOLOR("999999"), SFONT(14), .clear)
        but.isHidden = true
        return but
    }()

    
    private let t_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(14), .center)
        lab.text = "Not registered yet?"
        lab.isHidden = true
        return lab
    }()
    
    private let contactBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Contact us", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 19
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        but.isHidden = true
        return but
        
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
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(titImg)
        titImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(statusBarH + R_H(60))
            $0.width.equalTo(193)
            $0.height.equalTo(SET_H(62, 193))
        }
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.top.equalToSuperview().offset(statusBarH + R_H(210))
            $0.height.equalTo(1)
        }
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.top.equalTo(line1.snp.bottom).offset(R_H(70))
            $0.height.equalTo(1)
        }
        
        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(50)
        }
        
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.right.equalTo(line2)
            $0.bottom.equalTo(line2.snp.top)
            $0.height.equalTo(50)
        }
        
        view.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.top.equalTo(line2.snp.bottom).offset(R_H(44))
            $0.height.equalTo(45)
        }
        
        view.addSubview(forgetPwBut)
        forgetPwBut.snp.makeConstraints {
            $0.left.equalTo(line1)
            $0.top.equalTo(loginBut.snp.bottom).offset(14)
        }
        


        view.addSubview(t_lab)
        t_lab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginBut.snp.bottom).offset(75)
        }
        
        view.addSubview(contactBut)
        contactBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 170, height: 38))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(t_lab.snp.bottom).offset(15)
        }
        
        view.addSubview(b_biew)
        b_biew.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.equalTo(280)
        }
        

    
        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)
        forgetPwBut.addTarget(self, action: #selector(clickForgetPwAciton), for: .touchUpInside)
        contactBut.addTarget(self, action: #selector(clickContactAction), for: .touchUpInside)

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
//            UserDefaults.standard.userType = json["data"]["accountType"].stringValue
            UserDefaults.standard.userRole = json["data"]["accountTypeName"].stringValue
            UserDefaults.standard.accountNum = self.emailTF.text!
//            UserDefaults.standard.storeLng = json["data"]["lng"].doubleValue
//            UserDefaults.standard.storeLat = json["data"]["lat"].doubleValue

            //上传tsToken
            let tsToken = UserDefaults.standard.tsToken ?? ""

            if tsToken != "" {
                HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
                    print("推送注册成功")
                    DispatchQueue.main.after(time: .now() + 1.5) {
                        self.navigationController?.setViewControllers([FirstController()], animated: false)
                    }
                }, onError: { (error) in
                    print("推送注册失败")
                }).disposed(by: self.bag)
            } else {
                DispatchQueue.main.after(time: .now() + 1.5) {
                    self.navigationController?.setViewControllers([FirstController()], animated: false)
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
    
}
