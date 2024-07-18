//
//  OrderDishInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderDishInfoCell: BaseTableViewCell {

    
    var clickDeleteBlock: VoidBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 50, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()
    
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "Spring Rolls - Chicken Spring Rolls"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "雞肉春卷"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(14), .right)
        lab.text = "£3.95"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(13), .right)
        lab.text = "x1"
        return lab
    }()
    
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("clear"), for: .normal)
        return but
    }()
    

    override func setViews() {
        
//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(15)
//            $0.right.equalToSuperview().offset(-15)
//            $0.height.equalTo(0.5)
//            $0.bottom.equalToSuperview()
//        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-130)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-80)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-80)
            $0.centerY.equalTo(nameLab2)
        }
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 60))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickDeleteAction() {
        clickDeleteBlock?("")
    }
    
    
    
    
    func setCellData(model: OrderDishModel) {
        nameLab1.text = model.nameHk
        nameLab2.text = model.nameEn
        moneyLab.text = "£\(D_2_STR(model.price))"
        countLab.text = "x\(model.buyNum)"
        
        if model.baleSort == "0" {
            deleteBut.isHidden = false
        } else {
            deleteBut.isHidden = true
        }
        
    }
    
    
}
