//
//  OrderGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderGoodsCell: BaseTableViewCell {

    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Dish Name 1"
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "10.9"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(14), .right)
        lab.text = "x2"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(14), .left)
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "options,options,options,options"
        return lab
    }()
    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.top.equalTo(goodsImg).offset(5)
            $0.right.equalToSuperview().offset(-70)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(3)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(-80)
        }
        
    }
    
    
    func setCellData(model: OrderDishModel) {
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), completed: nil)
        self.nameLab.text = "\(model.name_E)(\(model.name_C))"
        self.moneyLab.text = String(model.subFee)
        self.desLab.text = model.des_E == "" ? "" : "\(model.des_E)(\(model.des_C))"
        self.countLab.text = "x\(model.count)"
    }
    
}
