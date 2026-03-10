//
//  SalesFirstSelectView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/8.
//

import UIKit

class SalesFirstSelectView: UIView {

    
    var clickBlock: VoidBlock?
    
    
    private var curType: FirstPageShowType = .store
    
    private let but1: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "STORE", HCOLOR("#2B6BFE"), BFONT(14), .white)
        return but
    }()
    
    
    private let but2: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "PERSON", HCOLOR("#94959E"), BFONT(14), .white)
        return but
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("2B6BFE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("2B6BFE")
        view.isHidden = true
        return view
    }()

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(but1)
        but1.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(self.snp.centerX)
        }
        
        addSubview(but2)
        but2.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(but1.snp.right)
            
        }

        
        but1.addSubview(line1)
        line1.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 3))
        }
        
        
        but2.addSubview(line2)
        line2.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 3))
        }

        but1.addTarget(self, action: #selector(clickBut1Action), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickBut2Action), for: .touchUpInside)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickBut1Action() {
        if curType != .store {
            curType = .store
            
            but2.setTitleColor(HCOLOR("#94959E"), for: .normal)
            line2.isHidden = true
            
            but1.setTitleColor(HCOLOR("#2B6BFE"), for: .normal)
            line1.isHidden = false
            clickBlock?(curType)
            
        }
        
    }
    
    
    @objc private func clickBut2Action() {
        if curType != .person {
            curType = .person
            
            but1.setTitleColor(HCOLOR("#94959E"), for: .normal)
            line1.isHidden = true
            
            but2.setTitleColor(HCOLOR("#2B6BFE"), for: .normal)
            line2.isHidden = false
            clickBlock?(curType)
            
        }

    }

    
    
}
