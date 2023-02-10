//
//  OrderpayMoneyCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/10.
//

import UIKit

class OrderpayMoneyCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Payment method"
        return lab
    }()

    private var cardNumberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "6543 8752 7612 9999"
        return lab
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        return but
    }()
    
    private let selectLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .right)
        lab.text = "Select"
        return lab
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(cardNumberLab)
        cardNumberLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.left.equalToSuperview().offset(10)
        }
        
        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalTo(cardNumberLab)
        }
        
        backView.addSubview(selectLab)
        selectLab.snp.makeConstraints {
            $0.centerY.equalTo(cardNumberLab)
            $0.right.equalTo(nextBut.snp.left)
        }
        
        
    }
    
    
}
