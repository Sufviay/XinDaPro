//
//  SelectFourButCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/14.
//

import UIKit

class SelectFourButCell: BaseTableViewCell {


    
    var clickBlock: VoidStringBlock?

    private var selectIdx: String = "" {
        didSet {
            if selectIdx == "1" {
                img1.image = LOIMG("dish_sel")
                img2.image = LOIMG("dish_unsel")
                img3.image = LOIMG("dish_unsel")
                img4.image = LOIMG("dish_unsel")
            }
            else if selectIdx == "2" {
                img1.image = LOIMG("dish_unsel")
                img2.image = LOIMG("dish_sel")
                img3.image = LOIMG("dish_unsel")
                img4.image = LOIMG("dish_unsel")
            }
            else if selectIdx == "3" {
                img1.image = LOIMG("dish_unsel")
                img2.image = LOIMG("dish_unsel")
                img3.image = LOIMG("dish_sel")
                img4.image = LOIMG("dish_unsel")
            }
            else if selectIdx == "4" {
                img1.image = LOIMG("dish_unsel")
                img2.image = LOIMG("dish_unsel")
                img3.image = LOIMG("dish_unsel")
                img4.image = LOIMG("dish_sel")
            } else {
                img1.image = LOIMG("dish_unsel")
                img2.image = LOIMG("dish_unsel")
                img3.image = LOIMG("dish_unsel")
                img4.image = LOIMG("dish_unsel")
            }
            
        }

    }
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Print copies"
        return lab
    }()


    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
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
    
    private let fourBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()


    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()
    
    private let img3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()
    
    private let img4: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()



    
    private let oneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Print one copy"
        return lab
    }()
    
    private let twoLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Print two copies"
        return lab
    }()
    
    private let threeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Label printer"
        return lab
    }()

    private let fourLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Label printer"
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
        
        contentView.addSubview(fourBut)
        fourBut.snp.makeConstraints {
            $0.left.size.equalTo(twoBut)
            $0.centerY.equalTo(threeBut)
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

        fourBut.addSubview(img4)
        img4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        fourBut.addSubview(fourLab)
        fourLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        
        oneBut.addTarget(self, action: #selector(clickOneAction), for: .touchUpInside)
        twoBut.addTarget(self, action: #selector(clickTwoAction), for: .touchUpInside)
        threeBut.addTarget(self, action: #selector(clickThreeAction), for: .touchUpInside)
        fourBut.addTarget(self, action: #selector(clickFourAction), for: .touchUpInside)
        
    }
    
    
    func setCellData(titStr: String, str1: String, str2: String, str3: String, str4: String, selectType: String) {
        titlab.text = titStr
        oneLab.text = str1
        twoLab.text = str2
        threeLab.text = str3
        fourLab.text = str4

        selectIdx = selectType
    }
    
    
//    func setStyle(titStr: String, str1: String, str2: String, str3: String, str4: String) {
//        titlab.text = titStr
//        oneLab.text = str1
//        twoLab.text = str2
//        threeLab.text = str3
//        fourLab.text = str4
//    }
    
    
    @objc private func clickOneAction() {
        if selectIdx != "1" {
            selectIdx = "1"
        } else {
            selectIdx = ""
        }
        clickBlock?(selectIdx)
    }
    
    
    @objc private func clickTwoAction() {
        if selectIdx != "2" {
            selectIdx = "2"
        } else {
            selectIdx = ""
        }
        clickBlock?(selectIdx)
    }

    @objc private func clickThreeAction() {
        if selectIdx != "3" {
            selectIdx = "3"
        } else {
            selectIdx = ""
        }
        clickBlock?(selectIdx)
    }

    @objc private func clickFourAction() {
        if selectIdx != "4" {
            selectIdx = "4"
        } else {
            selectIdx = ""
        }
        clickBlock?(selectIdx)
    }

    

    

}
