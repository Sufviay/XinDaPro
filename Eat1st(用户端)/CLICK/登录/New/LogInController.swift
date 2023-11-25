//
//  LogInController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/9/26.
//

import UIKit
import RxSwift

class LogInController: BaseViewController, UITextFieldDelegate {

    
    private let bag = DisposeBag()
    
    private var countryList: [CountryModel] = []
    
    private var countryCode: String = ""
    private var areaCode: String = "" {
        didSet {
            areaNumLab.text = areaCode
        }
    }
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_back")
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: (S_H - SET_H(200, 375)) + 40), byRoundingCorners: [.topLeft, .topRight], radii: 24)
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
        but.setCommentStyle(.zero, "Next step", .white, BFONT(15), HCOLOR("#EBEBEB"))
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
    
    
    private let otherLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .center)
        lab.text = "Other login methods"
        return lab
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EFEFEF")
        return view
    }()
    
    private let line4: UIView = {
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
        
        faceBut.isHidden = true
        googleBut.isHidden = true
        twitterBut.isHidden = true
        otherLab.isHidden = true
        line4.isHidden = true
        line3.isHidden = true
        
        loadCountryList_Net()
    }
    
    private func setUpUI() {
        naviBar.isHidden = true
    
        
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(SET_H(200, 375))
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
            $0.height.equalTo((S_H - SET_H(200, 375)) + 40)
        }
        
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(R_H(60))
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
            $0.top.equalToSuperview().offset(R_H(230))
            $0.height.equalTo(42)
        }
        
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(95)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(R_H(140))
        }
        
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.equalTo(inputTF)
            $0.height.equalTo(1)
            $0.top.equalTo(inputTF.snp.bottom)
        }
        
        backView.addSubview(areaBut)
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
        
        backView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(75), height: 1))
            $0.centerY.equalTo(otherLab)
            $0.right.equalTo(otherLab.snp.left).offset(-15)
        }
        
        backView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.size.centerY.equalTo(line3)
            $0.left.equalTo(otherLab.snp.right).offset(15)
        }

        backView.addSubview(googleBut)
        googleBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(otherLab.snp.bottom).offset(20)
        }
        
        backView.addSubview(faceBut)
        faceBut.snp.makeConstraints {
            $0.size.centerY.equalTo(googleBut)
            $0.right.equalTo(googleBut.snp.left).offset(-40)
        }
        
        backView.addSubview(twitterBut)
        twitterBut.snp.makeConstraints {
            $0.size.centerY.equalTo(googleBut)
            $0.left.equalTo(googleBut.snp.right).offset(40)
        }
        
        
        faceBut.addTarget(self, action: #selector(clickFaceAction), for: .touchUpInside)
        googleBut.addTarget(self, action: #selector(clickGoogleAction), for: .touchUpInside)
        twitterBut.addTarget(self, action: #selector(clickTwitterAction), for: .touchUpInside)
        areaBut.addTarget(self, action: #selector(clickAreaAction(sender:)), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.dismiss(animated: true)
    }
    
    
    @objc private func clickFaceAction() {
        
    }
    
    @objc private func clickGoogleAction() {
        
    }
    
    @objc private func clickTwitterAction() {
        
    }


    
    @objc private func clickAreaAction(sender: UIButton) {
        print(sender.frame)
        areaAlert.tap_H = sender.frame.maxY + SET_H(200, 375) - 40
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
        HTTPTOOl.sendSMSCode(countryCode: countryCode, phone: inputTF.text!).subscribe(onNext: { [unowned self] (json) in
            
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
