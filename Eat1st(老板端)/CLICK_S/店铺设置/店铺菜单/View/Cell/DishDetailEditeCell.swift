//
//  DishDetailEditeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/22.
//

import UIKit

class DishDetailEditeCell: BaseTableViewCell {
    
    var editeBlock: VoidBlock?

    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(17), .left)
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
    
    let editeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_edite"), for: .normal)
        return but
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-100)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
     
        editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
    }
    
    func setCellData(name1: String, name2: String) {
        self.nameLab1.text = name1
        self.nameLab2.text = name2
    }
    
    @objc private func clickEditeAction() {
        editeBlock?("")
    }
    
}
