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
    
    private let l_but: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let r_but: UIButton = {
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
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
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
        
        contentView.addSubview(l_but)
        l_but.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview()
            $0.right.equalTo(contentView.snp.centerX)
        }

        contentView.addSubview(r_but)
        r_but.snp.makeConstraints {
            $0.left.equalTo(l_but.snp.right)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        l_but.addSubview(selectImg1)
        selectImg1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        l_but.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(selectImg1.snp.right).offset(10)
        }
        
        
        r_but.addSubview(selectImg2)
        selectImg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
        }
        
        r_but.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(selectImg2.snp.right).offset(10)
        }
        
        l_but.addTarget(self, action: #selector(clickL_ButAction), for: .touchUpInside)
        r_but.addTarget(self, action: #selector(clickR_ButAction), for: .touchUpInside)
    }
    
    
    @objc private func clickL_ButAction() {
        
        if titlab.text == "Status" || titlab.text == "Delivery" || titlab.text == "Collection" {
            if statusID != "1" {
                statusID = "1"
                selectBlock?("1")
            }
        } else {
            if statusID != "2" {
                statusID = "2"
                selectBlock?("2")
            }

        }
        

    }
    
    @objc private func clickR_ButAction() {
        
        if titlab.text == "Status" || titlab.text == "Delivery" || titlab.text == "Collection" {
            if statusID != "2" {
                statusID = "2"
                selectBlock?("2")
            }
        } else {
            if statusID != "1" {
                statusID = "1"
                selectBlock?("1")
            }

        }

    }

    
    func setChooseCellData(titStr: String, l_str: String, r_Str: String, statusID: String) {
        
        //确定选择按钮是 左真。右假
        
        ///当titStr ==  Status  Delivery.  Collection 时 是1是2否。   其他的都是1否2是
        
        
        self.titlab.text = titStr
        self.tlab1.text = l_str
        self.tlab2.text = r_Str
        self.statusID = statusID
        
        
        if titStr == "Status" || titStr == "Delivery" || titStr == "Collection" {
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

        } else {
            
            if statusID == "2" {
                self.selectImg1.image = LOIMG("dish_sel")
                self.selectImg2.image = LOIMG("dish_unsel")
                
            } else if statusID == "1" {
                self.selectImg2.image = LOIMG("dish_sel")
                self.selectImg1.image = LOIMG("dish_unsel")

            } else {
                self.selectImg2.image = LOIMG("dish_unsel")
                self.selectImg1.image = LOIMG("dish_unsel")
            }

        }
        
    }

}





class DishEditeChooseCell_Three: BaseTableViewCell {
    
    
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
    
    
    func setCellData(titStr: String, l_str: String, m_str: String, r_str: String, statusID: String) {
        self.statusID = statusID
        self.titlab.text = titStr
        self.tlab1.text = l_str
        self.tlab2.text = m_str
        self.tlab3.text = r_str

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




class DishEditeChooseCell_Three_Multiple: BaseTableViewCell {
    ///拼接
    private var selectIDArr: [String] = []

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
        img.image = LOIMG("dish_unsel_b")
        return img
    }()

    
    private let selectImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel_b")
        return img
    }()
    
    private let selectImg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel_b")
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
        if selectIDArr.contains("1") {
            selectIDArr = selectIDArr.filter { $0 != "1" }
        } else {
            selectIDArr.append("1")
        }
        dealSeletIDStr()
    }
    
    @objc private func clickbut2Action() {
        if selectIDArr.contains("2") {
            selectIDArr = selectIDArr.filter { $0 != "2" }
        } else {
            selectIDArr.append("2")
        }
        dealSeletIDStr()
    }
    
    
    @objc private func clickbut3Action() {
        if selectIDArr.contains("3") {
            selectIDArr = selectIDArr.filter { $0 != "3" }
        } else {
            selectIDArr.append("3")
        }
        dealSeletIDStr()
    }
    
    
    private func dealSeletIDStr() {
        var idStr = ""
        for (idx, id) in selectIDArr.enumerated() {
            if idx == 0 {
                idStr = id
            } else {
                idStr = idStr + "," + id
            }
        }
        selectBlock?(idStr)
    }
    
    
    func setCellData(titStr: String, l_str: String, m_str: String, r_str: String, typeStr: String) {
        
        if typeStr != "" {
            selectIDArr = typeStr.components(separatedBy: ",")
        } else {
            selectIDArr.removeAll()
        }
                
        titlab.text = titStr
        tlab1.text = l_str
        tlab2.text = m_str
        tlab3.text = r_str

        if selectIDArr.contains("1") {
            self.selectImg1.image = LOIMG("dish_sel_b")
        } else {
            self.selectImg1.image = LOIMG("dish_unsel_b")
        }
        
        if selectIDArr.contains("2") {
            self.selectImg2.image = LOIMG("dish_sel_b")
        } else {
            self.selectImg2.image = LOIMG("dish_unsel_b")
        }
        
        if selectIDArr.contains("3") {
            self.selectImg3.image = LOIMG("dish_sel_b")
        } else {
            self.selectImg3.image = LOIMG("dish_unsel_b")
        }
    }
}

