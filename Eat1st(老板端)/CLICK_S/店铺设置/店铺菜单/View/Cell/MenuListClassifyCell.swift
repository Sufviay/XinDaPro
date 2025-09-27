//
//  MenuListClassifyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit

class MenuListClassifyCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("set_next")
        return img
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        return lab
    }()


    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#6B7DFD"), TIT_6, .left)
        lab.text = "23 items"
        return lab
    }()
    

    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(5)
        }
        
        
        
    }
    
    
    func setCellData(model: F_DishModel) {
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
        self.countLab.text = "\(model.dishNum) items"
    }
    
}
