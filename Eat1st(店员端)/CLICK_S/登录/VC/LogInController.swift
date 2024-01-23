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
        img.image = LOIMG("loginbg")
        img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#262628"), BFONT(30), .left)
        lab.text = "Sign In"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#9B9B9B"), BFONT(15), .left)
        lab.text = "Account"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#9B9B9B"), BFONT(15), .left)
        lab.text = "Password"
        return lab
    }()
    
    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 25
        return view
    }()

    
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("#262628")
        tf.placeholder = "Please enter the account number"
        tf.text = UserDefaults.standard.accountNum ?? ""
        return tf
    }()
    
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.isSecureTextEntry = true
        tf.textColor = HCOLOR("#262628")
        tf.placeholder = "Please enter password"
        return tf
    }()
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "SIGN IN", .white, BFONT(15), HCOLOR("#212121"))
        but.layer.cornerRadius = 15
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
        
        view.backgroundColor = MAINCOLOR
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(R_H(80))
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-0)
            $0.bottom.equalToSuperview().offset(-R_H(65))
        }
        
        
        backImg.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.top.equalToSuperview().offset(40)
        }
        
        
        backImg.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.top.equalTo(titLab.snp.bottom).offset(40)
        }
        
        backImg.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.top.equalTo(tlab1.snp.bottom).offset(85)
        }
        
        
        backImg.addSubview(view1)
        view1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-35)
            $0.top.equalTo(tlab1.snp.bottom).offset(12)
            $0.height.equalTo(50)
        }
        
        backImg.addSubview(view2)
        view2.snp.makeConstraints {
            $0.left.right.height.equalTo(view1)
            $0.top.equalTo(tlab2.snp.bottom).offset(12)
        }
        
        
        view1.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.top.equalToSuperview()
        }
        
        view2.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.top.equalToSuperview()
        }
        
        
        backImg.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(view1)
            $0.top.equalTo(view2.snp.bottom).offset(75)
            $0.height.equalTo(50)
        }

        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)
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
        HTTPTOOl.userLogIn(user: emailTF.text!, pw: passwordTF.text!).subscribe(onNext: { [unowned self] (json) in
    
            HUD_MB.showSuccess("Success", onView: view)
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.accountNum = self.emailTF.text!
            UserDefaults.standard.isLogin = true
            UserDefaults.standard.userName = json["data"]["name"].stringValue
            UserDefaults.standard.userID = json["data"]["businessId"].stringValue
            
            let nextVC = DeskListController()
            self.navigationController?.setViewControllers([nextVC], animated: true)

        }, onError: {[unowned self]  (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }

    
    //MARK: - 忘记密码
    @objc private func clickForgetPwAciton() {
        
    }
    
    //MARK: - 联系我们
    @objc private func clickContactAction() {
        
    }
    
    deinit {
        print("\(self.classForCoder) 销毁")
    }

    
}
