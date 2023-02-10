//
//  FirstBannerTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

//import FirebaseAuthUI
//import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI


class FirstBannerTableCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    private let lunboView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("banner")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#323232")
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 55), byRoundingCorners: [.topLeft, .topRight], radii: 6)
        return view
    }()
    
    private let s_Img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("login_simg")
        return img
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F4D4BE"), SFONT(14), .left)
        lab.text = "Please log in"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F4D4BE"), SFONT(12), .left)
        lab.text = "There is a discount for membership"
        return lab
    }()
    
    private let logInBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Login", .white, SFONT(14), HCOLOR("#E8670D"))
        but.layer.cornerRadius = 15
        return but
    }()
    
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        
        contentView.addSubview(lunboView)
        lunboView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        
        contentView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        tView.addSubview(s_Img)
        s_Img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 36, height: 36))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        tView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.top.equalToSuperview().offset(7)
        }
        
        tView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.bottom.equalToSuperview().offset(-7)
        }
        
        tView.addSubview(logInBut)
        logInBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 75, height: 30))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }

        logInBut.addTarget(self, action: #selector(clickLoginAciton), for: .touchUpInside)
        
    }
    
    
    func setCellData() {
        tView.isHidden = true
        
//        if UserDefaults.standard.token ?? "" == "" {
//            self.tView.isHidden = false
//        } else {
//            self.tView.isHidden = true
//        }
    }
    
    
    @objc private func clickLoginAciton() {
        
        clickBlock?("")
//        
//        let loginVC = LogInController()
//        loginVC.modalPresentationStyle = .fullScreen
//        PJCUtil.currentVC()?.present(loginVC, animated: true, completion: nil)
    
    }
    
    
}
