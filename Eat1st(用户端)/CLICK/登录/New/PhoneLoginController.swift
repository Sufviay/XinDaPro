//
//  PhoneLoginController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/12/7.
//

import UIKit
import RxSwift
import SnapKit


class PhoneLoginController: BaseViewController, UITextFieldDelegate {

    private let bag = DisposeBag()
    
    var countryList: [CountryModel] = [] {
        didSet {
            areaAlert.dataArr = countryList
        }
    }
    
    var countryCode: String = ""
    var areaCode: String = "" {
        didSet {
            areaNumLab.text = areaCode
        }
    }
    
    var phoneNum: String = "" {
        didSet {
            inputTF.text = phoneNum
            if phoneNum != "" {
                nextBut.isEnabled = true
                nextBut.backgroundColor = MAINCOLOR
            } else {
                nextBut.isEnabled = false
                nextBut.backgroundColor = HCOLOR("EBEBEB")
            }
        }
    }
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("login_back_b"), for: .normal)
        return but
    }()
    
    private let welcomImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("welcome_b")
        return img
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
        but.setCommentStyle(.zero, "Next", .white, BFONT(15), HCOLOR("#EBEBEB"))
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
    
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.placeholder = "Please enter the phone number"
        tf.keyboardType = .numberPad
        tf.textColor = HCOLOR("#333333")
        tf.delegate = self
        return tf
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
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
        //loadCountryList_Net()
    }
    
    private func setUpUI() {
        naviBar.isHidden = true
    
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        view.addSubview(welcomImg)
        welcomImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(backBut.snp.bottom).offset(R_H(40))
            $0.size.equalTo(CGSize(width: R_W(250), height: SET_H(26, 250)))
        }
       
        
        view.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(welcomImg.snp.bottom).offset(R_H(55))
        }
        
        tlab.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(welcomImg).offset(R_H(205))
            $0.height.equalTo(42)
        }
        
        
        view.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(95)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(40)
            $0.top.equalTo(welcomImg.snp.bottom).offset(R_H(125))
        }
        
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.equalTo(inputTF)
            $0.height.equalTo(1)
            $0.top.equalTo(inputTF.snp.bottom)
        }
        
        view.addSubview(areaBut)
        areaBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(inputTF.snp.left).offset(-10)
            $0.height.equalTo(60)
            $0.centerY.equalTo(inputTF)
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
        
        
        view.addSubview(xyView)
        xyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 280, height: 30))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    

    
    @objc private func clickAreaAction(sender: UIButton) {
        print(sender.frame)
        areaAlert.tap_H = sender.frame.maxY + 10
        areaAlert.appearAction()
    }
    

    
    @objc private func clickNextAction() {
        
        if inputTF.text ?? "" != "" {
            sendSMS_Net()
        }
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text ?? "" != "" {
            nextBut.isEnabled = true
            nextBut.backgroundColor = MAINCOLOR
        } else {
            nextBut.isEnabled = false
            nextBut.backgroundColor = HCOLOR("#EBEBEB")
        }
    
    }
    
    
    
    
    private func sendSMS_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.sendSMSCode(countryCode: countryCode, phone: inputTF.text!, type: "1").subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: view)

            let nextVC = LoginVeriCodeController()
            nextVC.countryCode = countryCode
            nextVC.areaCode = areaCode
            nextVC.phoneNum = inputTF.text!
            nextVC.smsID = json["data"]["smsId"].stringValue
            navigationController?.pushViewController(nextVC, animated: true)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    
//    func loadCountryList_Net() {
//
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.getCountryList().subscribe(onNext: { [unowned self] (json) in
//            HUD_MB.dissmiss(onView: view)
//
//            var tarr: [CountryModel] = []
//            for jsondata in json["data"].arrayValue {
//                let model = CountryModel()
//                model.updateModel(json: jsondata)
//                tarr.append(model)
//            }
//
//            countryList = tarr
//            areaAlert.dataArr = countryList
//
//            //获取当前国家Code
//            if let curCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                print(curCode)
//
//                let arr = countryList.filter { $0.countryCode == curCode }
//
//                if arr.count == 0 {
//                    countryCode = countryList.first?.countryCode ?? ""
//                    areaCode = countryList.first?.areaCode ?? ""
//                } else {
//                    countryCode = arr.first?.countryCode ?? ""
//                    areaCode = arr.first?.areaCode ?? ""
//                }
//
//            } else {
//                countryCode = countryList.first?.countryCode ?? ""
//                areaCode = countryList.first?.areaCode ?? ""
//            }
//
//        }, onError: { [unowned self] (error) in
//            countryCode = "GB"
//            areaCode = "+44"
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//        }).disposed(by: bag)
//    }

    
    
    
}
