//
//  PersonalInfoController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/5.
//

import UIKit
import RxSwift
import SwiftyJSON


class UserInfoModel: NSObject {
    
    ///生日（MM-dd）[...]
    var birthday: String = ""
    ///手机区号（若无返回0）
    var areaCode: String = ""
    ///邮件[...]
    var email: String = ""
    ///登录方式（2手机，3邮箱）[...]
    var loginType: String = ""
    ///姓名[...]
    var name: String = ""
    ///手机[...]
    var phone: String = ""
    ///邮编[...]
    var postCode: String = ""

    
    func updateModel(json: JSON) {
        birthday = json["birthday"].stringValue
        areaCode = json["areaCode"].stringValue
        email = json["email"].stringValue
        name = json["name"].stringValue
        postCode = json["postCode"].stringValue
        loginType = json["loginType"].stringValue
        if areaCode != "" {
            let tStr = json["phone"].stringValue
            phone = tStr.replacingOccurrences(of: "+\(areaCode)", with: "")
        }
    }
    
}



class PersonalInfoController: BaseViewController {
    
    private let bag = DisposeBag()
    
    var isInfoCenter: Bool = false
    
    
    
    var isCanEdite: Bool = false {
        didSet {
            if isCanEdite {
                self.nameTF.isUserInteractionEnabled = true
                self.birthdayTF.isUserInteractionEnabled = true
                self.postCodeTF.isUserInteractionEnabled = true
                self.resetBut.isUserInteractionEnabled = true
                self.xlbut.isHidden = false
                self.saveBut.isHidden = false
                
                
            } else {
                self.nameTF.isUserInteractionEnabled = false
                self.birthdayTF.isUserInteractionEnabled = false
                self.postCodeTF.isUserInteractionEnabled = false
                self.resetBut.isUserInteractionEnabled = false
                self.xlbut.isHidden = true
                self.saveBut.isHidden = true

            }
        }
    }
    
    private var infoModel = UserInfoModel()
    
    private var countryList: [CountryModel] = []
    
    private var areaCode: String = "" {
        didSet {
            areaNumLab.text = "+\(areaCode)"
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
    
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Phone:"
        return lab
    }()
    

    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "E-mail:"
        return lab
    }()
    
    private let postcodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "PostCode:"
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

    
    
    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Enter the name", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private let phoneTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Enter the phone", color: HCOLOR("#BBBBBB"))
        tf.keyboardType = .numberPad
        return tf
    }()

    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Enter the Email", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private let postCodeTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Enter the postCode", color: HCOLOR("#BBBBBB"))
        return tf
    }()

    
    private let emailRZImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("rz")
        img.isHidden = true
        return img
    }()
    
    private let phoneRZImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("rz")
        img.isHidden = true
        return img
    }()
    
    
    private let birthdayTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Enter the birthday", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
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
    
    private let line5: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()

    private let line6: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()


    
    private let resetBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let resetlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), BFONT(11), .center)
        lab.text = "CHANGE"
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
    
    private let areaXLImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_xl")
        img.isHidden = true
        return img
    }()
    
    
    //国家代码列表
    private lazy var areaAlert: AreaAlert = {
        let alert = AreaAlert()
        alert.clickCountryBlock = { [unowned self] (model) in
            areaCode = (model as! CountryModel).areaCode
        }
        return alert
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
            self.naviBar.rightBut.isHidden = false
        } else {
            self.naviBar.rightBut.isHidden = true
        }
            
    }


    override func setViews() {
        setUpUI()
        self.getUserInfo_Net()
    }
    
    
    override func clickLeftButAction() {
        
//        if isInfoCenter {
            self.navigationController?.popViewController(animated: true)
//        } else {
//            self.dismiss(animated: true)
//        }
                
    }
    
    
    override func clickRightButAction() {
        //编辑
        isCanEdite = !isCanEdite
        
        if isCanEdite {
            if infoModel.loginType == "2" {
                //手机
                emailTF.isUserInteractionEnabled = true
                areaXLImg.isHidden = true
            }
            if infoModel.loginType == "3" {
                //邮箱
                phoneTF.isUserInteractionEnabled = true
                areaBut.isUserInteractionEnabled = true
                areaXLImg.isHidden = false
            }
        } else {
            phoneTF.isUserInteractionEnabled = false
            areaBut.isUserInteractionEnabled = false
            emailTF.isUserInteractionEnabled = false
            areaXLImg.isHidden = true
        }
        
    }
    
    
    private func setUpUI() {
        
        if isInfoCenter {
            self.line6.isHidden = false
            self.resetBut.isHidden = false
            self.pwLab.isHidden = false
            
        } else {
            self.line6.isHidden = true
            self.resetBut.isHidden = true
            self.pwLab.isHidden = true
        }
        
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 44)
            $0.height.equalTo(7)
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
            $0.height.equalTo(0.5)
        }
        
        
        view.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line1.snp.bottom).offset(20)
        }

        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(phoneLab.snp.bottom).offset(20)
        }

        
        view.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line2.snp.bottom).offset(20)
        }
        
        view.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(emailLab.snp.bottom).offset(20)
        }
        
        view.addSubview(postcodeLab)
        postcodeLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line3.snp.bottom).offset(20)
        }
        
        view.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(postcodeLab.snp.bottom).offset(20)
        }

        
        view.addSubview(birthdayLab)
        birthdayLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line4.snp.bottom).offset(20)
        }
        
        
        view.addSubview(line5)
        line5.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(birthdayLab.snp.bottom).offset(20)
        }

        
        view.addSubview(pwLab)
        pwLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line5.snp.bottom).offset(20)
        }


        view.addSubview(line6)
        line6.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(pwLab.snp.bottom).offset(20)
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
        
        
        view.addSubview(areaBut)
        areaBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.width.equalTo(70)
            $0.height.equalTo(50)
            $0.centerY.equalTo(phoneLab)
        }
        
        areaBut.addSubview(areaNumLab)
        areaNumLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }

        areaBut.addSubview(areaXLImg)
        areaXLImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }

        
        view.addSubview(phoneRZImg)
        phoneRZImg.snp.makeConstraints {
            $0.centerY.equalTo(phoneLab)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 53, height: 21))
        }
        
        view.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.height.equalTo(nameTF)
            $0.left.equalTo(areaBut.snp.right).offset(10)
            $0.right.equalTo(phoneRZImg.snp.left).offset(-5)
            $0.centerY.equalTo(phoneLab)
        }
        
        view.addSubview(emailRZImg)
        emailRZImg.snp.makeConstraints {
            $0.centerY.equalTo(emailLab)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 53, height: 21))
        }

        
        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.height.equalTo(nameTF)
            $0.right.equalTo(emailRZImg.snp.left).offset(-5)
            $0.centerY.equalTo(emailLab)
        }
        
        
        view.addSubview(postCodeTF)
        postCodeTF.snp.makeConstraints {
            $0.left.height.right.equalTo(nameTF)
            $0.centerY.equalTo(postcodeLab)
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
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        xlbut.addTarget(self, action: #selector(clickXLAction), for: .touchUpInside)
        resetBut.addTarget(self, action: #selector(clickResetPW), for: .touchUpInside)
        
        let birthdayTap = UITapGestureRecognizer(target: self, action: #selector(clickTimeAction))
        self.birthdayTF.addGestureRecognizer(birthdayTap)
        
    }
    
    @objc private func clickTimeAction() {
        self.dayAlert.appearAction()
    }
    
    
    @objc private func clickAreaAction(sender: UIButton) {
        print(sender.frame)
        areaAlert.tap_H = sender.frame.maxY
        areaAlert.appearAction()
    }
    

    
    @objc private func clickSaveAciton() {
        
//        if isInfoCenter {
//            
//            //从侧拉篮里进入时 必须全部填写
//            if nameTF.text ?? "" != "" && emailTF.text ?? "" != "" && birthdayTF.text ?? "" != "" {
//                saveAction_Net()
//            } else {
//                HUD_MB.showWarnig("Please complete the information!", onView: view)
//            }
//            
//        } else {
            self.saveAction_Net()
//        }
        
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
        HTTPTOOl.getUserInfo().subscribe(onNext: { [unowned self] (json) in
            
            infoModel.updateModel(json: json["data"])
            
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
                
                if infoModel.phone == "" {
                    //没有电话信息时 设置默认的
                    //获取当前国家Code
                    if let curCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        print(curCode)
                        
                        let arr = countryList.filter { $0.countryCode == curCode }
                        
                        if arr.count == 0 {
                            areaCode = countryList.first?.areaCode ?? ""
                        } else {
                            areaCode = arr.first?.areaCode ?? ""
                        }
                        
                    } else {
                        areaCode = countryList.first?.areaCode ?? ""
                    }
                } else {
                    areaCode = infoModel.areaCode
                }

                setInfo()
                
            }, onError: { [unowned self] (error) in
                areaCode = "44"
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }
    
    private func setInfo() {
        nameTF.text = infoModel.name
        emailTF.text = infoModel.email
        phoneTF.text = infoModel.phone
        postCodeTF.text = infoModel.postCode
        birthdayTF.text = infoModel.birthday
        
        if infoModel.loginType == "2" {
            //手机
            phoneRZImg.isHidden = false
            emailRZImg.isHidden = true
            
            phoneTF.isUserInteractionEnabled = false
            areaBut.isUserInteractionEnabled = false
            areaXLImg.isHidden = true
            
            if isCanEdite {
                emailTF.isUserInteractionEnabled = true
            } else {
                emailTF.isUserInteractionEnabled = false
            }
            
        }
        
        if infoModel.loginType == "3" {
            //邮箱
            phoneRZImg.isHidden = true
            emailRZImg.isHidden = false
            
            emailTF.isUserInteractionEnabled = false
            
            if isCanEdite {
                phoneTF.isUserInteractionEnabled = true
                areaBut.isUserInteractionEnabled = true
                areaXLImg.isHidden = false
            } else {
                phoneTF.isUserInteractionEnabled = false
                areaBut.isUserInteractionEnabled = false
                areaXLImg.isUserInteractionEnabled = true
            }
        }
    }
        
    
    

    
    private func saveAction_Net() {
        
        let type = infoModel.loginType == "2" ? "1" : "2"
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.updateUserInfo(name: nameTF.text ?? "", email: emailTF.text ?? "", birthday: birthdayTF.text ?? "", phone: phoneTF.text ?? "", areaCode: areaCode, postCode: postCodeTF.text ?? "", type: type).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            
            UserDefaults.standard.userName = nameTF.text
            
            if !isInfoCenter {
                //在登录时填写信息
                UserDefaults.standard.isLogin = true
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
                
                if infoModel.loginType == "2" {
                    //手机
                    UserDefaults.standard.removeObject(forKey: Keys.userEmail)
                    UserDefaults.standard.userPhone = "+\(areaCode)\(infoModel.phone)"
                }
                if infoModel.loginType == "3" {
                    //邮箱
                    UserDefaults.standard.removeObject(forKey: Keys.userPhone)
                    UserDefaults.standard.userEmail = infoModel.email
                }
                
                DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                    dismiss(animated: true) {
                        if UserDefaults.standard.giftID ?? "" != "" {
                            //有可领取的礼品券
                            ShowGiftAlertManager.instance.showAlert(giftId: UserDefaults.standard.giftID!)
                        }
                    }
                }
                
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
                
            } else {
                DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                    navigationController?.popViewController(animated: true)
                }

            }

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
}
