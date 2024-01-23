//
//  CartDishInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/19.
//

import UIKit

class CartDishInfoCell: BaseTableViewCell {

    
    var clickDeleteBlock: VoidBlock?
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delete", HCOLOR("#000000"), BFONT(9), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(11), .right)
        lab.text = "£3.95"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(10), .right)
        lab.text = "x1"
        return lab
    }()
    

    private let dishIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(8), .center)
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
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "Spring Rolls - Chicken Spring Rolls"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "雞肉春卷"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-90)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalTo(moneyLab)
            $0.top.equalTo(moneyLab.snp.bottom).offset(2)
        }
        
        contentView.addSubview(dishIDLab)
        dishIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(13)
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
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-150)
            $0.top.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDeleteAction() {
        clickDeleteBlock?("")
    }
    
    
    func setCellData(model: CartDishModel) {
        dishIDLab.text = model.dishesCode
        nameLab1.text = model.nameEn
        nameLab2.text = model.nameHk
        
        moneyLab.text = "£\(D_2_STR(model.price))"
        countLab.text = "x\(model.buyNum)"
        
        giveOneImg.isHidden = !model.isGiveOne
    }
    

}
