//
//  VersionAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/4.
//

import UIKit

class VersionAlert: BaseAlertView {

    
    private var isAppear: Bool = false
    
    var appUrlStr: String = ""
    var isMust: Bool = false {
        didSet {
            self.cancelBut.isHidden = isMust
        }
    }
    
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
        lab.text = "Update to remind"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        let tempStr = "The new version was found, \nplease update it"
        lab.attributedText = tempStr.attributedString(font: SFONT(14), textColor: FONTCOLOR, lineSpaceing: 3, wordSpaceing: 0)
        lab.textAlignment = .center
        return lab
    }()

    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Update", .white, BFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Don't update", MAINCOLOR, SFONT(13), .clear)
        return but
    }()

    
    
    override func setViews() {
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
        
        
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
    
    
    
    
    
//    @objc func tapAction() {
//        disAppearAction()
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (touch.view?.isDescendant(of: self.backView))! {
//            return false
//        }
//        return true
//    }
    
    
    func showAction() {
        if !isAppear {
            self.appearAction()
            self.isAppear = true
        }
    }
    
    @objc private func clickSureAction() {
        self.isAppear = false
        disAppearAction()
        goAppStore()

    }
    
    
    @objc private func clickCancelAction() {
        self.isAppear = false
        disAppearAction()
    }
    
    
    private func goAppStore() {
        
            guard let url = URL(string: appUrlStr) else { return }
            let can = UIApplication.shared.canOpenURL(url)
            if can {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:]) { (b) in
                        print("打开结果: \(b)")
                    }
                } else {
                    //iOS 10 以前
                    UIApplication.shared.openURL(url)
                }
            }
        }


}
