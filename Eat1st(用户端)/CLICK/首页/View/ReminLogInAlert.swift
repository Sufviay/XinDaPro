//
//  ReminLogInAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/29.
//

import UIKit

class ReminLogInAlert: BaseAlertView, UIGestureRecognizerDelegate {

    
    var clickBlock: VoidBlock?
    
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
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.text = "Login to remind"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        let tempStr = "You have not logged in yet, \nplease log in first!"
        lab.attributedText = tempStr.attributedString(font: SFONT(14), textColor: FONTCOLOR, lineSpaceing: 5, wordSpaceing: 0)
        lab.textAlignment = .center
        return lab
    }()

    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Log in", FONTCOLOR, BFONT(15), .clear)
        return but
    }()
    
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 270, height: 175))
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
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-45)
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
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        sureBut.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)
        
    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    @objc private func clickSureAction() {
        disAppearAction()
        clickBlock?("")
    }

}
