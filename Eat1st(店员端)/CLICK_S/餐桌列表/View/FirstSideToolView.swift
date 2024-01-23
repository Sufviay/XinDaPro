//
//  FirstSideToolView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit
import RxSwift

class FirstSideToolView: UIView, UIGestureRecognizerDelegate, SystemAlertProtocol {

    private let bag = DisposeBag()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: R_W(320), height: S_H), byRoundingCorners: [.topRight, .bottomRight], radii: 20)
        return view
    }()

    
    private let W = R_W(320)
    
    
    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.backgroundColor = .clear
        img.image = LOIMG("icon")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(17), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "\(UserDefaults.standard.userName ?? "")"
        return lab
    }()

    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Number:\(UserDefaults.standard.userID ?? "")"
        return lab
    }()
    
    
    private let logoutBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.15)
        but.clipsToBounds = true
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let outImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("logout")
        return img
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next")
        return img
    }()
    
    
    let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(14), .left)
        lab.text = "Logout"
        return lab
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpUI() {
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        let leftRe = UISwipeGestureRecognizer.init(target: self, action: #selector(tapAction))
        leftRe.direction = .left
        self.backView.addGestureRecognizer(leftRe)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(W)
            $0.left.equalToSuperview().offset(-W)
        }
        
        backView.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 58, height: 58))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(statusBarH + 60)
        }

        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(headerImg.snp.right).offset(15)
            $0.top.equalTo(headerImg.snp.top).offset(8)
            $0.right.equalToSuperview().offset(39)
        }
        
        backView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(3)
        }
        
        
        backView.addSubview(logoutBut)
        logoutBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
        }
        
        logoutBut.addSubview(outImg)
        outImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 28, height: 28))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        logoutBut.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 8, height: 14))
        }
        
        logoutBut.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(55)
        }
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longpressAction))
        headerImg.addGestureRecognizer(longTap)
        
        logoutBut.addTarget(self, action: #selector(clickLogoutAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLogoutAction() {
        //退出
        showSystemChooseAlert("Tip", "Log Out or Not", "YES", "NO") { [unowned self] in
            disAppearAction()
            HUD_MB.loading("", onView: PJCUtil.getWindowView())
            HTTPTOOl.userLogOut().subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())

                UserDefaults.standard.isLogin = false
                UserDefaults.standard.removeObject(forKey: Keys.userName)
                UserDefaults.standard.removeObject(forKey: Keys.token)
                UserDefaults.standard.removeObject(forKey: Keys.userID)
                PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)
        }

        
    }
    
    
    @objc func longpressAction() {
        let d_ID = MYVendorToll.getIDFV() ?? ""
        let token = UserDefaults.standard.token ?? ""
        PJCUtil.wishSeed(str: d_ID + "\n" + token)
    }
    

    @objc func tapAction() {
        disAppearAction()
    }


    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.left.equalToSuperview().offset(0)
                $0.width.equalTo(self.W)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    func appearAction() {
        addWindow()
    }
    
    
    func disAppearAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.left.equalToSuperview().offset(-self.W)
                $0.width.equalTo(self.W)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    

}
