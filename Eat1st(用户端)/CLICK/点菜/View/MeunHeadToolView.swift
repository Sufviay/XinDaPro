//
//  MeunHeadToolView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/3.
//

import UIKit

class MeunHeadToolView: UIView {
    
    
    var backBlock: VoidBlock?
    
    var searchBlock: VoidBlock?
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        but.backgroundColor = .clear
        return but
    }()
    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_search"), for: .normal)
        but.backgroundColor = .clear
        return but
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(17), .center)
        lab.isHidden = true
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = MAINCOLOR.withAlphaComponent(0)
        
        self.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.size.bottom.equalTo(backBut)
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalTo(searchBut)
            $0.centerX.equalToSuperview()
        }
        
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickBackAction() {
        backBlock?("")
        
    }
    
    @objc private func clickSearchAction() {
        searchBlock?("")
    }
    
    
}
