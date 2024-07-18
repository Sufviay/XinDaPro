//
//  DineInNavBarView.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/17.
//

import UIKit

class DineInNavBarView: UIView {

    var backBlock: VoidBlock?
        
    var payBlock: VoidBlock?
    
    var amountBlock: VoidBlock?
    
    let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = ""
        return lab
    }()
    

    
    private let payBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.setImage(LOIMG("pay 1"), for: .normal)
        //but.isHidden = true
        return but
    }()
    
    
//    private let payImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("pay 1")
//        return img
//    }()
    
//    private let payLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(8), .center)
//        lab.text = "PAY"
//        return lab
//    }()
    
    private let amountBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FAFAFA")
        but.clipsToBounds = true
        but.layer.cornerRadius = 15
        but.isHidden = true
        return but
    }()
    
    
    private let amountImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        return img
    }()
    
    private let amountNext: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_next")
        return img
    }()
    
    private let amountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(15), .right)
        lab.text = "1000"
        return lab
    }()
    

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.left.equalToSuperview().offset(45)
        }
        
        
        self.addSubview(payBut)
        payBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalTo(backBut)
        }
        
//        payBut.addSubview(payImg)
//        payImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 21, height: 21))
//            $0.center.equalToSuperview()
//        }
        
//        payBut.addSubview(payLab)
//        payLab.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(payImg.snp.bottom).offset(2)
//        }
//        
        
        self.addSubview(amountBut)
        amountBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 30))
            $0.centerY.equalTo(backBut)
            $0.right.equalTo(payBut.snp.left).offset(0)
        }
        
        amountBut.addSubview(amountImg)
        amountImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        
        amountBut.addSubview(amountNext)
        amountNext.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 10))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
        
        
        amountBut.addSubview(amountLab)
        amountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        amountBut.addTarget(self, action: #selector(clickAmountAction), for: .touchUpInside)
        payBut.addTarget(self, action: #selector(clickPayAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickBackAction() {
        self.backBlock?("")
    }
    
    
    @objc private func clickPayAction() {
        payBlock?("")
    }
    
    
    @objc private func clickAmountAction() {
        amountBlock?("")
    }
    
    func setData(isHavePay: Bool) {
        
        if isHavePay {
            payBut.isHidden = false
        } else {
            payBut.isHidden = true
        }
        
        
//        if  !isVip {
//            payBut.isHidden = true
//            //amountBut.isHidden = true
//        } else {
//            payBut.isHidden = false
////            amountBut.isHidden = false
////            amountLab.text = amount
//            
////            let w = amount.getTextWidth(BFONT(15), 15)
////            amountBut.snp.remakeConstraints {
////                $0.centerY.equalTo(backBut)
////                $0.right.equalTo(payBut.snp.left).offset(0)
////                $0.height.equalTo(30)
////                $0.width.equalTo(w + 50)
////            }
//        }
    }

}
