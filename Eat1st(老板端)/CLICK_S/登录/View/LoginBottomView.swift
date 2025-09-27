//
//  LoginBottomView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit

class LoginBottomView: UIView {

    
    var clickBlock: VoidStringBlock?
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_2, .left)
        lab.text = "By continuing, you are indicating that you accept our ".local
        return lab
    }()
    
    private let tkBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Terms of Service".local, MAINCOLOR, TIT_5, .clear)
        return but
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_2, .left)
        lab.text = "and ".local
        return lab
    }()
    
    private let PrivacyBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Privacy Policy".local, MAINCOLOR, TIT_5, .clear)
        return but
    }()
    



    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        
        self.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }
        
        self.addSubview(tkBut)
        tkBut.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(tlab1.snp.bottom).offset(3)
        }
        
        self.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tkBut.snp.right).offset(5)
            $0.centerY.equalTo(tkBut)
        }

        self.addSubview(PrivacyBut)
        PrivacyBut.snp.makeConstraints {
            $0.left.equalTo(tlab2.snp.right)
            $0.centerY.equalTo(tlab2)
        }
        

        
        
        tkBut.addTarget(self, action: #selector(clickTKAciton), for: .touchUpInside)
        PrivacyBut.addTarget(self, action: #selector(clickXYAciton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 条款
    @objc private func clickTKAciton() {
        clickBlock?("tk")
    }
    
    //MARK: - Privacy Policy
    @objc private func clickXYAciton() {
        clickBlock?("Privacy")
    }
    
}
