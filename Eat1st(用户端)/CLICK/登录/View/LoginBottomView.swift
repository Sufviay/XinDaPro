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
        lab.setCommentStyle(HCOLOR("999999"), SFONT(11), .left)
        lab.text = "By continuing, you are indicating that you accept our "
        return lab
    }()
    
    private let fwBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Terms of Service", MAINCOLOR, SFONT(11), .clear)
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
        but.setCommentStyle(.zero, "Privacy Policy", MAINCOLOR, SFONT(11), .clear)
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
