//
//  StoreMainVipButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/5.
//

import UIKit

class StoreMainVipButCell: BaseTableViewCell {

    
    var clickBlock: VoidStringBlock?
    
    private var isOpen: Bool = false
    
//    private let yueBut: UIButton = {
//        let but = UIButton()
//        but.clipsToBounds = true
//        but.layer.cornerRadius = 7
//        but.layer.borderWidth = 1
//        but.layer.borderColor = MAINCOLOR.cgColor
//        but.backgroundColor = HCOLOR("#FFF6D4")
//        return but
//    }()
    
//    private let simg1: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("jinbi")
//        return img
//    }()
//    
//    private let moneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(13), .left)
//        lab.lineBreakMode = .byTruncatingTail
//        lab.text = "100"
//        return lab
//    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi_next")
        return img
    }()
        
        
    private let membBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 7
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        but.backgroundColor = HCOLOR("#FFF6D4")
        return but
    }()
    
    private let simg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_mem")
        return img
    }()
    
    private let memLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(9), .center)
        lab.text = "MEMBER"
        return lab
    }()
    
    
    
    private let bookBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 7
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        but.backgroundColor = HCOLOR("#FFF6D4")
        return but
    }()

    private let simg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("book")
        return img
    }()
    
    private let bookLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(9), .left)
        lab.text = "BOOKING"
        return lab
    }()
    
    

//    private let shareBut: UIButton = {
//        let but = UIButton()
//        but.clipsToBounds = true
//        but.layer.cornerRadius = 7
//        but.layer.borderWidth = 1
//        but.layer.borderColor = MAINCOLOR.cgColor
//        but.backgroundColor = HCOLOR("#FFF6D4")
//        return but
//    }()
    
    
//    private let simg4: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("share")
//        return img
//    }()
//    
//    private let shareLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(9), .left)
//        lab.text = "SHARE"
//        return lab
//    }()
//    
    
    
    
    override func setViews() {
        
        
        contentView.backgroundColor = .white
        
//        
//        contentView.addSubview(yueBut)
//        yueBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(R_W(25))
//            $0.height.equalTo(40)
//            $0.top.equalToSuperview().offset(5)
//            $0.right.equalTo(contentView.snp.centerX).offset(-5)
//            
//        }
//        

        contentView.addSubview(membBut)
        membBut.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(R_W(25))
            $0.right.equalToSuperview().offset(-R_W(25))
        }
        
        
        contentView.addSubview(bookBut)
        bookBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(R_W(25))
//            $0.height.equalTo(40)
//            $0.right.equalTo(contentView.snp.centerX).offset(-5)
            $0.top.equalTo(membBut.snp.bottom).offset(5)
            $0.size.equalTo(membBut)
            $0.centerX.equalTo(membBut)
        }

        
//        contentView.addSubview(shareBut)
//        shareBut.snp.makeConstraints {
//            $0.size.top.equalTo(bookBut)
//            $0.right.equalTo(membBut)
//        }

        
        
//        yueBut.addSubview(simg1)
//        simg1.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 15, height: 15))
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(R_W(25))
//        }
//        
//        
//        yueBut.addSubview(nextImg)
//        nextImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 8, height: 9))
//            $0.right.equalToSuperview().offset(-20)
//            $0.centerY.equalToSuperview()
//        }
//
//        yueBut.addSubview(moneyLab)
//        moneyLab.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalTo(simg1.snp.right).offset(3)
//            $0.right.equalTo(nextImg.snp.left).offset(-3)
//            $0.centerY.equalToSuperview()
//        }
        
        
        
        
        membBut.addSubview(memLab)
        memLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(membBut.snp.centerX).offset(25)
        }

        
        membBut.addSubview(simg2)
        simg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(21), height: R_W(21)))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(memLab.snp.left).offset(-10)
        }
        
       
        
        
        bookBut.addSubview(bookLab)
        bookLab.snp.makeConstraints {
            $0.left.equalTo(memLab)
//            $0.left.equalTo(simg3.snp.right).offset(R_W(10))
//            $0.right.equalToSuperview().offset(-R_W(5))
            $0.centerY.equalToSuperview()
        }

        
        
        
        bookBut.addSubview(simg3)
        simg3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(21), height: R_W(21)))
            $0.centerX.equalTo(simg2)
            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(R_W(35))
        }
        
        
        
//        shareBut.addSubview(simg4)
//        simg4.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: R_W(21), height: R_W(21)))
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(R_W(40))
//        }
//        
//        shareBut.addSubview(shareLab)
//        shareLab.snp.makeConstraints {
//            $0.left.equalTo(simg4.snp.right).offset(R_W(10))
//            $0.right.equalToSuperview().offset(-R_W(5))
//            $0.centerY.equalToSuperview()
//        }
        
        bookBut.addTarget(self, action: #selector(clickBookingAction), for: .touchUpInside)
        membBut.addTarget(self, action: #selector(clickMembershioAction), for: .touchUpInside)
        //yueBut.addTarget(self, action: #selector(clickYueAction), for: .touchUpInside)
        //shareBut.addTarget(self, action: #selector(clickShareAction), for: .touchUpInside)
    }
        
    
    @objc private func clickBookingAction() {

        clickBlock?("book")
    }
    
    @objc private func clickMembershioAction() {
        clickBlock?("code")
    }
    
    @objc private func clickYueAction() {
        clickBlock?("record")
    }
    
    @objc private func clickShareAction() {
        clickBlock?("share")
    }

    
    
    func setCellData(amount: String)  {
        //moneyLab.text = amount
    }
    

}
