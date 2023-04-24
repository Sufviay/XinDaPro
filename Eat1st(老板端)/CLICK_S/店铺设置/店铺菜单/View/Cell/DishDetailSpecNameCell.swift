//
//  DishDetailSpecNameCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailSpecNameCell: BaseTableViewCell {

    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(16), .left)
        lab.text = "Sesame Prawn on Toast"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "芝麻大蝦吐司"
        lab.numberOfLines = 0
        return lab
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-100)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
    }
    
    func setCellData(model: DishDetailSpecModel) {
        
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
    }

}



class DishDetailOptionNameCell: BaseTableViewCell {

    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(14), .left)
        lab.text = "Sesame Prawn on Toast"
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "芝麻大蝦吐司"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-80)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
    }
    
    
    func setCellData(model: DishDetailOptionModel) {
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
    }
}


class DishDetailOptionPriceCell: BaseTableViewCell {

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(14), .left)
        lab.text = "Price"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#6B7DFD"), SFONT(14), .left)
        lab.text = "£ 26.63"
        return lab
    }()

    
    override func setViews() {
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalTo(titlab.snp.bottom).offset(10)
        }
    }

    func setCellData(price: String) {
        self.moneyLab.text = "£ \(price)"
    }
    
}
