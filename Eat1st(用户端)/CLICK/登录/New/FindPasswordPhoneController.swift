//
//  FindPasswordPhoneController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/8/15.
//

import UIKit
import RxSwift

class FindPasswordPhoneController: BaseViewController, UITextFieldDelegate {

    private let bag = DisposeBag()
    
    var countryList: [CountryModel] = [] {
        didSet {
            areaAlert.dataArr = countryList
        }
    }
    
    var countryCode: String = ""
    var areaCode: String = "" {
        didSet {
            areaNumLab.text = "+\(areaCode)"
        }
    }
    
    
    var phoneNum: String = "" {
        didSet {
            numberTF.text = phoneNum
        }
    }

    private var smsID: String = ""
    private var picCode: String = ""
    
    private var pwHide: Bool = true {
        didSet {
            if pwHide {
                hideBut1.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut1.setImage(LOIMG("login_open"), for: .normal)
            }
            pwTF.isSecureTextEntry = pwHide
        }
    }
    
    private var rePWHide: Bool = true {
        didSet {
            if rePWHide {
                hideBut2.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut2.setImage(LOIMG("login_open"), for: .normal)
            }
            rePWTF.isSecureTextEntry = rePWHide
        }
    }

    

    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_fanhui"), for: .normal)
        return but
    }()

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(28), .left)
        lab.text = "Reset Password"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Please verify phone number and reset password, so that you can log in with this phone number and new password next time."
        return lab
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
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line5: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    
    private lazy var numberTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.setPlaceholder("Please enter phone number", color: HCOLOR("#BBBBBB"))
        tf.keyboardType = .numberPad
        tf.textColor = HCOLOR("#333333")
        return tf
    }()
    
    
    private let areaBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
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
    
    
    private lazy var picCodeTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.setPlaceholder("Please enter code", color: HCOLOR("#BBBBBB"))
        tf.textColor = HCOLOR("#333333")
        return tf
    }()

    
    
    private let refreshBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("refresh"), for: .normal)
        return but
    }()
    
    
    private let picCodeImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    
    private let line6: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    private let sendCodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Send", MAINCOLOR, BFONT(13), .clear)
        return but
    }()
    
    private lazy var codeTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.setPlaceholder("Please enter verification code", color: HCOLOR("#BBBBBB"))
        tf.keyboardType = .numberPad
        tf.textColor = HCOLOR("#333333")
        tf.textContentType = .oneTimeCode
        return tf
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
    
    
    private lazy var rePWTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.setPlaceholder("Please enter password again", color: HCOLOR("#BBBBBB"))
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()

    
    private let hideBut1: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
    }()
    
    private let hideBut2: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
    }()

    private let nextBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(15), HCOLOR("#EBEBEB"))
        but.clipsToBounds = true
        but.layer.cornerRadius = 21
        but.isEnabled = false
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
        getPictureCode_Net()
        
    }
    
    
    private func setUpUI() {
        naviBar.isHidden = true
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        view.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(statusBarH + R_H(80))
        }
        
        
        view.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(tlab1.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-25)
        }
        
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(0.5)
            $0.top.equalTo(tlab2.snp.bottom).offset(65)
        }
        
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.top.equalTo(line1.snp.bottom).offset(50)
            $0.left.right.height.equalTo(line1)
        }
        
        view.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line2.snp.bottom).offset(50)
        }
        
        view.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line3.snp.bottom).offset(50)
        }
        
        view.addSubview(line5)
        line5.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line4.snp.bottom).offset(50)
        }

        view.addSubview(numberTF)
        numberTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(95)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(40)
            $0.bottom.equalTo(line1.snp.top)
        }


        view.addSubview(areaBut)
        areaBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(numberTF.snp.left).offset(-10)
            $0.height.equalTo(50)
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
        
        
        view.addSubview(picCodeTF)
        picCodeTF.snp.makeConstraints {
            $0.right.equalTo(line2).offset(-110)
            $0.left.equalTo(line2)
            $0.height.equalTo(40)
            $0.bottom.equalTo(line2.snp.top)
        }

        
        view.addSubview(refreshBut)
        refreshBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.right.equalTo(line2)
            $0.centerY.equalTo(picCodeTF)
        }
        
        view.addSubview(picCodeImg)
        picCodeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 30))
            $0.centerY.equalTo(picCodeTF)
            $0.right.equalTo(refreshBut.snp.left).offset(0)
        }
        
        
        view.addSubview(sendCodeBut)
        sendCodeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 40))
            $0.bottom.equalTo(line3.snp.top)
            $0.right.equalTo(line3)
        }
        
        view.addSubview(line6)
        line6.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 13))
            $0.centerY.equalTo(sendCodeBut)
            $0.right.equalTo(sendCodeBut.snp.left)
        }
        
        view.addSubview(codeTF)
        codeTF.snp.makeConstraints {
            $0.height.equalTo(numberTF)
            $0.left.equalTo(line3)
            $0.bottom.equalTo(line3.snp.top)
            $0.right.equalTo(line6.snp.left).offset(-10)
        }

        
        view.addSubview(hideBut1)
        hideBut1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.bottom.equalTo(line4.snp.top)
            $0.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(hideBut2)
        hideBut2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.bottom.equalTo(line5.snp.top)
            $0.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(pwTF)
        pwTF.snp.makeConstraints {
            $0.height.equalTo(numberTF)
            $0.left.equalTo(line4)
            $0.bottom.equalTo(line4.snp.top)
            $0.right.equalTo(hideBut1.snp.left).offset(-5)
        }
        
        view.addSubview(rePWTF)
        rePWTF.snp.makeConstraints {
            $0.height.equalTo(numberTF)
            $0.left.equalTo(line5)
            $0.bottom.equalTo(line5.snp.top)
            $0.right.equalTo(hideBut2.snp.left).offset(-5)
        }
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(42)
            $0.top.equalTo(line5.snp.bottom).offset(50)
        }

        
        pwTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            
            if str != "" && rePWTF.text ?? "" != "" && codeTF.text ?? "" != "" && numberTF.text ?? "" != "" && picCodeTF.text ?? "" != "" {
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
        
        rePWTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" && pwTF.text ?? "" != "" && codeTF.text ?? "" != "" && numberTF.text ?? "" != "" && picCodeTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }
            
            if str.length > 15 {
                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
                rePWTF.text = str.substring(to: 15)
            }

        }).disposed(by: bag)
        
        
        numberTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in

            if str != "" && rePWTF.text ?? "" != "" && pwTF.text ?? "" != "" && codeTF.text ?? "" != "" && picCodeTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }

        }).disposed(by: bag)
        
        codeTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" && rePWTF.text ?? "" != "" &&  pwTF.text ?? "" != "" && numberTF.text ?? "" != "" && picCodeTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }

        }).disposed(by: bag)
        

        picCodeTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" && rePWTF.text ?? "" != "" && pwTF.text ?? "" != "" && codeTF.text ?? "" != "" && numberTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }

        }).disposed(by: bag)

        
        
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        refreshBut.addTarget(self, action: #selector(clickRefreshAction), for: .touchUpInside)
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        sendCodeBut.addTarget(self, action: #selector(clickSendCodeAction), for: .touchUpInside)
        
        hideBut1.addTarget(self, action: #selector(clickPWHideAction), for: .touchUpInside)
        hideBut2.addTarget(self, action: #selector(clickRePWHideAction), for: .touchUpInside)

        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickAreaAction(sender: UIButton) {
        print(sender.frame)
        areaAlert.tap_H = sender.frame.maxY + 10
        areaAlert.appearAction()
    }
    

    @objc private func clickRefreshAction() {
        getPictureCode_Net()
    }
    
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func clickSendCodeAction() {
        
        if numberTF.text ?? "" != "" && picCodeTF.text ?? "" != "" && picCode != "" {
            sendCode_Net()
        }
    }
    
    @objc private func clickPWHideAction() {
        pwHide = !pwHide
    }
    
    @objc private func clickRePWHideAction() {
        rePWHide = !rePWHide
    }
    
    
    @objc private func clickNextAction() {
                
        if (pwTF.text ?? "").length < 6 {
            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
            return
        }
        
        if (pwTF.text ?? "") != (rePWTF.text ?? "") {
            HUD_MB.showWarnig("The two password entries are inconsistent.", onView: view)
            return
        }
        findPWD_Net()
        
    }


    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //不能输入空格
        if string == " " {
            return false
        }
        return true
    }


}


extension FindPasswordPhoneController {
    
    //获取图片验证码
    private func getPictureCode_Net() {
        HTTPTOOl.getLoginPictureCode().subscribe(onNext: { [unowned self] (json) in
            picCode = json["data"]["valCode"].stringValue
            picCodeImg.sd_setImage(with: URL(string: json["data"]["image"].stringValue))
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //MARK: - 网络请求
    private func sendCode_Net() {
        sendCodeBut.isEnabled = false
        HUD_MB.loading("", onView: view)
        HTTPTOOl.sendSMSCode(countryCode: countryCode, phone: numberTF.text!, type: "2", picCode: picCodeTF.text!, valCode: picCode).subscribe(onNext: { [weak self] (json) in
                        
            HUD_MB.showSuccess("The verification code has been sent.", onView: self!.view)
            
            self!.smsID = json["data"]["smsId"].stringValue
            
            var s = 60
            let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
            codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
 
            codeTimer.setEventHandler {
                s -= 1
                DispatchQueue.main.async {
                    self?.sendCodeBut.setTitle(String(format: "(%d)s", s), for: .normal)
                }
                if s == 0 {
                    DispatchQueue.main.async {
                        self?.sendCodeBut.isEnabled = true
                        self?.sendCodeBut.setTitle("Send", for: .normal)
                    }
                    codeTimer.cancel()
                }
            }
            codeTimer.activate()

        }, onError: { [unowned self] (error) in
            sendCodeBut.isEnabled = true
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
    private func findPWD_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.findPWD_phone(code: codeTF.text!, countryCode: countryCode, phone: numberTF.text!, smsID: smsID, pw: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (json) in
            //成功后进行登录
            HUD_MB.showSuccess("Success", onView: view)
            DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                navigationController?.popToRootViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
}
