//
//  DishDetailNameCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/16.
//

import UIKit

class DishDetailNameCell: BaseTableViewCell {


    private let dishIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(9), .center)
        lab.backgroundColor = HCOLOR("#EE7763")
        lab.clipsToBounds = true
        lab.text = "AW2354"
        lab.layer.cornerRadius = 3
        return lab
    }()
    
    
    private let giveOneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("giveone")
        return img
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(12), .left)
        lab.numberOfLines = 0
        lab.text = "Spring Rolls - Chicken"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "雞肉春卷"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(dishIDLab)
        dishIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
            $0.size.equalTo(CGSize(width: 50, height: 15))
        }
        
        contentView.addSubview(giveOneImg)
        giveOneImg.snp.makeConstraints {
            $0.left.equalTo(dishIDLab.snp.right).offset(5)
            $0.centerY.equalTo(dishIDLab)
            $0.size.equalTo(CGSize(width: 87, height: 15))
        }

        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
    }
    
    
    func setCellData(model: DishModel) {
        nameLab1.text = model.dishesNameEn
        nameLab2.text = model.dishesNameHk
        dishIDLab.text = model.dishesCode
        
        if model.giveOne == "2" {
            giveOneImg.isHidden = false
        } else {
            giveOneImg.isHidden = true
        }
    }
    
    

}
