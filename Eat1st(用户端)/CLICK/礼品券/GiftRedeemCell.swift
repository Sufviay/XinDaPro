//
//  GiftRedeemCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/5.
//

import UIKit

class GiftRedeemCell: BaseTableViewCell {

    var redeemBlock: VoidBlock?
    
    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card 1")
        return img
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Gift voucher"
        return lab
    }()
    
    private let tImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "555"
        return lab
    }()
    
    private let redeemBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Exchange", .white, BFONT(10), MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 12
        return but
    }()

    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(6), .left)
        lab.text = "Gift voucher"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let s_numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(11), .left)
        lab.text = "555"
        return lab
    }()


    
    
    override func setViews() {
        
        contentView.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 95, height: 55))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalTo(cardImg.snp.right).offset(15)
            $0.top.equalTo(cardImg).offset(8)
        }
        
        contentView.addSubview(tImg)
        tImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.left.equalTo(tLab)
            $0.top.equalTo(tLab.snp.bottom).offset(4)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalTo(tImg.snp.right).offset(2)
            $0.centerY.equalTo(tImg)
        }
        
        contentView.addSubview(redeemBut)
        redeemBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 24))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        cardImg.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.left.equalToSuperview().offset(7)
            $0.top.equalToSuperview().offset(12)
        }
        
        cardImg.addSubview(s_numberLab)
        s_numberLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(2)
        }
        
        cardImg.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalTo(sImg.snp.bottom).offset(2)
        }
        
        redeemBut.addTarget(self, action: #selector(clickRedeemAction), for: .touchUpInside)
    }
    
    
    @objc private func clickRedeemAction() {
        redeemBlock?("")
    }
    
    func setCellData(model: GiftVoucherModel) {
        numberLab.text = D_2_STR(model.amount)
        s_numberLab.text = D_2_STR(model.amount)
    }

}
