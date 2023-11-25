//
//  LoginVeriCodeController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/25.
//

import UIKit
import RxSwift

class LoginVeriCodeController: BaseViewController {

    
    private let bag = DisposeBag()
    
    var phoneNum: String = ""
    var countryCode: String = ""
    var areaCode: String = ""
    var smsID: String = ""
    

    private var canGo: Bool = false {
        didSet {
            if canGo {
                nextBut.backgroundColor = MAINCOLOR
                nextBut.isEnabled = true
            } else {
                nextBut.backgroundColor = HCOLOR("#EBEBEB")
                nextBut.isEnabled = false
            }
        }
    }
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_fanhui"), for: .normal)
        return but
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(25), .left)
        lab.text = "Enter your\nVerifycation Code"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#CCCCCC"), SFONT(14), .left)
        lab.text = "Code has been sent to"
        return lab
    }()
    
    private let phoneNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "+44 - 1234567890"
        return lab
    }()
    
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Verify & Login", .white, BFONT(15), HCOLOR("#EBEBEB"))
        but.clipsToBounds = true
        but.layer.cornerRadius = 21
        but.isEnabled = false
        return but
    }()

    
    private let againBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Request again", MAINCOLOR, SFONT(11), .clear)
        return but
    }()
    
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#CCCCCC"), SFONT(11), .right)
        lab.text = "Didn't recieve code? "
        return lab
    }()
    
    
    private lazy var codeView: CRBoxInputView = {
        let inputView = CRBoxInputView(codeLength: 6)!
        inputView.backgroundColor = .clear
        let w = (S_W - 50 - R_W(14) * 5) / 6
        inputView.boxFlowLayout?.itemSize = CGSize(width: w , height: w)
        inputView.mainCollectionView()?.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        
        let cellProperty = CRBoxInputCellProperty()
        cellProperty.cornerRadius = 5
        cellProperty.borderWidth = 0
        
        cellProperty.cellBgColorNormal = HCOLOR("#F9F9F9")
        cellProperty.cellBgColorSelected = .white
        
        cellProperty.cellCursorColor = MAINCOLOR
        cellProperty.cellCursorWidth = 2
        cellProperty.cellCursorHeight = 20
        
        cellProperty.cellFont = BFONT(18)
        cellProperty.cellTextColor = FONTCOLOR
        
        //cellProperty.e
        
        cellProperty.configCellShadowBlock = { (layer) in
            
            layer.shadowColor = RCOLORA(0, 0, 0, 0.2).cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 5
            
        }
        
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepare(withBeginEdit: true)
        inputView.inputType = .number
        inputView.textContentType = .oneTimeCode
        
        //inputView.textValue = "345455"
        
        inputView.textDidChangeblock = { [unowned self] (text, isFinished) in
            
            canGo = isFinished
        }
        
        
        return inputView
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
            $0.top.equalTo(backBut.snp.bottom).offset(R_H(50))
        }
        
        view.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(tlab1.snp.bottom).offset(R_H(25))
        }
        
        view.addSubview(phoneNumLab)
        phoneNumLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.left.equalTo(tlab2.snp.right).offset(7)
        }
        
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(tlab1.snp.bottom).offset(R_H(150))
            $0.height.equalTo(42)
        }
        
        
        view.addSubview(againBut)
        againBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-R_W(90))
            $0.height.equalTo(30)
            $0.width.equalTo(80)
            $0.top.equalTo(nextBut.snp.bottom).offset(5)
        }
        
        view.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.centerY.equalTo(againBut)
            $0.right.equalTo(againBut.snp.left).offset(-5)
        }
        
        view.addSubview(codeView)
        codeView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.top.equalTo(tlab2.snp.bottom).offset(R_H(10))
            $0.height.equalTo((S_W - 50 - R_W(14) * 5) / 6 + 20)
        }
        
        
        phoneNumLab.text = "\(areaCode) - \(phoneNum)"

        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        againBut.addTarget(self, action: #selector(clickAgainAction), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickAgainAction() {
        //再次发送验证码
        sendSMS_Net()
                
    }
    
    @objc private func clickNextAction() {
        if codeView.textValue ?? "" != "" {
            login_Net()
        }
        
    }
    
    private func sendSMS_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.sendSMSCode(countryCode: countryCode, phone: phoneNum).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            smsID = json["data"]["smsId"].stringValue
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func login_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loginPhone(countryCode: countryCode, phone: phoneNum, smsCode: codeView.textValue ?? "", smsID: smsID).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.showSuccess("Success", onView: view)
            UserDefaults.standard.isLogin = true
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.userPhone = phoneNum
            NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            
            ///1 否 2 是
            let isNewUser = json["data"]["newType"].stringValue == "2" ? true : false
                    
            DispatchQueue.main.after(time: .now() + 1) { [unowned self] in
                
                if isNewUser {
                    let infoVC = PersonalInfoController()
                    infoVC.isCanEdite = true
                    navigationController?.pushViewController(infoVC, animated: true)
                } else {
                    self.dismiss(animated: true)
                }
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
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }
    
}


