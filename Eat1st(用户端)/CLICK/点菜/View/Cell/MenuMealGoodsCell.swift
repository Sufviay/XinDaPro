//
//  MenuMealGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/15.
//

import UIKit

class MenuMealGoodsCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = MAINCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(13), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
        lab.text = "4.8"
        return lab
    }()
    
    private let optionBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Option", FONTCOLOR, BFONT(13), MAINCOLOR)
        but.layer.cornerRadius = 7
        return but
    }()
    
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "£4.8"
        return lab
    }()
    
    private let disLine: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#666666")
        return view
    }()
    
    private let disBackImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("disback")
        return img
    }()
    
    private let discountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(9), .center)
        lab.text = "25%OFF"
        return lab
    }()

    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(SET_H(110, 335))
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-140)
        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-140)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-1)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
            
        }
        
        
        backView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.bottom.equalTo(s_lab)
            $0.right.equalTo(s_lab.snp.left).offset(-2)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.centerY.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }

        
//        contentView.addSubview(disBackImg)
//        disBackImg.snp.makeConstraints {
//            $0.bottom.equalTo(disMoneyLab).offset(-2)
//            $0.left.equalTo(disMoneyLab.snp.right).offset(2)
//            $0.size.equalTo(CGSize(width: 47, height: 15))
//        }
//
//        disBackImg.addSubview(discountLab)
//        discountLab.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        

        
        
        backView.addSubview(optionBut)
        optionBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 56, height: 20))
            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        
        
        
    }
    
    
    
}
