//
//  OrderSelectTagView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/17.
//

import UIKit

class OrderSelectTagView: UIView {

    var clickTypeBlock: VoidBlock?
    
    private var selectType: String = "1" {
        didSet {
            if selectType == "1" {
                self.lineOne.isHidden = false
                self.lineTwo.isHidden = true
                self.butOne.setTitleColor(FONTCOLOR, for: .normal)
                self.butTwo.setTitleColor(MAINCOLOR, for: .normal)
            }
            if selectType == "2" {
                self.lineTwo.isHidden = false
                self.lineOne.isHidden = true
                self.butTwo.setTitleColor(FONTCOLOR, for: .normal)
                self.butOne.setTitleColor(MAINCOLOR, for: .normal)
            }
        
        }
    }
    
    private let butOne: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, BFONT(17), .clear)
        return but
    }()
    
    private let butTwo: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Collection", MAINCOLOR, BFONT(17), .clear)
        return but
    }()
    
    private let lineOne: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        view.isHidden = false
        return view
    }()
    
    private let lineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 55), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        
        self.addSubview(butOne)
        butOne.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(butTwo)
        butTwo.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(self.snp.centerX)
        }
        
        self.addSubview(lineOne)
        lineOne.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(butOne)
        }
        
        self.addSubview(lineTwo)
        lineTwo.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(butTwo)
        }
        
        butOne.addTarget(self, action: #selector(clickButOneAction), for: .touchUpInside)
        butTwo.addTarget(self, action: #selector(clickButTwoAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickButOneAction() {
        if selectType != "1" {
            self.selectType = "1"
            self.clickTypeBlock?("1")
        }
    }
    
    @objc private func clickButTwoAction() {
        if selectType != "2" {
            self.selectType = "2"
            self.clickTypeBlock?("2")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
