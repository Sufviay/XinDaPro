//
//  PersonalInfoController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/5.
//

import UIKit
import RxSwift



class PersonalInfoController: BaseViewController {
    
    private let bag = DisposeBag()
    
    var isInfoCenter: Bool = false
    
    var isCanEdite: Bool = false {
        didSet {
            if isCanEdite {
                self.nameTF.isUserInteractionEnabled = true
                self.emailTF.isUserInteractionEnabled = true
                self.birthdayTF.isUserInteractionEnabled = true
                self.xlbut.isHidden = false
                self.saveBut.isHidden = false
                
            } else {
                self.nameTF.isUserInteractionEnabled = false
                self.emailTF.isUserInteractionEnabled = false
                self.birthdayTF.isUserInteractionEnabled = false
                self.xlbut.isHidden = true
                self.saveBut.isHidden = true

            }
        }
    }
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()
    
    
    private let sikpBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Skip", HCOLOR("#465DFD"), SFONT(13), .clear)
        return but
    }()
    
    private let butline: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Name:"
        return lab
    }()
    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "E-mail:"
        return lab
    }()

    private let birthdayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Birthday:"
        return lab
    }()
    
    
    private let pwLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Password:"
        return lab
    }()

    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.placeholder = "Enter the name"
        return tf
    }()
    
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.placeholder = "Enter the E-mail"
        return tf
    }()
    
    private let birthdayTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.placeholder = "Enter the birthday"
        return tf
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

    
    private let resetBut: UIButton = {
        let but = UIButton()
//        but.setCommentStyle(.zero, "RESET", HCOLOR("#999999"), BFONT(11), .clear)
//        but.setImage(LOIMG("info_next"), for: .normal)
        return but
    }()
    
    private let resetlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), BFONT(11), .center)
        lab.text = "RESET"
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("info_next")
        return img
    }()
    
    
    private let xlbut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("jt_b"), for: .normal)
        return but
    }()

    //日期
    private lazy var dayAlert: TimeDayAlert = {
        let view = TimeDayAlert()
        view.selectBlock = { [unowned self] (arr) in
            let showStr = (arr as! [String])[0]
            self.birthdayTF.text = showStr
        }
        return view
    }()
    
    
    
    
    
    
    
    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightImg = LOIMG("info_edite")
        self.naviBar.headerTitle = "Personal information"
        
        if isInfoCenter {
            self.naviBar.leftBut.isHidden = false
            self.naviBar.rightBut.isHidden = false
        } else {
            self.naviBar.leftBut.isHidden = true
            self.naviBar.rightBut.isHidden = true
        }
            
    }


    override func setViews() {
        setUpUI()
        self.getUserInfo_Net()
    }
    
    
    override func clickLeftButAction() {
        
        if isInfoCenter {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
                
    }
    
    
    override func clickRightButAction() {
        //编辑
        isCanEdite = !isCanEdite
    }
    
    
    private func setUpUI() {
        
        if isInfoCenter {
            self.sikpBut.isHidden = true
            self.line4.isHidden = true
            self.resetBut.isHidden = true
            self.pwLab.isHidden = true
            
        } else {
            self.sikpBut.isHidden = false
            self.line4.isHidden = false
            self.resetBut.isHidden = false
            self.pwLab.isHidden = false
        }
        
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 44)
            $0.height.equalTo(7)
        }
        
        view.addSubview(sikpBut)
        sikpBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview().offset(-100)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 55)
            $0.height.equalTo(30)
        }
        
        sikpBut.addSubview(butline)
        butline.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 25, height: 0.5))
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
        view.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 95)
            $0.height.equalTo(45)
            
        }
        
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(25)
        }
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(nameLab.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        view.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line1.snp.bottom).offset(20)
        }
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(emailLab.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        view.addSubview(birthdayLab)
        birthdayLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line2.snp.bottom).offset(20)
        }
        
        
        view.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(birthdayLab.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        
        view.addSubview(pwLab)
        pwLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line3.snp.bottom).offset(20)
        }


        
        view.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(pwLab.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        view.addSubview(resetBut)
        resetBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 40))
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalTo(pwLab)
        }
        
        resetBut.addSubview(resetlab)
        resetlab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        resetBut.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.left.equalTo(resetlab.snp.right).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(120)
            $0.height.equalTo(40)
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.height.right.equalTo(nameTF)
            $0.centerY.equalTo(emailLab)
        }
        
        view.addSubview(xlbut)
        xlbut.snp.makeConstraints {
            $0.centerY.equalTo(birthdayLab)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        view.addSubview(birthdayTF)
        birthdayTF.snp.makeConstraints {
            $0.left.height.equalTo(nameTF)
            $0.centerY.equalTo(birthdayLab)
            $0.right.equalTo(xlbut.snp.left)
        }
        
        
        saveBut.addTarget(self, action: #selector(clickSaveAciton), for: .touchUpInside)
        sikpBut.addTarget(self, action: #selector(clickSikpAction), for: .touchUpInside)
        xlbut.addTarget(self, action: #selector(clickXLAction), for: .touchUpInside)
        resetBut.addTarget(self, action: #selector(clickResetPW), for: .touchUpInside)
        
        let birthdayTap = UITapGestureRecognizer(target: self, action: #selector(clickTimeAction))
        self.birthdayTF.addGestureRecognizer(birthdayTap)
        
    }
    
    @objc private func clickTimeAction() {
        self.dayAlert.appearAction()
    }
    
    
    @objc private func clickSaveAciton() {
        
        if isInfoCenter {
            
            //从侧拉篮里进入时 必须全部填写
            if nameTF.text ?? "" != "" && emailTF.text ?? "" != "" && birthdayTF.text ?? "" != "" {
                saveAction_Net()
            } else {
                HUD_MB.showWarnig("Please complete the information!", onView: view)
            }
            
        } else {
            self.saveAction_Net()
        }
        
    }
    
    
    
    @objc private func clickSikpAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func clickXLAction() {
        self.dayAlert.appearAction()
    }
    
    @objc private func clickResetPW() {
        //修改密码页面
        let nextVC = ResetPasswordController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    //获取用户信息
    private func getUserInfo_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getUserInfo().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.nameTF.text = json["data"]["name"].stringValue
            self.emailTF.text = json["data"]["email"].stringValue
            self.birthdayTF.text = json["data"]["birthday"].stringValue
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    private func saveAction_Net() {
        
        HUD_MB.loading("", onView: view)
        //
        HTTPTOOl.updateUserInfo(name: nameTF.text ?? "", email: emailTF.text ?? "", birthday: birthdayTF.text ?? "").subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            
            UserDefaults.standard.userName = self.nameTF.text
            DispatchQueue.main.after(time: .now() + 1.5) {
                if self.isInfoCenter {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
}
