//
//  OnOffTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/9.
//

import UIKit

class OnOffTagView: UIView {
    

    var clickBlock: VoidStringBlock?
    
    
    
    private var type: String = "on" {
        didSet {
            if type == "on" {
                self.line1.isHidden = false
                self.line2.isHidden = true
                self.onBut.setTitleColor(TXTCOLOR_1, for: .normal)
                self.onBut.titleLabel?.font = TIT_2
                self.offBut.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.offBut.titleLabel?.font = TXT_1
            }
            
            if type == "off" {
                self.line2.isHidden = false
                self.line1.isHidden = true
                self.offBut.setTitleColor(TXTCOLOR_1, for: .normal)
                self.offBut.titleLabel?.font = TIT_2
                self.onBut.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.onBut.titleLabel?.font = TXT_1
            }
        }
    }

    private let onBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "On menu now".local, TXTCOLOR_1, TIT_2, .clear)
        return but
    }()
    
    private let offBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Off menu".local, HCOLOR("#6F7FAF"), TXT_1, .clear)
        return but
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(onBut)
        onBut.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(100)
        }
        
        self.addSubview(offBut)
        offBut.snp.makeConstraints {
            $0.size.equalTo(onBut)
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(onBut.snp.right).offset(10)
        }
        
        
        self.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(onBut)
        }
        
        
        self.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(offBut)
        }
        
        

        onBut.addTarget(self, action: #selector(clickOnAction), for: .touchUpInside)
        offBut.addTarget(self, action: #selector(clickOffAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickOnAction() {
        
        if self.type != "on" {
            self.type = "on"
            clickBlock?(type)
        }
        
    }
    
    @objc private func clickOffAction() {
        if self.type != "off" {
            self.type = "off"
            clickBlock?(type)
        }
    }
    
    
}
