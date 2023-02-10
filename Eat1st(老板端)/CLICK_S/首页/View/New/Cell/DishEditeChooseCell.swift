//
//  DishEditeChooseCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishEditeChooseCell: BaseTableViewCell {

    var selectBlock: VoidStringBlock?
    
    private var statusID: String = ""
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    private let but1: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let but2: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let selectImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel")
        return img
    }()

    
    private let selectImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel")
        return img
    }()

    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), SFONT(14), .left)
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), SFONT(14), .left)
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(but1)
        but1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview()
            $0.right.equalTo(contentView.snp.centerX)
        }

        contentView.addSubview(but2)
        but2.snp.makeConstraints {
            $0.left.equalTo(but1.snp.right)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        but1.addSubview(selectImg1)
        selectImg1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        but1.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(selectImg1.snp.right).offset(10)
        }
        
        
        but2.addSubview(selectImg2)
        selectImg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
        }
        
        but2.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(selectImg2.snp.right).offset(10)
        }
        
        but1.addTarget(self, action: #selector(clickbut1Action), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickbut2Action), for: .touchUpInside)
    }
    
    
    @objc private func clickbut1Action() {
        if statusID != "1" {
            statusID = "1"
            selectBlock?("1")
        }
    }
    
    @objc private func clickbut2Action() {
        if statusID != "2" {
            statusID = "2"
            selectBlock?("2")
        }

    }

    
    func setCellData(titStr: String, l_str: String, r_Str: String, statusID: String) {
        self.titlab.text = titStr
        self.tlab1.text = l_str
        self.tlab2.text = r_Str
        self.statusID = statusID
        
        if statusID == "1" {
            self.selectImg1.image = LOIMG("dish_sel")
            self.selectImg2.image = LOIMG("dish_unsel")
        } else if statusID == "2" {
            self.selectImg2.image = LOIMG("dish_sel")
            self.selectImg1.image = LOIMG("dish_unsel")

        } else {
            self.selectImg2.image = LOIMG("dish_unsel")
            self.selectImg1.image = LOIMG("dish_unsel")
        }        
    }

}
