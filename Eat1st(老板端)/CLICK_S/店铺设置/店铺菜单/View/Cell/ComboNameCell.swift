//
//  ComboNameCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/26.
//

import UIKit

class ComboNameCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    private let editeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_edite"), for: .normal)
        return but
    }()
    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let numLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "#1"
        return lab
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(numLab)
        numLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-65)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.top.equalTo(namelab1.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-65)

        }
        
        editeBut.addTarget(self, action: #selector(clickEditAction), for: .touchUpInside)
    }
    
    
    @objc private func clickEditAction() {
        clickBlock?("")
    }
    
    func setCellData(num: Int, name1: String, name2: String) {
        self.numLab.text = "#\(num)"
        self.namelab1.text = name1
        self.namelab2.text = name2
    }
    
}


class ComboDishNameCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
        
    
    override func setViews() {
        

        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.top.equalTo(namelab1.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-40)

        }
    }
    
    
    
    func setCellData(name1: String, name2: String) {
        self.namelab1.text = name1
        self.namelab2.text = name2
    }
    
}

