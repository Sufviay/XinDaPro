//
//  SalesSideToolView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/3.
//

import UIKit
import RxSwift


class SalesSideToolView: UIView, UIGestureRecognizerDelegate, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private let W = R_W(320)
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: R_W(320), height: S_H), byRoundingCorners: [.topRight, .bottomRight], radii: 20)
        return view
    }()

    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F7FB")
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xs_headimg")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = UserDefaults.standard.userName
        return lab
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_12, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = UserDefaults.standard.accountNum
        return lab
    }()

    private let logoutBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let logoutImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xs_logout")
        return img
    }()
    
    private let logoutLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "LOG OUT".local
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
        
        backView.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(R_H(80))
            $0.top.equalToSuperview().offset(statusBarH + R_H(40))
        }

        headView.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 42, height: 42))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        headView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(headImg.snp.right).offset(10)
            $0.top.equalTo(headImg).offset(5)
            $0.right.equalToSuperview().offset(-20)
        }
        
        headView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(2)
        }
        
        backView.addSubview(logoutBut)
        logoutBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 30)
            $0.height.equalTo(50)
        }
        
        logoutBut.addSubview(logoutImg)
        logoutImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        logoutBut.addSubview(logoutLab)
        logoutLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(logoutImg.snp.right).offset(15)
        }
        
        logoutBut.addTarget(self, action: #selector(clicklogoutAction), for: .touchUpInside)
    }
    
    
    
    @objc func tapAction() {
        disAppearAction()
    }

    
    @objc private func clicklogoutAction() {
        
        disAppearAction()
        //退出
        self.showSystemChooseAlert("Alert".local, "Do you want to log out?".local, "YES".local, "NO".local) {
            HUD_MB.loading("", onView: PJCUtil.getWindowView())
            HTTPTOOl.userLogOut().subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())

                UserDefaults.standard.isLogin = false
                UserDefaults.standard.removeObject(forKey: Keys.userName)
                UserDefaults.standard.removeObject(forKey: Keys.userAuth)
                UserDefaults.standard.removeObject(forKey: Keys.storeName)
                UserDefaults.standard.removeObject(forKey: Keys.userRole)

                PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)
        }


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
