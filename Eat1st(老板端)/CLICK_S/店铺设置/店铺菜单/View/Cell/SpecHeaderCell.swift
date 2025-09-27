//
//  SpecHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class SpecHeaderCell: BaseTableViewCell {


    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_4, .left)
        lab.text = "#1 Specifiation"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
    }

}


class SpecHeaderEditeCell: BaseTableViewCell {
    
    
    var clickBlock: VoidBlock?
    
    private let editeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_edite"), for: .normal)
        return but
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "#1 Specification"
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }

        contentView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-15)
        }
        
        editeBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
    
    }
    
    @objc private func clickAciton() {
        self.clickBlock?("")
    }
    
    func setCellData(numStr: Int) {
        self.titlab.text = "#\(numStr) \("Specification".local)"
    }
    
}


class OptionHeaderCell: BaseTableViewCell {
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Options".local + ":"
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
    }

}

class OptionHeaderEditeCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?
    
    private let editeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_edite"), for: .normal)
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1,TIT_2, .left)
        lab.text = "#1 Option"
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        contentView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-40)
        }
        
        editeBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
    
    }
    
    @objc private func clickAciton() {
        self.clickBlock?("")
    }
    
    func setCellData(number: Int) {
        self.titlab.text = "#\(number) \("Option".local)"
    }
    
}
