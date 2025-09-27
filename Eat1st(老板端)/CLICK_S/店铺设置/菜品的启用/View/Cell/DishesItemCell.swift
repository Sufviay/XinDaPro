//
//  DishesItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/10.
//

import UIKit

class DishesItemCell: BaseTableViewCell {

    var selectBlock: VoidBlock?
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("unsel_f"), for: .normal)
        return but
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        lab.text = "BBQ Spare Ribs in Mandarin Sauce\n中式烤排骨"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.setCommentStyle(TXTCOLOR_2, TXT_2, .left)
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        lab.text = "£6.50"
        return lab
    }()
    
    let isShowImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_hide")
        img.isHidden = true
        return img
    }()
    
    override func setViews() {
        
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-110)
            $0.bottom.equalTo(contentView.snp.centerY).offset(0)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(contentView.snp.centerY).offset(0)
        }
        
        contentView.addSubview(isShowImg)
        isShowImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.right).offset(-100)
            $0.centerY.equalToSuperview()
        }
        
        selectBut.addTarget(self, action: #selector(clickSelectAction), for: .touchUpInside)
        
    }
    
    @objc private func clickSelectAction() {
        selectBlock?("")
    }
    
    
    func setCellData(model: DishModel) {
        
        
        if model.sellType == "3" || model.sellType == "1" {
            self.moneyLab.text = "£\(model.deliPrice)"
        } else {
            self.moneyLab.text = "£\(model.dinePrice)"
        }
            
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
        
        if model.isSelect {
            self.selectBut.setImage(LOIMG("sel_f"), for: .normal)
        } else {
            self.selectBut.setImage(LOIMG("unsel_f"), for: .normal)
        }
        
//        if model.haveSpec {
//            
//            self.isShowImg.isHidden = false
//            if model.optionArr.count == 0 {
//                self.isShowImg.image = LOIMG("sj_hide")
//            } else {
//                self.isShowImg.image = LOIMG("sj_show")
//            }
//        } else {
//            self.isShowImg.isHidden = true
//        }

    }
    
    

}
