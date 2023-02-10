//
//  LogInController.swift
//  PROJECT_B
//
//  Created by 肖扬 on 2023/1/5.
//

import UIKit
import RxSwift
import MessageUI



class LoginBottomView: UIView {

    
    var clickBlock: VoidStringBlock?
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(11), .left)
        lab.text = "By continuing, you are indicating that you accept our "
        return lab
    }()
    
    private let fwBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Terms of Service", HCOLOR("#317213"), SFONT(11), .clear)
        return but
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(11), .left)
        lab.text = "and "
        return lab
    }()
    
    private let ysBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Privacy Policy", HCOLOR("#317213"), SFONT(11), .clear)
        return but
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        
        self.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }
        
        self.addSubview(fwBut)
        fwBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(tlab1.snp.bottom).offset(0)
        }
        
        
        self.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(fwBut.snp.right)
            $0.centerY.equalTo(fwBut)
        }
        
        self.addSubview(ysBut)
        ysBut.snp.makeConstraints {
            $0.left.equalTo(tlab2.snp.right)
            $0.centerY.equalTo(tlab2)
        }
        
        fwBut.addTarget(self, action: #selector(clickFWAciton), for: .touchUpInside)
        ysBut.addTarget(self, action: #selector(clickYSAction), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 服务
    @objc private func clickFWAciton() {
        clickBlock?("fw")
    }
    
    //MARK: - 隐私
    @objc private func clickYSAction() {
        clickBlock?("ys")
    }

}



class LogInController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let bag = DisposeBag()
    
    private var pwHide: Bool = true
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.image = LOIMG("backImg")
        return img
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("logo")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#317213"), BFONT(26), .center)
        lab.text = "SUPPALLY"
        return lab
    }()
    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = HCOLOR("#68B346").cgColor
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = HCOLOR("#68B346").cgColor
        return view
    }()
    
    private let loginBut: UIButton = {
        let but = UIButton()
        but.setBackgroundImage(GRADIENTCOLOR(HCOLOR("#64B046"), HCOLOR("#AEE845"), CGSize(width: S_W - 90, height: 40)), for: .normal)
        but.setTitle("登錄", for: .normal)
        but.titleLabel?.textColor = .white
        but.titleLabel?.font = BFONT(16)
        but.clipsToBounds = true
        but.layer.cornerRadius = 20
        return but
    }()
    
    
    private let getZHBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#6EB550"), BFONT(15), .center)
        lab.text = "Get an account"
        return lab
    }()
    
    private let tLine: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("6EB550")
        return view
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next"), for: .normal)
        return but
    }()
    
    private lazy var xyView: LoginBottomView = {
        let tview = LoginBottomView()
        
        tview.clickBlock = { [unowned self] (str) in
            if str == "ys" {
                print("ys")
                
                let webVC = ServiceController()
                webVC.modalPresentationStyle = .fullScreen
                webVC.titStr = "Privacy Policy"
                webVC.webUrl = "https://www.suppally.com/deal/privacy_policy.html"
                self.present(webVC, animated: true, completion: nil)
            }
            
            if str == "fw" {
                print("fw")
                
                let webVC = ServiceController()
                webVC.modalPresentationStyle = .fullScreen
                webVC.titStr = "Terms of Service"
                webVC.webUrl = "https://www.suppally.com/deal/terms_of_service.html"
                self.present(webVC, animated: true, completion: nil)
            }
        }
        
        return tview
        
    }()
    
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("phone")
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("password")
        return img
    }()
    
    private let zhInput: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(12)
        tf.placeholder = "請輸入手機號(Mobile Phone)"
        return tf
    }()
    
    
    private let pwInput: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(12)
        tf.placeholder = "請輸入密碼(Password)"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    private let hideBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("hide"), for: .normal)
        return but
    }()
    

    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()

    }
    
    private func setUpUI() {
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        view.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 80))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 100)
        }
        
        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImg.snp.bottom).offset(15)
        }
        
        view.addSubview(view1)
        view1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-45)
            $0.height.equalTo(40)
            $0.top.equalTo(logoImg.snp.bottom).offset(70)
        }
        
        view.addSubview(view2)
        view2.snp.makeConstraints {
            $0.left.right.height.equalTo(view1)
            $0.top.equalTo(view1.snp.bottom).offset(10)
        }
        
        view.addSubview(loginBut)
        loginBut.snp.makeConstraints {
            $0.left.right.equalTo(view1)
            $0.height.equalTo(40)
            $0.top.equalTo(view2.snp.bottom).offset(50)
        }
        
        view1.addSubview(img1)
        img1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.size.equalTo(CGSize(width: 14, height: 20))
        }
        
        view2.addSubview(img2)
        img2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.size.equalTo(CGSize(width: 16, height: 18))
        }
        
        
        
        view1.addSubview(zhInput)
        zhInput.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(1)
            $0.bottom.equalToSuperview().offset(-1)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        view2.addSubview(hideBut)
        hideBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 35))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }

   
        view2.addSubview(pwInput)
        pwInput.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(1)
            $0.bottom.equalToSuperview().offset(-1)
            $0.right.equalTo(hideBut.snp.left).offset(-5)
        }
        
        
        
        view.addSubview(xyView)
        xyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 280, height: 30))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }

        
        view.addSubview(getZHBut)
        getZHBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 40))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(xyView.snp.top).offset(-120)
        }
        
        getZHBut.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        getZHBut.addSubview(tLine)
        tLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-8)
        }

        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalTo(getZHBut)
            $0.left.equalTo(getZHBut.snp.right).offset(0)
        }

        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        hideBut.addTarget(self, action: #selector(clickHideAction), for: .touchUpInside)
        loginBut.addTarget(self, action: #selector(clickLogInAction), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickGetAccountAction), for: .touchUpInside)
        getZHBut.addTarget(self, action: #selector(clickGetAccountAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "back"), object: nil)
        self.dismiss(animated: true)
    }
    
    
    @objc private func clickHideAction() {
        pwHide = !pwHide
        self.pwInput.isSecureTextEntry = pwHide
        if pwHide {
            self.hideBut.setImage(LOIMG("hide"), for: .normal)
        } else {
            self.hideBut.setImage(LOIMG("open"), for: .normal)
        }
        
    }
    
    
    @objc private func clickLogInAction() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLogIn(user: zhInput.text ?? "", pw: pwInput.text ?? "").subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            
            let jsonOJ = json["data"].dictionaryObject
            let jsonStr = PJCUtil.convertDictionaryToString(dict: jsonOJ)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "login"), object: jsonStr)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    @objc private func clickGetAccountAction() {
        //发送邮件
        sendEmail()
    }
    
    
    
    private func sendEmail() {
    
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let emailVC = MFMailComposeViewController()
            //设置代理
            emailVC.mailComposeDelegate = self
            //设置主题
            emailVC.setSubject("#Suppally\nGet an Account")
            //设置收件人
            emailVC.setToRecipients(["admin@suppally.com"])
             
            //打开界面
            self.present(emailVC, animated: true, completion: nil)
        }else{
            print("不支持")
            HUD_MB.showWarnig("Sending email is unavailable!", onView: self.view)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        if result == .sent {
            HUD_MB.showSuccess("Success", onView: view)
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .failed {
            HUD_MB.showError("Failed", onView: view)
        }
        if result == .saved {
            HUD_MB.showSuccess("Saved", onView:  view)
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .cancelled {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    
}
