//
//  FirstHeaderTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class FirstHeaderTagView: UIView {
    
    var clickblock: VoidBlock?

    ///1 外卖 2自取
    private var type: String = "1" {
        didSet {
            if type == "1" {
                
                self.deBut.backgroundColor = .white
                self.deBut.setTitleColor(FONTCOLOR, for: .normal)
                self.coBut.backgroundColor = .clear
                self.coBut.setTitleColor(SFONTCOLOR, for: .normal)
            }
            if type == "2" {

                self.deBut.backgroundColor = .clear
                self.deBut.setTitleColor(SFONTCOLOR, for: .normal)
                self.coBut.backgroundColor = .white
                self.coBut.setTitleColor(FONTCOLOR, for: .normal)

            }
        }
    }
    
    
    private let deBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery order", FONTCOLOR, SFONT(13), .white)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let coBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Collection order", SFONTCOLOR, SFONT(13), .clear)
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = HCOLOR("#E1E1E1")
        
        self.layer.cornerRadius = 5
        
        self.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(2)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
            $0.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(coBut)
        coBut.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
            $0.right.equalToSuperview().offset(-2)
            
        }
        
        

        deBut.addTarget(self, action: #selector(clickDeButAction), for: .touchUpInside)
        coBut.addTarget(self, action: #selector(clickCoButAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickDeButAction() {
        if type != "1" {
            self.type = "1"
            clickblock?("de")
        }
    }
    
    @objc private func clickCoButAction() {
        if type != "2" {
            self.type = "2"
            clickblock?("co")
        }
        
    }
    
}
