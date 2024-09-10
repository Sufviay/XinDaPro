//
//  EmailRegisterController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/7.
//

import UIKit
import RxSwift

class EmailRegisterController: BaseViewController, UITextFieldDelegate {

    private let bag = DisposeBag()
    
    var email: String = "" {
        didSet {
            emailTF.text = email
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
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_back_b"), for: .normal)
        return but
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(28), .left)
        lab.text = "Sign up"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Please verify Email address and set Password, so that you can log in with this Email address and Password next time."
        return lab
    }()
    
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(15), HCOLOR("#EBEBEB"))
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
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private lazy var emailTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.placeholder = "Please enter email address"
        tf.keyboardType = .emailAddress
        tf.textColor = HCOLOR("#333333")
        return tf
    }()

    
    private let sendCodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Send", MAINCOLOR, BFONT(13), .clear)
        return but
    }()
    
    private lazy var codeTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.placeholder = "Please enter verification code"
        tf.keyboardType = .numberPad
        tf.textColor = HCOLOR("#333333")
        return tf
    }()

    private lazy var pwTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.placeholder = "Please enter password"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    
    private lazy var redeemCodeTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.placeholder = "Redeem code (optional)"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    
    
    private let hideBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
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
    


    
    
    override func setViews() {
        setUpUI()
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
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line1.snp.bottom).offset(50)
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

    
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(line4.snp.bottom).offset(45)
            $0.height.equalTo(42)
        }
        
        
        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.height.equalTo(40)
            $0.bottom.equalTo(line1.snp.top)
        }
        
        view.addSubview(sendCodeBut)
        sendCodeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 40))
            $0.bottom.equalTo(line2.snp.top)
            $0.right.equalTo(line2)
        }
        
        
        view.addSubview(line5)
        line5.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 13))
            $0.centerY.equalTo(sendCodeBut)
            $0.right.equalTo(sendCodeBut.snp.left)
        }
        
        

        
        view.addSubview(codeTF)
        codeTF.snp.makeConstraints {
            $0.height.equalTo(emailTF)
            $0.left.equalTo(line2)
            $0.bottom.equalTo(line2.snp.top)
            $0.right.equalTo(line5.snp.left).offset(-10)
        }
        
        view.addSubview(hideBut)
        hideBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.bottom.equalTo(line3.snp.top)
            $0.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(pwTF)
        pwTF.snp.makeConstraints {
            $0.height.equalTo(emailTF)
            $0.left.equalTo(line3)
            $0.bottom.equalTo(line3.snp.top)
            $0.right.equalTo(hideBut.snp.left).offset(-5)
        }
        
        view.addSubview(redeemCodeTF)
        redeemCodeTF.snp.makeConstraints {
            $0.height.equalTo(emailTF)
            $0.left.right.equalTo(line4)
            $0.bottom.equalTo(line4.snp.top)
        }

        
        
        view.addSubview(xyView)
        xyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 280, height: 30))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        emailTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" && pwTF.text ?? "" != "" && codeTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }

        }).disposed(by: bag)
        
        codeTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str != "" &&  pwTF.text ?? "" != "" && emailTF.text ?? "" != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }

        }).disposed(by: bag)

        pwTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            
            if str != "" && codeTF.text ?? "" != "" && emailTF.text ?? "" != "" {
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



        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        sendCodeBut.addTarget(self, action: #selector(clickSendCodeAction), for: .touchUpInside)
        hideBut.addTarget(self, action: #selector(clickPWHideAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSendCodeAction() {
        
        if emailTF.text ?? "" != "" {
            sendCode_Net()
        }
    }
    
    
    @objc private func clickPWHideAction() {
        pwHide = !pwHide
    }
    
    @objc private func clickNextAction() {
        if (pwTF.text ?? "").length < 6 {
            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
            return
        }
        register_Net()
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //不能输入空格
        if string == " " {
            return false
        }
        return true
    }


    //MARK: - 网络请求
    private func sendCode_Net() {
        sendCodeBut.isEnabled = false
        HUD_MB.loading("", onView: view)
        HTTPTOOl.emailSendCode(email: emailTF.text!).subscribe(onNext: { [weak self] (json) in
                        
            HUD_MB.showSuccess("The verification code has been sent.", onView: self!.view)
            
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
    
    
    //注册
    private func register_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.emailRegister(email: emailTF.text ?? "", pwd: (pwTF.text ?? "").md5Encrypt(), code: codeTF.text ?? "", reCode: redeemCodeTF.text ?? "").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                navigationController?.popToRootViewController(animated: true)
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    

}
