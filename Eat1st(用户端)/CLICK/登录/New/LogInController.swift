//
//  LogInController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/9/26.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

enum LoginMode {
    case PHONE
    case EMAIL
}


class LogInController: BaseViewController, UITextFieldDelegate, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var countryList: [CountryModel] = []
    
    private var countryCode: String = ""
    
    private var areaCode: String = "" {
        didSet {
            areaNumLab.text = "+\(areaCode)"
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
    
    private var loginWay: LoginMode = .EMAIL

    
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
    
    private let yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 75), byRoundingCorners: [.topLeft, .topRight], radii: 17)
        return view
    }()
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: (S_H - SET_H(220, 375)) - 30), byRoundingCorners: [.topLeft, .topRight], radii: 15)
        return view
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_fanhui 1"), for: .normal)
        return but
    }()
    
    
    private let leftBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    

    private let rightBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()

    
    private let leftImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        let m = LOIMG("left")
        m.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        img.image = m
        return img
    }()
    
    private let rightImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        let m = LOIMG("right")
        m.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        img.image = m
        img.isHidden = true
        return img
    }()

    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(20), .center)
        lab.text = "EMAIL"
        return lab
    }()
    
    
    private let e_line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR.withAlphaComponent(0.8)
        view.layer.cornerRadius = 2
        return view
    }()
    

    
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(15), .center)
        lab.text = "PHONE NUMBER"
        return lab
    }()

    private let p_line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR.withAlphaComponent(0.8)
        view.layer.cornerRadius = 2
        view.isHidden = true
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
        but.isHidden = true
        return but
    }()
    
    private let numberlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Email:"
        return lab
    }()
    
    
    private let numberBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 7
        return view
    }()

    
    private lazy var numberTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.textColor = HCOLOR("#333333")
        tf.setPlaceholder("Please enter email address", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    
    private let pwlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Password:"
        return lab
    }()

    
    private let pwBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 7
        return view
    }()
    
    
    private lazy var pwTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.setPlaceholder("Please enter password", color: HCOLOR("#BBBBBB"))
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
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
        lab.text = "Forgot Password?"
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
        lab.text = "Sign up"
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
        but.setCommentStyle(.zero, "Phone sign up", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 21
        but.setImage(LOIMG("phone_signup"), for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        //but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return but
    }()

    private let emailBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Email sign up", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 21
        but.setImage(LOIMG("email_signup"), for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return but
    }()
    
    private lazy var areaAlert: AreaAlert = {
        let alert = AreaAlert()
        alert.clickCountryBlock = { [unowned self] (model) in
            areaCode = (model as! CountryModel).areaCode
            countryCode = (model as! CountryModel).countryCode
        }
        return alert
    }()
    
    
    
    override func setViews() {
        setUpUI()
        addButAction()
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
        
        
        
        view.addSubview(yellowView)
        yellowView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(75)
            $0.top.equalToSuperview().offset((SET_H(220, 375) - 25))
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo((S_H - SET_H(220, 375)) - 30)
        }
        
        view.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(yellowView.snp.top)
            $0.bottom.equalTo(backView.snp.top)
            $0.width.equalTo(S_W / 2)
        }
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.equalTo(yellowView.snp.top)
            $0.bottom.equalTo(backView.snp.top)
            $0.width.equalTo(S_W / 2)
        }
        
        view.addSubview(leftImg)
        leftImg.snp.makeConstraints {
            $0.left.top.equalTo(leftBut)
            $0.width.equalTo(R_W(235))
            $0.bottom.equalTo(backView.snp.top).offset(1)
        }
        
        view.addSubview(rightImg)
        rightImg.snp.makeConstraints {
            $0.right.top.equalTo(rightBut)
            $0.width.equalTo(R_W(235))
            $0.bottom.equalTo(backView.snp.top).offset(1)
        }

        view.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.center.equalTo(leftBut)
        }
        
        view.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.center.equalTo(rightBut)
        }
        
        view.addSubview(e_line)
        e_line.snp.makeConstraints {
            $0.left.right.equalTo(emailLab)
            $0.height.equalTo(4)
            $0.bottom.equalTo(emailLab).offset(-2)
        }
        
        view.addSubview(p_line)
        p_line.snp.makeConstraints {
            $0.left.right.equalTo(phoneLab)
            $0.height.equalTo(4)
            $0.bottom.equalTo(phoneLab).offset(-2)
        }
        

        
        view.addSubview(welcomeImg)
        welcomeImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(yellowView.snp.top).offset(-R_H(35))
            $0.size.equalTo(CGSize(width: R_W(250), height: SET_H(26, 250)))
        }


        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(R_H(180))
            $0.height.equalTo(42)
        }
        
        
        backView.addSubview(numberlab)
        numberlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(leftBut.snp.bottom).offset(15)
        }
        
        backView.addSubview(numberBackView)
        numberBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(40)
            $0.top.equalTo(numberlab.snp.bottom).offset(5)
        }

        numberBackView.addSubview(numberTF)
        numberTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        
        numberBackView.addSubview(areaBut)
        areaBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.width.equalTo(75)
            $0.centerY.equalTo(numberTF)
        }



        backView.addSubview(pwlab)
        pwlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(numberBackView.snp.bottom).offset(15)
        }
        
        backView.addSubview(pwBackView)
        pwBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(40)
            $0.top.equalTo(pwlab.snp.bottom).offset(5)
        }
        
        pwBackView.addSubview(hideBut)
        hideBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 50))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }

        
        pwBackView.addSubview(pwTF)
        pwTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(hideBut.snp.left).offset(-15)
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
            $0.top.equalTo(nextBut.snp.bottom).offset(R_H(55))
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
        
        backView.addSubview(emailBut)
        emailBut.snp.makeConstraints {
            $0.left.right.equalTo(nextBut)
            $0.height.equalTo(42)
            $0.top.equalTo(otherLab.snp.bottom).offset(R_H(20))
        }
        
        backView.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.left.right.height.equalTo(emailBut)
            $0.top.equalTo(emailBut.snp.bottom).offset(R_H(15))
        }
        
        
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
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //不能输入空格
        if string == " " {
            return false
        }
        return true
    }
    
}



extension LogInController {
    
    
    private func addButAction() {
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        hideBut.addTarget(self, action: #selector(clickHideAction), for: .touchUpInside)
        forgetBut.addTarget(self, action: #selector(clickForgetAction), for: .touchUpInside)
        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        emailBut.addTarget(self, action: #selector(clickEmailAction), for: .touchUpInside)
        leftBut.addTarget(self, action: #selector(clickLeftAction), for: .touchUpInside)
        rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)

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
        
        if loginWay == .EMAIL {
            let nextVC = FindPasswordController()
            nextVC.areaCode = areaCode
            //nextVC.countryCode = countryCode
            nextVC.countryList = countryList
            nextVC.email = numberTF.text ?? ""
//            if loginWay == .EMAIL {
//                nextVC.email = numberTF.text ?? ""
//            } else {
//                nextVC.phoneNum = numberTF.text ?? ""
//            }
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = FindPasswordPhoneController()
            nextVC.areaCode = areaCode
            nextVC.countryCode = countryCode
            nextVC.countryList = countryList
            nextVC.phoneNum = numberTF.text ?? ""
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    @objc private func clickPhoneAction() {
        //手机验证码注册
        let nextVC = PhoneRegisterController()
        nextVC.areaCode = areaCode
        nextVC.countryCode = countryCode
        nextVC.countryList = countryList
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    @objc private func clickLeftAction() {
        if loginWay != .EMAIL {
            setEmailUI()
        }
    }
    
    @objc private func clickRightAction() {
        if loginWay != .PHONE {
            setPhoneUI()
        }

    }
    
    @objc private func clickEmailAction() {
        //手机验证码登陆
        let nextVC = EmailRegisterController()
        if loginWay == .EMAIL {
            nextVC.email = numberTF.text ?? ""
        }
        navigationController?.pushViewController(nextVC, animated: true)
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
        if loginWay == .EMAIL {
            loginEmail_Net()
        } else {
            loginPhone_Net()
        }
    }
    
    
    
    private func setEmailUI() {
        loginWay = .EMAIL
        leftImg.isHidden = false
        rightImg.isHidden = true
        e_line.isHidden = false
        p_line.isHidden = true
        
        phoneLab.font = BFONT(15)
        phoneLab.textColor = .white
        emailLab.font = BFONT(20)
        emailLab.textColor = FONTCOLOR
        numberlab.text = "Email:"
        
        numberTF.text = ""
        
        
        areaBut.isHidden = true
        numberTF.keyboardType = .emailAddress
        numberTF.placeholder = "Please enter email address"
        numberTF.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        
        
    }
    
    
    private func setPhoneUI() {
        loginWay = .PHONE
        leftImg.isHidden = true
        rightImg.isHidden = false
        e_line.isHidden = true
        p_line.isHidden = false
        
        emailLab.font = BFONT(15)
        emailLab.textColor = .white
        phoneLab.font = BFONT(20)
        phoneLab.textColor = FONTCOLOR
        numberlab.text = "Phone:"
        
        numberTF.text = ""
        
        areaBut.isHidden = false
        numberTF.keyboardType = .numberPad
        numberTF.placeholder = "Please enter phone number"
        numberTF.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(95)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            //$0.bottom.equalTo(line2.snp.top)
        }
    }
}


extension LogInController {
    
    //MARK: - 网络请求
    //邮箱登录
    private func loginEmail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loginEmail(email: numberTF.text!, pwd: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"]["infoType"].stringValue == "2" {
                //填写过用户信息 直接登录了
                loginInfoSave(json: json)
                getUserInfo_Net()
                loginSet_Net()
            } else {
                HUD_MB.showSuccess("Success", onView: view)
                //没有填写过
                UserDefaults.standard.token = json["data"]["token"].stringValue
                DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                    let infoVC = PersonalInfoController()
                    infoVC.isCanEdite = true
                    navigationController?.pushViewController(infoVC, animated: true)
                }
            }       
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
        
    }
    
    //手机登录
    private func loginPhone_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loginPWD(countryCode: areaCode, phone: numberTF.text!, pwd: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"]["infoType"].stringValue == "2" {
                //填写过用户信息 直接登录了
                loginInfoSave(json: json)
                getUserInfo_Net()
                loginSet_Net()
            } else {
                HUD_MB.showSuccess("Success", onView: view)
                //没有填写过
                UserDefaults.standard.token = json["data"]["token"].stringValue
                DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                    let infoVC = PersonalInfoController()
                    infoVC.isCanEdite = true
                    navigationController?.pushViewController(infoVC, animated: true)
                }
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //获取用户信息
    private func getUserInfo_Net() {
        //获取用户信息
        HTTPTOOl.getUserInfo().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            UserDefaults.standard.userName = json["data"]["name"].stringValue
            if json["data"]["loginType"].stringValue == "2" {
                //手机
                UserDefaults.standard.removeObject(forKey: Keys.userEmail)
                UserDefaults.standard.userPhone = json["data"]["phone"].stringValue
            }
            if json["data"]["loginType"].stringValue == "3" {
                //邮箱
                UserDefaults.standard.removeObject(forKey: Keys.userPhone)
                UserDefaults.standard.userEmail = json["data"]["email"].stringValue
            }
            
            DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                dismiss(animated: true) {
                    
                    if UserDefaults.standard.giftID ?? "" != "" {
                        //有可领取的礼品券
                        ShowGiftAlertManager.instance.showAlert(giftId: UserDefaults.standard.giftID!)
                    }
                }
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)

    }
    
    //登录设置
    private func loginSet_Net() {
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
            print("语言设置失败")
        }).disposed(by: self.bag)

    }
    
    //登录信息存储
    private func loginInfoSave(json: JSON) {
        UserDefaults.standard.token = json["data"]["token"].stringValue
        UserDefaults.standard.isLogin = true
        NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
    }
    
    
    private func loadCountryList_Net() {
        
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

            if let curCode = Locale.current.regionCode {
                print(curCode)
                
                let arr = countryList.filter { $0.countryCode == curCode }
                
                if arr.count == 0 {
                    areaCode = countryList.first?.areaCode ?? ""
                    countryCode = countryList.first?.countryCode ?? ""
                } else {
                    areaCode = arr.first?.areaCode ?? ""
                    countryCode = arr.first?.countryCode ?? ""
                }
                
            } else {
                areaCode = countryList.first?.areaCode ?? ""
                countryCode = countryList.first?.countryCode ?? ""
            }
            
        }, onError: { [unowned self] (error) in
            areaCode = "44"
            countryCode = "GB"
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
}




