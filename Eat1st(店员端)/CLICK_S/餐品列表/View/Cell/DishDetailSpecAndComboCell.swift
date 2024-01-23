//
//  DishDetailSpecAndComboCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/17.
//

import UIKit

class DishDetailSpecAndComboCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    ///1是规格。2是套餐
    private var type: String = ""
    
    private var specData = SpecModel()
    private var comboData = ComboModel()
    
    private var selectIdxArr: [Int] = []
    
    var selectBlock: VoidBlock?
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false

        tableView.register(SpecNameCell.self, forCellReuseIdentifier: "SpecNameCell")
        tableView.register(SpecOptionCell.self, forCellReuseIdentifier: "SpecOptionCell")
        
        return tableView
    }()

    
    override func setViews() {
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "1" {
            return specData.optionList.count + 1
        }
        if type == "2" {
            return comboData.comboDishesList.count + 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == "1" {
            if indexPath.row == 0 {
                return specData.name_H
            } else {
                return specData.optionList[indexPath.row - 1].cell_H
            }
        }
        if type == "2" {
            if indexPath.row == 0 {
                return comboData.name_H
            } else {
                return comboData.comboDishesList[indexPath.row - 1].cell_H
            }
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecNameCell") as! SpecNameCell
            if type == "1" {
                cell.setCellDataWith(spec: specData)
            }
            if type == "2" {
                cell.setCellDataWith(combo: comboData)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecOptionCell") as! SpecOptionCell
        
        
        let isSelect = selectIdxArr.contains(indexPath.row) ? true: false

        if type == "1" {
            //规格
            cell.setCellDataWith(specOption: specData.optionList[indexPath.row - 1], isSelect: isSelect)
        }
        if type == "2" {
            //套餐
            cell.setCellDataWith(comboDish: comboData.comboDishesList[indexPath.row - 1], isSelect: isSelect)
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == "1" {
            //规格 需要进行单选多选
            if indexPath.row != 0 {
                if specData.multiple == "2" {
                    //可以多选
                    if selectIdxArr.contains(indexPath.row) {
                        selectIdxArr = selectIdxArr.filter { $0 != indexPath.row }
                    } else {
                        selectIdxArr.append(indexPath.row)
                    }
                } else {
                    //单选
                    if selectIdxArr.contains(indexPath.row) {
                        selectIdxArr = []
                    } else {
                        selectIdxArr = [indexPath.row]
                    }
                }
            }
        }
        
        if type == "2" {
            //套餐 每个都是单选
            //单选
            if selectIdxArr.contains(indexPath.row) {
                selectIdxArr = []
            } else {
                selectIdxArr = [indexPath.row]
            }
        }
        
        table.reloadData()
        selectBlock?(selectIdxArr)
        
    }
    
    
    func setCellDataWith(spec: SpecModel, idxArr: [Int]) {
        specData = spec
        selectIdxArr = idxArr
        type = "1"
        table.reloadData()
    }
    
    
    func setCellDataWith(combo: ComboModel, idxArr: [Int]) {
        comboData = combo
        selectIdxArr = idxArr
        type = "2"
        table.reloadData()
    }
    
}


class SpecNameCell: BaseTableViewCell {
    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(12), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(12), .right)
        lab.text = "(Required)(Multiple)"
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-135)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(namelab1.snp.bottom)
            $0.right.equalToSuperview().offset(-135)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
    }
    
    
    func setCellDataWith(spec: SpecModel) {
        namelab1.text = spec.specNameEn
        namelab2.text = spec.specNameHk
        
        if spec.required == "2" && spec.multiple == "2" {
            tlab.text = "(Required)(Multiple)"
        } else if spec.required == "2" && spec.multiple == "1" {
            tlab.text = "(Required)"
        } else if spec.required == "1" && spec.multiple == "2" {
            tlab.text = "(Multiple)"
        } else {
            tlab.text = ""
        }
    }
    
    func setCellDataWith(combo: ComboModel) {
        namelab1.text = combo.comboNameEn
        namelab2.text = combo.comboNameHk
        tlab.text = ""
    }
    
}

class SpecOptionCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FAFAFA")
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(13), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()

    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .right)
        lab.text = "+£0.00"
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xuanzhong")
        return img
    }()
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-90)
        }
        
        backView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-90)
            $0.top.equalTo(namelab1.snp.bottom)
        }
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 15, height: 13))
        }
    }
    
    
    func setCellDataWith(specOption: OptionModel, isSelect: Bool) {
        namelab1.text = specOption.optionNameEn
        namelab2.text = specOption.optionNameHk
        
        moneylab.text = "+£\(D_2_STR(specOption.price))"
        
        
        if isSelect {
            selectImg.isHidden = false
            backView.backgroundColor = HCOLOR("#FEF7DF")
            backView.layer.borderWidth = 2
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
            
        } else {
            selectImg.isHidden = true
            backView.backgroundColor = HCOLOR("#FAFAFA")
            backView.layer.borderWidth = 0
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
        }
    
    }
    
    
    func setCellDataWith(comboDish: ComboDishesModel, isSelect: Bool) {
        namelab1.text = comboDish.dishesNameEn
        namelab2.text = comboDish.dishesNameHk
        moneylab.text = ""
        
        if isSelect {
            selectImg.isHidden = false
            backView.backgroundColor = HCOLOR("#FEF7DF")
            backView.layer.borderWidth = 2
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
            
        } else {
            selectImg.isHidden = true
            backView.backgroundColor = HCOLOR("#FAFAFA")
            backView.layer.borderWidth = 0
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
        }

    }
    
}
