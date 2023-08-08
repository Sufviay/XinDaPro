//
//  LogInController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import RxSwift



class LogInController: BaseViewController {

    private let bag = DisposeBag()
    
    private var isShow: Bool = true
    
    
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("BG")
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let textImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("Welcome")
        img.contentMode = .scaleToFill
        return img
    }()

    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#69707F"), BFONT(12), .left)
        lab.text = "Username"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#69707F"), BFONT(12), .left)
        lab.text = "Password"
        return lab
    }()

    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7FB")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7FB")
        view.layer.cornerRadius = 5
        return view
    }()
    
    

    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("#3A3A3A")
        tf.placeholder = "Please enter the account number"
        tf.text = UserDefaults.standard.accountNum ?? ""
        return tf
    }()
    
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.isSecureTextEntry = true
        tf.textColor = HCOLOR("#3A3A3A")
        tf.placeholder = "Please enter password"
        return tf
    }()
    
    
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Sign in", .white, BFONT(14), HCOLOR("#FA4169"))
        but.layer.cornerRadius = 25
        return but
    }()
    
    
    private let chooseDateBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Select Date", .white, BFONT(14), HCOLOR("#FA4169"))
        but.layer.cornerRadius = 25
        but.isHidden = true
        return but
    }()

    
    //日历弹窗
    private lazy var calendarView: DiscountSelectDateView = {
        let view = DiscountSelectDateView()
        view.clickDateBlock = { [unowned self] (par) in
            let date = par as! Date
            self.chooseDateBut.setTitle(date.getString("yyyy-MM-dd"), for: .normal)
            self.parDate = date.getString("yyyy-MM-dd")
        }
        return view
    }()
    
    
    private var parDate: String = ""
    

    
    private lazy var b_biew: LoginBottomView = {
        let view = LoginBottomView()
        
        view.clickBlock = { [unowned self] (type) in
            if type == "tk" {
                //MARK: -  Terms and Conditions
                print("Terms and Conditions")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Terms of Service"
                nextVC.webUrl = "http://deal.foodo2o.com/terms_of_service.html"
                self.present(nextVC, animated: true, completion: nil)
                
            }
            
            if type == "Privacy" {
                //MARK: - Privacy Policy
                print("Privacy Policy")
                
                let nextVC =  XYViewController()
                nextVC.titStr = "Privacy Policy"
                nextVC.webUrl = "http://deal.foodo2o.com/privacy_policy.html"
                self.present(nextVC, animated: true, completion: nil)
            }
        }
        return view
    }()
    
    
    
    override func setViews() {
        self.naviBar.isHidden = true
        self.setUpUI()
        
    }
    
    private func setUpUI() {
        
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(textImg)
        textImg.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(R_H(115))
        }
        
        
        view.addSubview(view1)
        view1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(textImg.snp.bottom).offset(R_H(60))
            $0.height.equalTo(55)
        }
        
        view.addSubview(view2)
        view2.snp.makeConstraints {
            $0.left.right.height.equalTo(view1)
            $0.top.equalTo(view1.snp.bottom).offset(R_H(25))
        }
        
        

        view1.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        view2.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
    
        
        view1.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(tlab1.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
        
        view2.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(tlab2.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
        
        
        view.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(view1)
            $0.top.equalTo(view2.snp.bottom).offset(R_H(30))
            $0.height.equalTo(50)
        }
        
        view.addSubview(chooseDateBut)
        chooseDateBut.snp.makeConstraints {
            $0.size.centerX.equalTo(loginBut)
            $0.top.equalTo(loginBut.snp.bottom).offset(50)
        }
        
        
        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)

        chooseDateBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDateAction() {
        calendarView.appearAction()
    }
    
    
    //MARK: - 登录
    @objc private func clickLogInAction() {
        print("login")
        
        if emailTF.text == "" {
            HUD_MB.showWarnig("Please fill in your account number.", onView: self.view)
            return
        }
        
        if passwordTF.text == "" {
            HUD_MB.showWarnig("Please fill in your password.", onView: self.view)
            return
        }

        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLogIn(user: emailTF.text!, pw: passwordTF.text!).subscribe(onNext: { [unowned self] (json) in
    
            
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.accountNum = self.emailTF.text!
            
            HTTPTOOl.getInputDataStatus(date: parDate).subscribe(onNext: { [unowned self] (json) in
                
                
                UserDefaults.standard.userName = json["data"]["storeCode"].stringValue
                
                let model = FeeTypeResultModel.sharedInstance
                model.updateModel(json: json)
                
                if model.dayResultList.count == 0 {
                    HUD_MB.showWarnig("There's no reporting date！", onView: self.view)
                } else {
                    HUD_MB.showSuccess("Success!", onView: self.view)
                    
                    let firstDate = model.dayResultList.first!
                    
                    UserDefaults.standard.stepCount = firstDate.stepCount
                    
                    let subModel = DayDataModel()
                    subModel.date = firstDate.date
                    subModel.nameList = firstDate.nameList
                    subModel.dayList = model.platTypeList

                    
                    if firstDate.saturday {
                        //是周六
                        if firstDate.writeDay {
                            // 已完成
                            let completeVC = CompletedController()
                            completeVC.dataModel = subModel
                            self.navigationController?.setViewControllers([completeVC], animated: true)
                        } else {
                            // 未填写

                            let firstVC = SaturdayController1()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            self.navigationController?.setViewControllers([firstVC], animated: true)
                        }

                    } else {
                        //不是周六
                        
                        if firstDate.writeDay {
                            // 已完成
                            let completeVC = CompletedController()
                            completeVC.dataModel = subModel
                            self.navigationController?.setViewControllers([completeVC], animated: true)
                        } else {
                            //未填写
                                        
                            if model.platTypeList.count == 0 {
                                
                                
                                
                                //let firstVC = CashInController()
                                let firstVC = CashOutController()
                                firstVC.dataModel = subModel
                                firstVC.code = subModel.nameList[0]
                                self.navigationController?.setViewControllers([firstVC], animated: true)
                            } else {
                                let firstVC = JustEatsController()
                                firstVC.dataModel = subModel
                                firstVC.code = subModel.nameList[0]
                                self.navigationController?.setViewControllers([firstVC], animated: true)
                            }
                        }
                    }
                }
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
                   

        }, onError: {[unowned self]  (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }

    
    //MARK: - 忘记密码
    @objc private func clickForgetPwAciton() {
        
    }
    
    //MARK: - 联系我们
    @objc private func clickContactAction() {
        
    }
    
    deinit {
        print("\(self.classForCoder) 销毁")
    }

    
}
