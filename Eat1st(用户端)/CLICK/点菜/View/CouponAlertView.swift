//
//  CouponAlertView.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/24.
//

import UIKit

class CouponAlertView: BaseAlertView {


    var clickBlock: VoidStringBlock?
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()

    private let tImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_Alert")
        return img
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.text = "Coupon remind"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        let tempStr = "There are coupons you can use"
        lab.attributedText = tempStr.attributedString(font: SFONT(14), textColor: FONTCOLOR, lineSpaceing: 3, wordSpaceing: 0)
        lab.textAlignment = .center
        return lab
    }()

    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Go to Use", .white, BFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Ignore", MAINCOLOR, SFONT(13), .clear)
        return but
    }()

    
    
    override func setViews() {
        
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 270, height: 200))
        }
        
        self.addSubview(tView)
        tView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backView.snp.top).offset(-20)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        tView.addSubview(tImg)
        tImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 35, height: 38))
        }
        
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(35)
        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titlab.snp.bottom).offset(15)
        }
        
        backView.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(desLab.snp.bottom).offset(15)
            $0.height.equalTo(35)
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.centerX.equalTo(sureBut)
            $0.top.equalTo(sureBut.snp.bottom).offset(5)
        }
        
        sureBut.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickSureAction() {
        clickBlock?("yes")
        disAppearAction()
    }
    
    @objc private func clickCancelAction() {
        clickBlock?("no")
        disAppearAction()
    }
    


}
