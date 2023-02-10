//
//  CurentDayMoneyView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/4/2.
//

import UIKit

class CurentDayMoneyView: UIView {

    
    private let cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Cash"
        return lab
    }()

    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Delivery fee"
        return lab
    }()
    
    private let cMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(22), .center)
        lab.text = "0"
        return lab
    }()
    
    
    private let dMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(22), .center)
        lab.text = "0"
        return lab
    }()
    
    
    private let slab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(15), .right)
        lab.text = "£"
        return lab
    }()
    
    private let slab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(15), .right)
        lab.text = "£"
        return lab
    }()


    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(cashLab)
        cashLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
//            $0.left.equalToSuperview()
//            $0.right.equalTo(self.snp.centerX)
            $0.bottom.equalToSuperview().offset(-23)
        }
        
//        self.addSubview(deLab)
//        deLab.snp.makeConstraints {
//            $0.right.equalToSuperview()
//            $0.left.equalTo(self.snp.centerX)
//            $0.bottom.equalToSuperview().offset(-23)
//        }
//
        self.addSubview(cMoneyLab)
        cMoneyLab.snp.makeConstraints {
            $0.centerX.equalTo(cashLab)
            $0.top.equalToSuperview().offset(23)
        }
        
//        self.addSubview(dMoneyLab)
//        dMoneyLab.snp.makeConstraints {
//            $0.centerX.equalTo(deLab)
//            $0.top.equalToSuperview().offset(23)
//        }
        
        self.addSubview(slab1)
        slab1.snp.makeConstraints {
            $0.right.equalTo(cMoneyLab.snp.left).offset(-3)
            $0.bottom.equalTo(cMoneyLab.snp.bottom).offset(-4)
        }
        
//        self.addSubview(slab2)
//        slab2.snp.makeConstraints {
//            $0.right.equalTo(dMoneyLab.snp.left).offset(-3)
//            $0.bottom.equalTo(dMoneyLab.snp.bottom).offset(-4)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(cashMoney: String, deFeeMoney: String) {
        self.cMoneyLab.text = cashMoney
        self.dMoneyLab.text = deFeeMoney
    }
    
    
    
}
