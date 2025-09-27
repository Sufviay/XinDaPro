//
//  MenuItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/6.
//

import UIKit

class MenuItemCell: BaseTableViewCell {

    
    private let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = BACKCOLOR_2
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TIT_3, .left)
        lab.text = "Beef Chow Mein"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_2, .left)
        lab.text = "Classified information"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TIT_3, .right)
        lab.text = "100"
        return lab
    }()
    
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.isHidden = true
        return img
    }()
    
    

    override func setViews() {
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(22)
            $0.centerY.equalToSuperview()
            
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.right.equalToSuperview().offset(-100)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
    func setCellData(model: DishModel, idx: Int) {
        
//        let curL = PJCUtil.getCurrentLanguage()
//        
//        if curL == "en_GB" {
//            //英文
//            self.nameLab.text = model.name_En
//            self.desLab.text = model.name_Hk
//        } else {
//            //繁体
//            self.nameLab.text = model.name_Hk
//            self.desLab.text = model.name_En
//        }
        
        nameLab.text = model.name1
        desLab.text = model.name2
        
        
        if model.deliveryNum > 0  && model.deliveryNum != model.salesNum {
            countLab.text = "\(model.salesNum)(\(model.deliveryNum))"
        } else {
            countLab.text = "\(model.salesNum)"
        }
        
        
        self.picImg.sd_setImage(with: URL(string: model.dishImg))
        
        if idx == 0 {
            self.nameLab.textColor = HCOLOR("#FCB138")
            self.countLab.textColor = HCOLOR("#FCB138")
            self.nextImg.image = LOIMG("next_yellow")
 
        }
        else if idx == 1 {
            self.nameLab.textColor = HCOLOR("#02C392")
            self.countLab.textColor = HCOLOR("#02C392")
            self.nextImg.image = LOIMG("next_green")
        }
        else if idx == 2 {
            self.nameLab.textColor = MAINCOLOR
            self.countLab.textColor = MAINCOLOR
            self.nextImg.image = LOIMG("next_blue")
        }
        else {
            self.nameLab.textColor = TXTCOLOR_2
            self.countLab.textColor = TXTCOLOR_2
            self.nextImg.image = LOIMG("next_black")
        }
    }
}
