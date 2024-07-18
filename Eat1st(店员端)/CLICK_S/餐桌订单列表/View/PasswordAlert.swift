//
//  PasswordAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/12.
//

import UIKit

class PasswordAlert: BaseAlertView, UIGestureRecognizerDelegate {
    
    
    var pwdBlock: VoidStringBlock?
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()

    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", MAINCOLOR, SETFONT_B(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", HCOLOR("#000000"), SETFONT_B(14), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SETFONT_B(14), .left)
        lab.text = "Password"
        return lab
    }()
    
    private let tfBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F5F5")
        view.layer.cornerRadius = 25
        return view
    }()
    
    
    private let pwdTF: UITextField = {
        let tf = UITextField()
        tf.font = SETFONT_B(14)
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.textColor = FONTCOLOR
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        addSubview(backView)
        backView.snp.makeConstraints {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.size.equalTo(CGSize(width: 500, height: 250))
            } else {
                $0.size.equalTo(CGSize(width: 300, height: 170))
            }
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
        }
        
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.bottom.equalToSuperview().offset(-20)
                $0.height.equalTo(50)
            } else {
                $0.bottom.equalToSuperview().offset(-10)
                $0.height.equalTo(40)
            }
            
            $0.right.equalTo(backView.snp.centerX).offset(-15)
            
        }
        
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(cancelBut)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(cancelBut)
        }
        
        
        backView.addSubview(tfBackView)
        tfBackView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.equalTo(400)
                $0.top.equalToSuperview().offset(70)
            } else {
                $0.width.equalTo(180)
                $0.top.equalToSuperview().offset(50)
            }
            
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalTo(tfBackView).offset(15)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.top.equalToSuperview().offset(30)
            } else {
                $0.top.equalToSuperview().offset(20)
            }
        }
        
        tfBackView.addSubview(pwdTF)
        pwdTF.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }

        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickCancelAction() {
        disAppearAction()
    }
    
    @objc private func clickConfirmAction() {
        if pwdTF.text ?? "" != "" {
            pwdBlock?(pwdTF.text!)
            disAppearAction()
        }
    }
    
    
    override func appearAction() {
        super.appearAction()
        pwdTF.text = ""
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
        
}
