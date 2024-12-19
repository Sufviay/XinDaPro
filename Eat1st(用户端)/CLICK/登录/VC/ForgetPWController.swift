//
//  ForgetPWController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit

class ForgetPWController: BaseViewController {

    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("log_backimg")
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(17), .left)
        lab.text = "All good -just enter the email address for your account and we'll send you a link reset it."
        lab.numberOfLines = 0
        return lab
    }()

    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(15)
        tf.textColor = FONTCOLOR
        tf.setPlaceholder("Please enter email address", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    
    private let setBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reset Password", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    
    
    override func setViews() {
        self.naviBar.isHidden = true
        setUpUI()
    }
    
    private func setUpUI() {
        
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        
        view.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.top.equalToSuperview().offset(statusBarH + R_H(210))
        }
        
        
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.top.equalToSuperview().offset(statusBarH + R_H(370))
            $0.height.equalTo(1)
        }

        view.addSubview(emailTF)
        emailTF.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(50)
        }
        
        view.addSubview(setBut)
        setBut.snp.makeConstraints {
            $0.left.right.equalTo(line1)
            $0.height.equalTo(45)
            $0.top.equalTo(line1.snp.bottom).offset(44)
        }
        
    }
    
}
