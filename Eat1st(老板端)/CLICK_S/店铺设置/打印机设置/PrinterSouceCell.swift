//
//  PrinterSouceCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/4/10.
//

import UIKit

class PrinterSouceCell: BaseTableViewCell {


    var clickBlock: VoidStringBlock?
    

    private var selectIdxArr: [String] = [] {
        didSet {
            if selectIdxArr.contains("1") {
                img1.image = LOIMG("dish_sel_b")
            } else {
                img1.image = LOIMG("dish_unsel_b")
            }
            if selectIdxArr.contains("2") {
                img2.image = LOIMG("dish_sel_b")
            } else {
                img2.image = LOIMG("dish_unsel_b")
            }
            if selectIdxArr.contains("3") {
                img3.image = LOIMG("dish_sel_b")
            } else {
                img3.image = LOIMG("dish_unsel_b")
            }
        }

    }
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Print souce".local
        return lab
    }()


    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        lab.isHidden = true
        return lab
    }()

    
    private let oneBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let twoBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let threeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()

    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel_b")
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel_b")
        return img
    }()
    
    private let img3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel_b")
        return img
    }()


    
    private let oneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Deliveroo"
        return lab
    }()
    
    private let twoLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "UberEats"
        return lab
    }()
    
    private let threeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "JustEat"
        return lab
    }()

    
    
    
    override func setViews() {

        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right)
        }
        
        contentView.addSubview(oneBut)
        oneBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(titlab.snp.bottom).offset(5)
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(35)
        }
        
        contentView.addSubview(twoBut)
        twoBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.height.width.top.equalTo(oneBut)
        }
        
        contentView.addSubview(threeBut)
        threeBut.snp.makeConstraints {
            $0.left.size.equalTo(oneBut)
            $0.top.equalTo(oneBut.snp.bottom)
        }
        
        
        oneBut.addSubview(img1)
        img1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        oneBut.addSubview(oneLab)
        oneLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        
        twoBut.addSubview(img2)
        img2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        twoBut.addSubview(twoLab)
        twoLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        threeBut.addSubview(img3)
        img3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        threeBut.addSubview(threeLab)
        threeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }


        
        oneBut.addTarget(self, action: #selector(clickOneAction), for: .touchUpInside)
        twoBut.addTarget(self, action: #selector(clickTwoAction), for: .touchUpInside)
        threeBut.addTarget(self, action: #selector(clickThreeAction), for: .touchUpInside)
        
    }

    
    
    @objc private func clickOneAction() {
        
        if selectIdxArr.contains("1") {
            selectIdxArr = selectIdxArr.filter { $0 != "1" }
        } else {
            selectIdxArr.append("1")
        }
        clickBlock?(dealIdxArr())
    }
    
    
    @objc private func clickTwoAction() {
        if selectIdxArr.contains("2") {
            selectIdxArr = selectIdxArr.filter { $0 != "2" }
        } else {
            selectIdxArr.append("2")
        }
        clickBlock?(dealIdxArr())
    }

    @objc private func clickThreeAction() {
        if selectIdxArr.contains("3") {
            selectIdxArr = selectIdxArr.filter { $0 != "3" }
        } else {
            selectIdxArr.append("3")
        }
        clickBlock?(dealIdxArr())
    }

    private func dealIdxArr() -> String {
        if selectIdxArr.count == 0 {
            return ""
        } else {
            var tStr = ""
            for (idx, str) in selectIdxArr.enumerated() {
                if idx == 0 {
                    tStr = str
                } else {
                    tStr = tStr + "," + str
                }
            }
            return tStr
        }
    }
    
    
    func setCellData(printSouce: String) {
        
        if printSouce != "" {
            selectIdxArr = printSouce.components(separatedBy: ",")
        } else {
            selectIdxArr = []
        }

    }
    
    
    
}
