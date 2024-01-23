//
//  DishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit

class DishCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
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
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(15), .right)
        lab.text = "£123.95"
        return lab
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "Spring Rolls - Chicken"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "雞肉春卷"
        return lab
    }()
    
    
    
    override func setViews() {
       
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
        backView.addSubview(dishIDLab)
        dishIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 55, height: 16))
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(giveOneImg)
        giveOneImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 87, height: 15))
            $0.left.equalToSuperview().offset(83)
            $0.centerY.equalTo(dishIDLab)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
        }

        backView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-100)
        }
        
        backView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(3)
        }

        
    }
    
    
    func setCellData(model: DishModel) {
        dishIDLab.text = model.dishesCode
        if model.giveOne == "2" {
            giveOneImg.isHidden = false
        } else {
            giveOneImg.isHidden = true
        }
        
        nameLab1.text = model.dishesNameEn
        nameLab2.text = model.dishesNameHk
        
        moneyLab.text = "£\(D_2_STR(model.price))"
        
    }
    
}
