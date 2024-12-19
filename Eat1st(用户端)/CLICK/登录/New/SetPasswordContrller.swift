//
//  SetPasswordContrller.swift
//  CLICK
//
//  Created by 肖扬 on 2023/12/8.
//

//import UIKit
//import SwiftyJSON
//import RxSwift
//import RxCocoa
//
//class SetPasswordContrller: BaseViewController, UITextFieldDelegate, SystemAlertProtocol {
//    
//    private let bag = DisposeBag()
//    
//    ///登陆成功后一些信息
//    var loginJsonData: JSON?
//    
//    var userPhone: String = ""
//    
//    private var pwHide: Bool = true {
//        didSet {
//            if pwHide {
//                hideBut1.setImage(LOIMG("login_hide"), for: .normal)
//            } else {
//                hideBut1.setImage(LOIMG("login_open"), for: .normal)
//            }
//            pwTF.isSecureTextEntry = pwHide
//        }
//    }
//    
//    private var rePWHide: Bool = true {
//        didSet {
//            if rePWHide {
//                hideBut2.setImage(LOIMG("login_hide"), for: .normal)
//            } else {
//                hideBut2.setImage(LOIMG("login_open"), for: .normal)
//            }
//            rePWTF.isSecureTextEntry = rePWHide
//        }
//    }
//    
//    
//
//    private let backBut: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("login_fanhui"), for: .normal)
//        return but
//    }()
//
//    
//    private let tlab1: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(28), .left)
//        lab.text = "Create Password"
//        return lab
//    }()
//    
//    private let tlab2: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FEC501"), SFONT(14), .left)
//        lab.numberOfLines = 0
//        lab.text = "You need to create a login password so that you can log in with your mobile number and password next time"
//        return lab
//    }()
//    
//    private let line1: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//    
//    
//    private let line2: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//    
//    
//    private lazy var pwTF: UITextField = {
//        let tf = UITextField()
//        tf.isSecureTextEntry = true
//        tf.font = BFONT(14)
//        tf.placeholder = "Please enter your password"
//        tf.textColor = HCOLOR("#333333")
//        tf.delegate = self
//        tf.tag = 1
//        return tf
//    }()
//    
//    
//    private lazy var rePWTF: UITextField = {
//        let tf = UITextField()
//        tf.isSecureTextEntry = true
//        tf.font = BFONT(14)
//        tf.placeholder = "Re-enter Password"
//        tf.textColor = HCOLOR("#333333")
//        tf.delegate = self
//        tf.tag = 2
//        return tf
//    }()
//
//    
//    private let hideBut1: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("login_hide"), for: .normal)
//        return but
//    }()
//    
//    private let hideBut2: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("login_hide"), for: .normal)
//        return but
//    }()
//
//
//    
//    
//    
//    private let nextBut: UIButton = {
//        let but = UIButton()
//        but.setCommentStyle(.zero, "Confirm", .white, BFONT(15), HCOLOR("#EBEBEB"))
//        but.clipsToBounds = true
//        but.layer.cornerRadius = 21
//        but.isEnabled = false
//        return but
//    }()
//    
//    
//    
//    override func setViews() {
//        setUpUI()
//    }
//    
//    func setUpUI() {
//        naviBar.isHidden = true
//        
//        view.addSubview(backBut)
//        backBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 50, height: 40))
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalToSuperview().offset(statusBarH + 2)
//        }
//        
//        view.addSubview(tlab1)
//        tlab1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(25)
//            $0.top.equalToSuperview().offset(statusBarH + R_H(95))
//        }
//        
//        view.addSubview(tlab2)
//        tlab2.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(25)
//            $0.top.equalTo(tlab1.snp.bottom).offset(5)
//            $0.right.equalToSuperview().offset(-25)
//        }
//
//
//        view.addSubview(line1)
//        line1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(25)
//            $0.right.equalToSuperview().offset(-25)
//            $0.height.equalTo(0.5)
//            $0.top.equalToSuperview().offset(statusBarH + R_H(250))
//        }
//        
//        
//        view.addSubview(line2)
//        line2.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line1.snp.bottom).offset(50)
//        }
//        
//        view.addSubview(nextBut)
//        nextBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(25)
//            $0.right.equalToSuperview().offset(-25)
//            $0.height.equalTo(42)
//            $0.top.equalTo(line2.snp.bottom).offset(55)
//        }
//        
//        view.addSubview(hideBut1)
//        hideBut1.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 50, height: 40))
//            $0.bottom.equalTo(line1.snp.top)
//            $0.right.equalToSuperview().offset(-15)
//        }
//        
//        view.addSubview(hideBut2)
//        hideBut2.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 50, height: 40))
//            $0.bottom.equalTo(line2.snp.top)
//            $0.right.equalToSuperview().offset(-15)
//        }
//        
//        view.addSubview(pwTF)
//        pwTF.snp.makeConstraints {
//            $0.height.equalTo(40)
//            $0.left.equalToSuperview().offset(25)
//            $0.bottom.equalTo(line1.snp.top)
//            $0.right.equalTo(hideBut1.snp.left).offset(-5)
//        }
//        
//        view.addSubview(rePWTF)
//        rePWTF.snp.makeConstraints {
//            $0.height.equalTo(40)
//            $0.left.equalToSuperview().offset(25)
//            $0.bottom.equalTo(line2.snp.top)
//            $0.right.equalTo(hideBut2.snp.left).offset(-5)
//        }
//        
//
//        
//        pwTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
//            
//            if str != "" && rePWTF.text ?? "" != "" {
//                nextBut.isEnabled = true
//                nextBut.backgroundColor = MAINCOLOR
//            } else {
//                nextBut.isEnabled = false
//                nextBut.backgroundColor = HCOLOR("EBEBEB")
//            }
//            
//            if str.length > 15 {
//                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
//                pwTF.text = str.substring(to: 15)
//            }
//            
//            
//        }).disposed(by: bag)
//        
//        rePWTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
//            if str != "" && pwTF.text ?? "" != "" {
//                nextBut.isEnabled = true
//                nextBut.backgroundColor = MAINCOLOR
//            } else {
//                nextBut.isEnabled = false
//                nextBut.backgroundColor = HCOLOR("EBEBEB")
//            }
//            
//            if str.length > 15 {
//                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
//                rePWTF.text = str.substring(to: 15)
//            }
//
//        }).disposed(by: bag)
//
//        
//        
//        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
//        hideBut1.addTarget(self, action: #selector(clickPWHideAction), for: .touchUpInside)
//        hideBut2.addTarget(self, action: #selector(clickRePWHideAction), for: .touchUpInside)
//        nextBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
//    }
//    
//    
//    @objc private func clickBackAction() {
//        //返回 需要给提示 返回代表放弃设置支付密码 且放弃登陆操作
//        showSystemChooseAlert("Tips", "You need to create a password for the next login using the mobile number and password.", "return", "Go on") { [unowned self] in
//            UserDefaults.standard.removeObject(forKey: "token")
//            dismiss(animated: true)
//        }
//    }
//    
//    @objc private func clickPWHideAction() {
//        pwHide = !pwHide
//    }
//    
//    @objc private func clickRePWHideAction() {
//        rePWHide = !rePWHide
//    }
//    
//    
//    @objc private func clickConfirmAction() {
//        //点击设置密码。密码仅限制位数 6-15位
//        if (pwTF.text ?? "").length < 6 {
//            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
//            return
//        }
//        
//        if (pwTF.text ?? "") != (rePWTF.text ?? "") {
//            HUD_MB.showWarnig("The two password entries are inconsistent.", onView: view)
//            return
//        }
//        setPWDAction_Net()
//    }
//    
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //不能输入空格
//        if string == " " {
//            return false
//        }
//        return true
//    }
//    
//    
//    //MARK: - 网络请求
//    private func setPWDAction_Net() {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.setLoginPWD(pwd: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (_) in
//            HUD_MB.showSuccess("Success!", onView: view)
//            
//            //进行登录操作
//            UserDefaults.standard.isLogin = true
//            UserDefaults.standard.userPhone = userPhone
//            NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
//            
//            ///1 否 2 是
//            let isNewUser = loginJsonData!["data"]["newType"].stringValue == "2" ? true : false
//            
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
//                if isNewUser {
//                    let infoVC = PersonalInfoController()
//                    infoVC.isCanEdite = true
//                    navigationController?.pushViewController(infoVC, animated: true)
//                } else {
//                    self.dismiss(animated: true)
//                }
//            }
//            
//            //获取用户信息
//            HTTPTOOl.getUserInfo().subscribe(onNext: { (json) in
//                UserDefaults.standard.userName = json["data"]["name"].stringValue
//                UserDefaults.standard.userEmail = json["data"]["email"].stringValue
//                
//            }).disposed(by: bag)
//            
//            //上传tsToken
//            let tsToken = UserDefaults.standard.tsToken ?? ""
//
//            if tsToken != "" {
//                HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
//                    print("推送注册成功")
//                }, onError: { (error) in
//                    print("推送注册失败")
//                }).disposed(by: bag)
//            }
//
//            //上传语言
//            HTTPTOOl.setLanguage().subscribe(onNext: { (json) in
//                print("语言设置成功")
//            }, onError: {_ in
//                
//            }).disposed(by: self.bag)
//
//            
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//        }).disposed(by: bag)
//    }
//
//}
