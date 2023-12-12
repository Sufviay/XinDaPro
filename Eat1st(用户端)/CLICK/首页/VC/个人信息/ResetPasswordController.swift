//
//  ResetPasswordController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/12/8.
//

import UIKit
import RxSwift
import RxCocoa


class ResetPasswordController: BaseViewController, UITextFieldDelegate {
    
    private let bag = DisposeBag()
    
    private var oldPWHide: Bool = true {
        didSet {
            if oldPWHide {
                hideBut1.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut1.setImage(LOIMG("login_open"), for: .normal)
            }
            oldPWTF.isSecureTextEntry = oldPWHide
        }
    }

    
    private var pwHide: Bool = true {
        didSet {
            if pwHide {
                hideBut2.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut2.setImage(LOIMG("login_open"), for: .normal)
            }
            pwTF.isSecureTextEntry = pwHide
        }
    }
    
    private var rePWHide: Bool = true {
        didSet {
            if rePWHide {
                hideBut3.setImage(LOIMG("login_hide"), for: .normal)
            } else {
                hideBut3.setImage(LOIMG("login_open"), for: .normal)
            }
            rePWTF.isSecureTextEntry = rePWHide
        }
    }
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()

    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
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
    
    private let hideBut3: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_hide"), for: .normal)
        return but
    }()
    
    private lazy var oldPWTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.placeholder = "Old password"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    
    private lazy var pwTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.placeholder = "New password"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    
    private lazy var rePWTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = BFONT(14)
        tf.placeholder = "Re-enter Password"
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    



    override func setViews() {
        setUpUI()
        
    }
    
    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.headerTitle = "Reset Password"
    }
    
    private func setUpUI() {
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 44)
            $0.height.equalTo(7)
        }

        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
            $0.top.equalTo(line1.snp.bottom).offset(60)
        }
        
        view.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.right.height.equalTo(line2)
            $0.top.equalTo(line2.snp.bottom).offset(50)
        }
        
        view.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.right.height.equalTo(line2)
            $0.top.equalTo(line3.snp.bottom).offset(50)
        }
        
        view.addSubview(hideBut1)
        hideBut1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.bottom.equalTo(line2.snp.top)
            $0.right.equalToSuperview().offset(-10)
        }
        
        view.addSubview(hideBut2)
        hideBut2.snp.makeConstraints {
            $0.size.right.equalTo(hideBut1)
            $0.bottom.equalTo(line3.snp.top)
        }
        
        view.addSubview(hideBut3)
        hideBut3.snp.makeConstraints {
            $0.size.right.equalTo(hideBut1)
            $0.bottom.equalTo(line4.snp.top)
        }
        
        view.addSubview(oldPWTF)
        oldPWTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.bottom.equalTo(line2.snp.top)
            $0.right.equalTo(hideBut1.snp.left).offset(-10)
        }
        
        view.addSubview(pwTF)
        pwTF.snp.makeConstraints {
            $0.left.height.right.equalTo(oldPWTF)
            $0.bottom.equalTo(line3.snp.top)
        }
        
        view.addSubview(rePWTF)
        rePWTF.snp.makeConstraints {
            $0.left.height.right.equalTo(oldPWTF)
            $0.bottom.equalTo(line4.snp.top)
        }
        
        view.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
        }

        oldPWTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str.length > 15 {
                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
                oldPWTF.text = str.substring(to: 15)
            }
        }).disposed(by: bag)

        
        pwTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str.length > 15 {
                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
                pwTF.text = str.substring(to: 15)
            }
        }).disposed(by: bag)
        
        rePWTF.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] str in
            if str.length > 15 {
                HUD_MB.showWarnig("The password cannot exceed 15 characters.", onView: view)
                rePWTF.text = str.substring(to: 15)
            }
        }).disposed(by: bag)

        hideBut1.addTarget(self, action: #selector(clickHide1Action), for: .touchUpInside)
        hideBut2.addTarget(self, action: #selector(clickHide2Action), for: .touchUpInside)
        hideBut3.addTarget(self, action: #selector(clickHide3Action), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickHide1Action() {
        oldPWHide = !oldPWHide
    }
    
    @objc private func clickHide2Action() {
        pwHide = !pwHide
    }

    @objc private func clickHide3Action() {
        rePWHide = !rePWHide
    }

    @objc private func clickSaveAction() {
        
        if (oldPWTF.text ?? "").length < 6 {
            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
            return
        }
        
        if (pwTF.text ?? "").length < 6 {
            HUD_MB.showWarnig("The password cannot be less than 6 characters.", onView: view)
            return
        }
        
        if (pwTF.text ?? "") != (rePWTF.text ?? "") {
            HUD_MB.showWarnig("The two password entries are inconsistent.", onView: view)
            return
        }
        
        updatePwd_Net()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //不能输入空格
        if string == " " {
            return false
        }
        return true
    }
    
    
    private func updatePwd_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doUpdatePWD(oldPwd: oldPWTF.text!.md5Encrypt(), newPwd: pwTF.text!.md5Encrypt()).subscribe(onNext: { [unowned self] (_) in
            HUD_MB.showSuccess("Success", onView: view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
                navigationController?.popViewController(animated: true)
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    

}
