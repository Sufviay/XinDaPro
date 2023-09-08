//
//  DishesShowCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/30.
//

import UIKit

class DishesShowCell: BaseTableViewCell {

    private let picImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = HOLDCOLOR
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(11), .left)
        lab.text = "Spicy burger Spicy burger Spicy burger Spicy burger Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(13), .right)
        lab.text = "4.8"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .right)
        lab.text = "x2"
        return lab
    }()
    
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 0
        return lab
    }()


    
    override func setViews() {
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.equalToSuperview().offset(20)
        }
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(moneyLab.snp.bottom).offset(7)
        }

        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
    
    }
    
    
    
    func setCellData(model: OrderDishModel, isShow: Bool) {
        picImg.sd_setImage(with: URL(string: model.imageUrl))
        nameLab.text = model.nameStr
        moneyLab.text = model.dishesPrice
        desLab.text = model.desStr
        if isShow {
            countLab.text = "x\(model.selectCount)"
        } else {
            countLab.text = "x\(model.buyNum)"
        }
        
    }

}
