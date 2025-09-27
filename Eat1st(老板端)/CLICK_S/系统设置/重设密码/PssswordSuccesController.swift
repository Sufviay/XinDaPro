//
//  PssswordSuccesController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/18.
//

import UIKit
import RxSwift

class PssswordSuccesController: BaseViewController {

    private let bag = DisposeBag()
    
    private let successImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("success")
        return img
    }()
    
    private let okBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "OK".local, .white, TIT_3, MAINCOLOR)
        but.layer.cornerRadius = 15
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .center)
        lab.numberOfLines = 0
        lab.text = "Reset password successful,\nplease return to login.".local
        return lab
    }()
    
    
    override func setNavi() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func setViews() {
        naviBar.isHidden = true
        
        
        view.addSubview(successImg)
        successImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 70))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        view.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(successImg.snp.bottom).offset(15)
        }
        
        view.addSubview(okBut)
        okBut.snp.makeConstraints {
            $0.top.equalTo(successImg.snp.bottom).offset(100)
            $0.height.size.equalTo(CGSize(width: 205, height: 45))
            $0.centerX.equalToSuperview()
        }
        
        okBut.addTarget(self, action: #selector(clickOKAction), for: .touchUpInside)
    }
    
    
    @objc private func clickOKAction() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLogOut().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)

            UserDefaults.standard.isLogin = false
            UserDefaults.standard.removeObject(forKey: Keys.userName)
            UserDefaults.standard.removeObject(forKey: Keys.token)
            UserDefaults.standard.removeObject(forKey: Keys.userType)
            UserDefaults.standard.removeObject(forKey: Keys.userAuth)
            UserDefaults.standard.removeObject(forKey: Keys.storeName)
            UserDefaults.standard.removeObject(forKey: Keys.userRole)
            PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
        
        
    }
    
    
    
    
    
    
}
