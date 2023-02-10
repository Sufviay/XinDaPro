//
//  DishesSpecItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit

class DishesSpecItemCell: BaseTableViewCell {


    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()

    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("##080808"), SFONT(13), .left)
        lab.text = "BBQ Spare Ribs in Mandarin Sauce\n中式烤排骨"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.setCommentStyle(HCOLOR("##080808"), SFONT(11), .left)
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("080808"), SFONT(14), .left)
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(58)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-110)
            $0.bottom.equalTo(contentView.snp.centerY).offset(0)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(contentView.snp.centerY).offset(0)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.right).offset(-100)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
    func setCellData(model: DishOptionItemModel) {
        if model.statusId == "1" {
            self.selectImg.image = LOIMG("spec_sel")
            self.nameLab1.textColor = FONTCOLOR
            self.nameLab2.textColor = HCOLOR("666666")
        } else {
            self.selectImg.image = LOIMG("spec_unsel")
            self.nameLab1.textColor = HCOLOR("080808")
            self.nameLab2.textColor = HCOLOR("080808")
        }
        
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
        self.moneyLab.text = "£\(model.price)"
        

    }
    

}
