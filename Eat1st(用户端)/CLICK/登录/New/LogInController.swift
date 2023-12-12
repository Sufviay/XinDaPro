//
//  LogInController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/9/26.
//

import UIKit
import RxSwift
import RxCocoa

class LogInController: BaseViewController, UITextFieldDelegate, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var countryList: [CountryModel] = []
    
    private var countryCode: String = ""
    private var areaCode: String = "" {
        didSet {
            areaNumLab.text = areaCode
        }
    }
    
    
    
    private var pwHide: Bool = true {
        didSet {
            if pwHide {
                hideBut.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut.setImage(LOIMG("login_open"), for: .normal)
            }
            pwTF.isSecureTextEntry = pwHide
        }
    }
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_back")
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let welcomeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("welcome")
        return img
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: (S_H - SET_H(220, 375)) + 25), byRoundingCorners: [.topLeft, .topRight], radii: 24)
        return view
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_fanhui 1"), for: .normal)
        return but
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(22), .left)
        lab.text = "PHONE NUMBER"
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Login", .white, BFONT(15), HCOLOR("#EBEBEB"))
        but.clipsToBounds = true
        but.layer.cornerRadius = 21
        but.isEnabled = false
        return but
    }()
    
    private let areaBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    
    private lazy var numberTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.placeholder = "Please enter the phone number"
        tf.keyboardType = .numberPad
        tf.textColor = HCOLOR("#333333")
        return tf
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private lazy var pwTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.placeholder = "Please enter your password"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()

    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let hideBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
    }()
    
    
    private let areaNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(14), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_xl")
        return img
    }()
    
    
    private let forgetBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let forgetLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(11), .center)
        lab.text = "Forgot Password ?"
        return lab
    }()
    
    private let line6: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    
    
    private let otherLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .center)
        lab.text = "Other"
        return lab
    }()
    
    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EFEFEF")
        return view
    }()
    
    private let line5: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EFEFEF")
        return view
    }()

    
    
    
    private lazy var xyView: LoginBottomView = {
        let tview = LoginBottomView()
        
        tview.clickBlock = { [unowned self] (str) in
            if str == "ys" {
                print("ys")
                
                let webVC = ServiceController()
                webVC.titStr = "Privacy Policy"
                webVC.webUrl = "http://deal.foodo2o.com/privacy_policy.html"
                self.present(webVC, animated: true, completion: nil)
            }
            
            if str == "fw" {
                print("fw")
                
                let webVC = ServiceController()
                webVC.titStr = "Terms of Service"
                webVC.webUrl = "http://deal.foodo2o.com/terms_of_service.html"
                self.present(webVC, animated: true, completion: nil)
            }
        }
        
        return tview
        
    }()
    
    
    
    private let phoneBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_phone"), for: .normal)
        return but
    }()

    
    private let faceBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("facebook"), for: .normal)
        return but
    }()
    
    
    private let googleBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("google"), for: .normal)
        return but
    }()
    
    private let twitterBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("twitter"), for: .normal)
        return but
    }()
    
    
    private lazy var areaAlert: AreaAlert = {
        let alert = AreaAlert()
        
        alert.clickCountryBlock = { [unowned self] (model) in
            areaNumLab.text = (model as! CountryModel).areaCode
            areaCode = (model as! CountryModel).areaCode
            countryCode = (model as! CountryModel).countryCode
            
        }
        
        return alert
    }()
    
    
    
    override func setViews() {
        setUpUI()
        loadCountryList_Net()
    }
    
    
    private func setUpUI() {
        naviBar.isHidden = true
    
    
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(SET_H(220, 375))
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo((S_H - SET_H(220, 375)) + 25)
        }
        
        
        view.addSubview(welcomeImg)
        welcomeImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(backView.snp.top).offset(-R_H(35))
            $0.size.equalTo(CGSize(width: R_W(250), height: SET_H(26, 250)))
        }

        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(R_H(40))
        }
        
        tlab.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(R_H(250))
            $0.height.equalTo(42)
        }
        
        
        backView.addSubview(numberTF)
        numberTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(95)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(R_H(100))
        }
        
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.equalTo(numberTF)
            $0.height.equalTo(0.5)
            $0.top.equalTo(numberTF.snp.bottom)
        }
        
        
        backView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(0.5)
            $0.top.equalTo(line2.snp.bottom).offset(55)
        }
        
        backView.addSubview(hideBut)
        hideBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 50))
            $0.bottom.equalTo(line3.snp.top)
            $0.right.equalToSuperview().offset(-20)
        }

        
        backView.addSubview(pwTF)
        pwTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(line3.snp.top)
            $0.height.equalTo(40)
            $0.right.equalTo(hideBut.snp.left).offset(-15)
        }
        
        
        backView.addSubview(areaBut)
        areaBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(numberTF.snp.left).offset(-10)
            $0.height.equalTo(60)
            $0.centerY.equalTo(numberTF)
        }
        
        areaBut.addSubview(areaNumLab)
        areaNumLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        areaBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(forgetBut)
        forgetBut.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 30))
            $0.top.equalTo(nextBut.snp.bottom).offset(5)
        }
        
        forgetBut.addSubview(forgetLab)
        forgetLab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        forgetBut.addSubview(line6)
        line6.snp.makeConstraints {
            $0.width.equalTo(forgetLab)
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(forgetLab)
        }
        
        
        backView.addSubview(xyView)
        xyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 280, height: 30))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(otherLab)
        otherLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nextBut.snp.bottom).offset(R_H(74))
        }
        
        backView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(75), height: 1))
            $0.centerY.equalTo(otherLab)
            $0.right.equalTo(otherLab.snp.left).offset(-15)
        }
        
        backView.addSubview(line5)
        line5.snp.makeConstraints {
            $0.size.centerY.equalTo(line4)
            $0.left.equalTo(otherLab.snp.right).offset(15)
        }
        
        backView.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(otherLab.snp.bottom).offset(20)
        }

//        backView.addSubview(googleBut)
//        googleBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 30, height: 30))
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(otherLab.snp.bottom).offset(20)
//        }
//
//        backView.addSubview(faceBut)
//        faceBut.snp.makeConstraints {
//            $0.size.centerY.equalTo(googleBut)
//            $0.right.equalTo(googleBut.snp.left).offset(-40)
//        }
//
//        backView.addSubview(twitterBut)
//        twitterBut.snp.makeConstraints {
//            $0.size.centerY.equalTo(googleBut)
//            $0.left.equalTo(googleBut.snp.right).offset(40)
//        }
//
        
        numberTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            
            if str != "" && pwTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }
                
        }).disposed(by: bag)
        
        pwTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" && numberTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }
            
            if str.length > 15 {
                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
                pwTF.text = str.substring(to: 15)
            }

        }).disposed(by: bag)
        
        
        faceBut.addTarget(self, action: #selector(clickFaceAction), for: .touchUpInside)
        googleBut.addTarget(self, action: #selector(clickGoogleAction), for: .touchUpInside)
        twitterBut.addTarget(self, action: #selector(clickTwitterAction), for: .touchUpInside)
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        hideBut.addTarget(self, action: #selector(clickHideAction), for: .touchUpInside)
        forgetBut.addTarget(self, action: #selector(clickForgetAction), for: .touchUpInside)
        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        
    }
    
    @objc private func clickBackAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func clickHideAction() {
        //密码是否可见
        pwHide = !pwHide
    }
    
    @objc private func clickForgetAction() {
        //忘记密码
        let nextVC = FindPasswordController()
        nextVC.areaCode = areaCode
        nextVC.countryCode = countryCode
        nextVC.countryList = countryList
        nextVC.phoneNum = numberTF.text ?? ""
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func clickPhoneAction() {
        //手机验证码登陆
        let nextVC = PhoneLoginController()
        nextVC.areaCode = areaCode
        nextVC.countryCode = countryCode
        nextVC.countryList = countryList
        nextVC.phoneNum = numberTF.text ?? ""
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    @objc private func clickFaceAction() {
        
    }
    
    @objc private func clickGoogleAction() {
        
    }
    
    @objc private func clickTwitterAction() {
        
    }

    
    @objc private func clickAreaAction(sender: UIButton) {
        print(sender.frame)
        areaAlert.tap_H = sender.frame.maxY + SET_H(220, 375) - 25
        areaAlert.appearAction()
    }
    

    
    @objc private func clickNextAction() {
        if (pwTF.text ?? "").length < 6 {
            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
            return
        }
        loginPWD_Net()
    }

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //不能输入空格
        if string == " " {
            return false
        }
        return true
    }
    
    
    //MARK: - 网络请求
    private func loginPWD_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loginPWD(countryCode: countryCode, phone: numberTF.text!, pwd: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.showSuccess("Success", onView: view)
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.isLogin = true
            UserDefaults.standard.userPhone = numberTF.text!
            NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            
            DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                dismiss(animated: true)
            }
            
            //获取用户信息
            HTTPTOOl.getUserInfo().subscribe(onNext: { (json) in
                UserDefaults.standard.userName = json["data"]["name"].stringValue
                UserDefaults.standard.userEmail = json["data"]["email"].stringValue
                
            }).disposed(by: bag)
            
            //上传tsToken
            let tsToken = UserDefaults.standard.tsToken ?? ""

            if tsToken != "" {
                HTTPTOOl.updateTSToken(token: tsToken).subscribe(onNext: { (json) in
                    print("推送注册成功")
                }, onError: { (error) in
                    print("推送注册失败")
                }).disposed(by: bag)
            }

            //上传语言
            HTTPTOOl.setLanguage().subscribe(onNext: { (json) in
                print("语言设置成功")
            }, onError: {_ in
                
            }).disposed(by: self.bag)
            
        }, onError: { [unowned self] (error) in
            
            if (error as! NetworkError) == .errorCode11 || (error as! NetworkError) == .errorCode12 {
                
                var msg = ""
                
                if error as! NetworkError == .errorCode11 {
                    msg = "Mobile number is not registered, please go to the verification code login."
                }
                if error as! NetworkError == .errorCode12 {
                    msg = "No password has been set, please go to the verification code login."
                }
                
                //跳到手机验证码页面进行登录
                showSystemChooseAlert("Tips", msg, "Go", "Cancel") { [unowned self] in
                    let nextVC = PhoneLoginController()
                    nextVC.areaCode = areaCode
                    nextVC.countryCode = countryCode
                    nextVC.countryList = countryList
                    nextVC.phoneNum = numberTF.text ?? ""
                    navigationController?.pushViewController(nextVC, animated: true)
                }
                
            } else {
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }
            
        }).disposed(by: bag)
    }
    

    
    
    func loadCountryList_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getCountryList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tarr: [CountryModel] = []
            for jsondata in json["data"].arrayValue {
                let model = CountryModel()
                model.updateModel(json: jsondata)
                tarr.append(model)
            }
            
            countryList = tarr
            areaAlert.dataArr = countryList

            //获取当前国家Code
            if let curCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                print(curCode)
                
                let arr = countryList.filter { $0.countryCode == curCode }
                
                if arr.count == 0 {
                    countryCode = countryList.first?.countryCode ?? ""
                    areaCode = countryList.first?.areaCode ?? ""
                } else {
                    countryCode = arr.first?.countryCode ?? ""
                    areaCode = arr.first?.areaCode ?? ""
                }
                
            } else {
                countryCode = countryList.first?.countryCode ?? ""
                areaCode = countryList.first?.areaCode ?? ""
            }
            
        }, onError: { [unowned self] (error) in
            countryCode = "GB"
            areaCode = "+44"
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

}
