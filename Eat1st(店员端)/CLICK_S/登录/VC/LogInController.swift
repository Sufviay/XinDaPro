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
    
    private var storeID: String = ""
    
    
    private let backImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
//        let m =  LOIMG("loginbg")
//        m.resizableImage(withCapInsets: UIEdgeInsets(top: 40, left: 50, bottom: 60, right: 50), resizingMode: .stretch)
//        img.image = m
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.textColor = HCOLOR("#262628")
        lab.textAlignment = .left
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            lab.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        } else {
            lab.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        }
    
        lab.text = "Sign In"
        return lab
    }()
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#9B9B9B"), SETFONT_B(15), .left)
        lab.text = "Store"
        return lab
    }()

    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#9B9B9B"), SETFONT_B(15), .left)
        lab.text = "Account"
        return lab
    }()
    
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#9B9B9B"), SETFONT_B(15), .left)
        lab.text = "Password"
        return lab
    }()
    
    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let view3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 15
        return view
    }()

    
    private let storeTF: UITextField = {
        let tf = UITextField()
        tf.font = SETFONT(14)
        tf.textColor = HCOLOR("#262628")
        tf.placeholder = "Select store"
        tf.isEnabled = false
        return tf
    }()
    

    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SETFONT(14)
        tf.textColor = HCOLOR("#262628")
        tf.placeholder = "Please enter the account number"
        tf.text = UserDefaults.standard.accountNum ?? ""
        return tf
    }()

    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.font = SETFONT(14)
        tf.isSecureTextEntry = true
        tf.textColor = HCOLOR("#262628")
        tf.placeholder = "Please enter password"
        return tf
    }()
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "SIGN IN", .white, BFONT(15), HCOLOR("#212121"))
        but.layer.cornerRadius = 15
        return but
    }()
    
    private let storeXLBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("xl"), for: .normal)
        return but
    }()
    
    private let accountXLBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("xl"), for: .normal)
        return but
    }()
    
    
    
    
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
    
    
    private lazy var storeAlert: StoreListView = {
        let view = StoreListView()
    
        view.selectBlock = { [unowned self] (dic) in
            let info = dic as! [String: Any]
            storeID = info["id"] as! String
            storeTF.text = info["name"] as? String
        }
        
        return view
    }()
    
    
    private lazy var waiterAlert: WaiterListView = {
        let view = WaiterListView()
        view.selectBlock = {  [unowned self] (account) in
            emailTF.text = account
        }
        return view
    }()

    
    
    
    override func setViews() {
        self.naviBar.isHidden = true
        self.setUpUI()
        addNotification()
        
    }
    
    private func setUpUI() {

        view.backgroundColor = MAINCOLOR
        
        var backImg = UIImage()
        var frame_W: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                backImg = LOIMG("loginbg_ipad_h")
                frame_W = UIScreen.main.bounds.width * 486 / 1194
            } else {
                backImg = LOIMG("loginbg_ipad")
                frame_W = UIScreen.main.bounds.width * 643 / 834
            }
        } else {
            backImg = LOIMG("loginbg")
            frame_W = UIScreen.main.bounds.width - 30
            
        }
        
        let backImg_Scale: CGFloat = backImg.size.width / backImg.size.height
        let frame_H: CGFloat = frame_W / backImg_Scale
        
        
        backImageView.image = backImg
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: frame_W, height: frame_H))
        }
        
    
        backImageView.addSubview(titLab)
        titLab.snp.makeConstraints {
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.left.equalToSuperview().offset(80)
                $0.top.equalToSuperview().offset(50)
            } else {
                $0.left.equalToSuperview().offset(50)
                $0.top.equalToSuperview().offset(30)
            }
        }
        
        
        backImageView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalTo(titLab)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalTo(titLab.snp.bottom).offset(50)
            } else {
                $0.top.equalTo(titLab.snp.bottom).offset(30)
            }
        }
        
        backImageView.addSubview(view1)
        view1.snp.makeConstraints {
            $0.left.equalTo(titLab)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.right.equalToSuperview().offset(-80)
                $0.top.equalTo(tlab1.snp.bottom).offset(15)
                $0.height.equalTo(50)
            } else {
                $0.right.equalToSuperview().offset(-50)
                $0.top.equalTo(tlab1.snp.bottom).offset(5)
                $0.height.equalTo(40)
            }
            
            
        }

        
        backImageView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(titLab)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalTo(view1.snp.bottom).offset(30)
            } else {
                $0.top.equalTo(view1.snp.bottom).offset(15)
            }
        }
        
        
        backImageView.addSubview(view2)
        view2.snp.makeConstraints {
            $0.left.equalTo(titLab)
            $0.right.equalTo(view1)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalTo(tlab2.snp.bottom).offset(15)
                $0.height.equalTo(50)
            } else {
                $0.top.equalTo(tlab2.snp.bottom).offset(5)
                $0.height.equalTo(40)
            }
        }
        
        
        backImageView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalTo(titLab)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalTo(view2.snp.bottom).offset(30)
            } else {
                $0.top.equalTo(view2.snp.bottom).offset(15)
            }
        }
        
        
        backImageView.addSubview(view3)
        view3.snp.makeConstraints {
            $0.left.equalTo(titLab)
            $0.right.equalTo(view1)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalTo(tlab3.snp.bottom).offset(15)
                $0.height.equalTo(50)
            } else {
                $0.top.equalTo(tlab3.snp.bottom).offset(5)
                $0.height.equalTo(40)
            }
        }
        
        
        backImageView.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(view1)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.height.equalTo(50)
                $0.top.equalTo(view3.snp.bottom).offset(80)
            } else {
                $0.height.equalTo(40)
                $0.top.equalTo(view3.snp.bottom).offset(40)
            }
        }
        
        
        view1.addSubview(storeXLBut)
        storeXLBut.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.equalTo(80)
            } else {
                $0.width.equalTo(40)
            }
        }
        
        view2.addSubview(accountXLBut)
        accountXLBut.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.equalTo(80)
            } else {
                $0.width.equalTo(40)
            }
        }


        
        view1.addSubview(storeTF)
        storeTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(storeXLBut.snp.left).offset(0)
            $0.bottom.top.equalToSuperview()
        }

        
        view2.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(storeTF)
            $0.bottom.top.equalToSuperview()
        }
        
        view3.addSubview(passwordTF)
        passwordTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.top.equalToSuperview()
        }
        
        

        
        view.addSubview(b_biew)
        b_biew.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.equalTo(280)
        }

        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)
        accountXLBut.addTarget(self, action: #selector(clickAccountAction), for: .touchUpInside)
        storeXLBut.addTarget(self, action: #selector(clickStoreAction), for: .touchUpInside)
    }
    
    
    @objc private func clickStoreAction() {
        getStoreList_Net()
    }
    
    @objc private func clickAccountAction() {
        getWaiterList_Net()
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
    
            HUD_MB.showSuccess("Success", onView: view)
            UserDefaults.standard.token = json["data"]["token"].stringValue
            UserDefaults.standard.accountNum = self.emailTF.text!
            UserDefaults.standard.isLogin = true
            UserDefaults.standard.userName = json["data"]["name"].stringValue
            UserDefaults.standard.userID = json["data"]["businessId"].stringValue
            
            let nextVC = DeskListController()
            self.navigationController?.setViewControllers([nextVC], animated: true)

        }, onError: {[unowned self]  (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }

    
    //获取店铺列表
    private func getStoreList_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tarr: [StoreModel] = []
            for jsonData in json["data"].arrayValue {
                let model = StoreModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            storeAlert.dataArr = tarr
            storeAlert.appearAction()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: bag)
    }
    
    
    //获取店员列表
    private func getWaiterList_Net() {
        
        if storeID == "" {
            HUD_MB.showWarnig("Please select a store", onView: view)
            return
        }
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getWaiterList(id: storeID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tarr: [WaiterModel] = []
            for jsonData in json["data"].arrayValue {
                let model = WaiterModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            waiterAlert.dataArr = tarr
            waiterAlert.appearAction()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: bag)
    }
    
    
    deinit {
        print("\(self.classForCoder) 销毁")
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
    }
        
    private func addNotification() {
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    
    @objc private func orientationDidChange() {
        
        switch UIDevice.current.orientation {
        case .unknown:
            print("未知")
        case .portrait:
            print("竖屏")
            updateFrame()
        case .portraitUpsideDown:
            print("颠倒竖屏")
            updateFrame()
        case .landscapeLeft:
            print("左旋转 横屏")
            updateFrame()
        case .landscapeRight:
            print("右旋转 横屏")
            updateFrame()
        case .faceUp:
            print("屏幕朝上")
        case .faceDown:
            print("屏幕朝下")
        default:
            break
        }
        
    }
    
    
    private func updateFrame() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            DispatchQueue.main.async {
                var backImg = UIImage()
                var frame_W: CGFloat = 0
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                    backImg = LOIMG("loginbg_ipad_h")
                    frame_W = UIScreen.main.bounds.width * 486 / 1194
                } else {
                    backImg = LOIMG("loginbg_ipad")
                    frame_W = UIScreen.main.bounds.width * 643 / 834
                }
                let backImg_Scale: CGFloat = backImg.size.width / backImg.size.height
                let frame_H: CGFloat = frame_W / backImg_Scale
                
                self.backImageView.image = backImg
                self.backImageView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.size.equalTo(CGSize(width: frame_W, height: frame_H))
                }
            }
        }
    }
}
