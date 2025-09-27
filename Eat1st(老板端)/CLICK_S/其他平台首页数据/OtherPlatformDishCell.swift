//
//  OtherPlatformDishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/25.
//

import UIKit


class OtherPlatformDishCell: BaseTableViewCell {
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TIT_3, .left)
        lab.text = "Beef Chow Mein"
        lab.numberOfLines = 0
        return lab
    }()
    

    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TIT_3, .right)
        lab.text = "100"
        return lab
    }()
    

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-100)
        }
        

        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }

//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.height.equalTo(0.5)
//            $0.bottom.equalToSuperview()
//        }
        
    }
    
    func setCellData(model: OtherPlatformDishModel, idx: Int) {
        
        
        nameLab.text = model.name
        countLab.text = "\(model.salesNum)"
        
        
        if idx == 0 {
            self.nameLab.textColor = HCOLOR("#FCB138")
            self.countLab.textColor = HCOLOR("#FCB138")
 
        }
        else if idx == 1 {
            self.nameLab.textColor = HCOLOR("#02C392")
            self.countLab.textColor = HCOLOR("#02C392")
        }
        else if idx == 2 {
            self.nameLab.textColor = MAINCOLOR
            self.countLab.textColor = MAINCOLOR
        }
        else {
            self.nameLab.textColor = TXTCOLOR_2
            self.countLab.textColor = TXTCOLOR_2
        }
    }

    
    
    
    
    
}

