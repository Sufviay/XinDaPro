//
//  SizeOptionCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/21.
//

import UIKit





class SpecificationsCell: BaseTableViewCell, UITableViewDataSource, UITableViewDelegate {


    var selectBlock: VoidBlock?
    
    private var dataModel = SpecificationModel()
    
    private var selectIdxArr: [Int] = []
    
    private lazy var table: GestureTableView = {
        let tableView = GestureTableView()
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
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10

        tableView.register(SizeNameCell.self, forCellReuseIdentifier: "SizeNameCell")
        tableView.register(SizeOptionCell.self, forCellReuseIdentifier: "SizeOptionCell")
        
        return tableView
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.optionArr.count + 1
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeNameCell") as! SizeNameCell
            cell.setCellData(model: dataModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeOptionCell") as! SizeOptionCell
            
            let isSelect = selectIdxArr.contains(indexPath.row) ? true: false
            cell.setCellData(opModel: dataModel.optionArr[indexPath.row - 1], isSelect: isSelect, spModel: dataModel)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            if dataModel.isOn && dataModel.optionArr[indexPath.row - 1].isOn {
                
                if dataModel.isMultiple {
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
                
                table.reloadData()
                self.selectBlock?(selectIdxArr)
                
//                if indexPath.row != selectIdx {
//                    self.selectIdx = indexPath.row
//                    self.table.reloadData()
//                    self.selectBlock?(indexPath.row)
//                } else {
//                    self.selectIdx = 1000
//                    self.table.reloadData()
//                    self.selectBlock?(1000)
//                }
            }
        }
    }
    
    

    func setCellData(model: SpecificationModel, idxArr: [Int]) {
        self.dataModel = model
        self.selectIdxArr = idxArr
        self.table.reloadData()
    }
}


class SizeNameCell: BaseTableViewCell {
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "specifications "
        return lab
    }()
    
    private let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "((You must select))"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nameLab.snp.right).offset(5)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func setCellData(model: SpecificationModel) {
    
        if model.isOn {
            self.nameLab.textColor = FONTCOLOR
            self.tagLab.textColor = MAINCOLOR
        } else {
            self.nameLab.textColor = HCOLOR("999999")
            self.tagLab.textColor = HCOLOR("999999")
        }
        
        self.nameLab.text = model.name_E
        self.tagLab.text = model.isRequired ? "(Required)" : "(Optional)"
    }
    
}


class SizeOptionCell: BaseTableViewCell {
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "options"
        return lab
    }()
    
    
    private let moneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .right)
        lab.text = "+￡0.8"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(moneLab)
        moneLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
        }
        
    }
    
    func setCellData(opModel: DishOptionModel, isSelect: Bool, spModel: SpecificationModel) {
        
        if spModel.isOn {
            if opModel.isOn {
                self.nameLab.textColor = FONTCOLOR
                self.moneLab.textColor = MAINCOLOR
            } else {
                self.nameLab.textColor = HCOLOR("999999")
                self.moneLab.textColor = HCOLOR("999999")
            }
        } else {
            self.nameLab.textColor = HCOLOR("999999")
            self.moneLab.textColor = HCOLOR("999999")
        }
        
        if isSelect {
            self.contentView.backgroundColor = HCOLOR("#FFEBDD")
        } else {
            self.contentView.backgroundColor = .white
        }
        
        self.nameLab.text = opModel.name_E
        self.moneLab.text = "+￡\(D_2_STR(opModel.fee))"
    }
    
}
