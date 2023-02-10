//
//  AddressAlertView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/17.
//

import UIKit

class AddressAlertView: BaseAlertView {

    var clickSureBlock: VoidStringBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let yesBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "YES", MAINCOLOR, SFONT(16), .clear)
        return but
    }()
    
    private let noBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "NO", FONTCOLOR, SFONT(16), .clear)
        return but
    }()

    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .center)
        lab.text = "This address is out of the distribution range. Do you want to save it?"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    

    override func setViews() {
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 300, height: 150))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(0.5)
            $0.top.equalTo(line1.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(yesBut)
        yesBut.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.top.equalTo(line1.snp.bottom)
            $0.right.equalTo(line2.snp.left)
        }
        
        backView.addSubview(noBut)
        noBut.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.top.equalTo(line1.snp.bottom)
            $0.left.equalTo(line2.snp.right)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-41)
        }
        
        yesBut.addTarget(self, action: #selector(clickYESAction), for: .touchUpInside)
        noBut.addTarget(self, action: #selector(clickNOAciton), for: .touchUpInside)

    }
    
    
    @objc private func clickYESAction() {
        self.disAppearAction()
        self.clickSureBlock?("yes")
    }

    
    @objc private func clickNOAciton() {
        self.disAppearAction()
        self.clickSureBlock?("no")
    }
    
    
}
