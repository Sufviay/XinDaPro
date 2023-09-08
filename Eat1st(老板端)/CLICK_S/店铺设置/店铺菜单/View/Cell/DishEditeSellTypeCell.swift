//
//  DishEditeSellTypeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/27.
//

import UIKit

class DishEditeSellTypeCell: BaseTableViewCell {
    
    ///（1外卖，2堂食，3均可）
    private var statusID: String = ""

    var selectBlock: VoidStringBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Method of sale"
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
    
    private let but3: UIButton = {
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
    
    private let selectImg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel")
        return img
    }()


    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Dine-in"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "All"
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
            $0.width.equalTo((S_W - 40) / 3)
        }

        contentView.addSubview(but2)
        but2.snp.makeConstraints {
            $0.left.equalTo(but1.snp.right)
            $0.height.bottom.width.equalTo(but1)
        }
        
        contentView.addSubview(but3)
        but3.snp.makeConstraints {
            $0.left.equalTo(but2.snp.right)
            $0.height.bottom.width.equalTo(but1)
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
        
        
        but3.addSubview(selectImg3)
        selectImg3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
        }
        
        but3.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(selectImg3.snp.right).offset(10)
        }

        
        but1.addTarget(self, action: #selector(clickbut1Action), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickbut2Action), for: .touchUpInside)
        but3.addTarget(self, action: #selector(clickbut3Action), for: .touchUpInside)
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
    
    
    @objc private func clickbut3Action() {
        if statusID != "3" {
            statusID = "3"
            selectBlock?("3")
        }

    }
    
    
    func setCellData(statusID: String) {
        self.statusID = statusID
        
        if statusID == "1" {
            self.selectImg1.image = LOIMG("dish_sel")
            self.selectImg2.image = LOIMG("dish_unsel")
            self.selectImg3.image = LOIMG("dish_unsel")
            
        } else if statusID == "2" {
            self.selectImg2.image = LOIMG("dish_sel")
            self.selectImg1.image = LOIMG("dish_unsel")
            self.selectImg3.image = LOIMG("dish_unsel")

        } else if statusID == "3" {
            self.selectImg3.image = LOIMG("dish_sel")
            self.selectImg1.image = LOIMG("dish_unsel")
            self.selectImg2.image = LOIMG("dish_unsel")

        } else {
            self.selectImg2.image = LOIMG("dish_unsel")
            self.selectImg1.image = LOIMG("dish_unsel")
            self.selectImg3.image = LOIMG("dish_unsel")
        }
    }

    
    


}
