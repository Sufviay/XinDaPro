//
//  DeleteAccountAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/9.
//

import UIKit
import RxSwift

class DeleteAccountAlert: UIView, UIGestureRecognizerDelegate, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var H: CGFloat = bottomBarH + 350

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 350), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("cart_cancel"), for: .normal)
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.numberOfLines = 0
        lab.text = "Please confirm the following\n before deleting your account"
        return lab
    }()
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "1. There are no outstanding orders"
        return lab
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "2. No assets in the account"
        return lab
    }()
    
    private let tLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "3. The account cannot be restored after being deleted"
        return lab
    }()
    
    private let applyBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Submit an application", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(40))
            $0.right.equalToSuperview().offset(-R_W(40))
            $0.top.equalToSuperview().offset(120)
        }
        
        backView.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.left.right.equalTo(tLab1)
            $0.top.equalTo(tLab1.snp.bottom).offset(15)
        }

        backView.addSubview(tLab3)
        tLab3.snp.makeConstraints {
            $0.left.right.equalTo(tLab1)
            $0.top.equalTo(tLab2.snp.bottom).offset(15)
        }

        
        backView.addSubview(applyBut)
        applyBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 230, height: 45))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH - 30)
        }
        
        closeBut.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        applyBut.addTarget(self, action: #selector(clickApplyAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickApplyAction() {
        
        self.showSystemAlert("WARNING", "We will review your application and your account will be frozen during the process.", "Confirm") {
            //提交申请
            HUD_MB.loading("", onView: PJCUtil.getWindowView())
            HTTPTOOl.deleteAccountApply().subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                DispatchQueue.main.async {
                    self.disAppearAction()
                }
                //登出账号
                UserDefaults.removeAll()
                FirebaseLoginManager.shared.doLogout()
                PJCUtil.currentVC()?.navigationController?.setViewControllers([FirstController()], animated: false)
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)
            
        }

    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
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
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
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
