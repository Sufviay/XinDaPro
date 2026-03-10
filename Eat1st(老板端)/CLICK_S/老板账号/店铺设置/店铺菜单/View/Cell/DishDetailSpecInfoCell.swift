//
//  DishDetailSpecInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailSpecInfoCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var clickEditeSpecBlock: VoidBlock?
    var clickEditeOptionBlock: VoidIntBlock?
    
    private var dataModel = DishDetailSpecModel()

    private var curIdx: Int = 0
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.register(SpecHeaderEditeCell.self, forCellReuseIdentifier: "SpecHeaderEditeCell")
        tableView.register(DishDetailSpecNameCell.self, forCellReuseIdentifier: "DishDetailSpecNameCell")
        tableView.register(DishDetailMsgCell.self, forCellReuseIdentifier: "DishDetailMsgCell")
        tableView.register(OptionHeaderCell.self, forCellReuseIdentifier: "OptionHeaderCell")
        tableView.register(OptionHeaderEditeCell.self, forCellReuseIdentifier: "OptionHeaderEditeCell")
        tableView.register(DishDetailOptionMsgCell.self, forCellReuseIdentifier: "DishDetailOptionMsgCell")
        tableView.register(DishDetailOptionNameCell.self, forCellReuseIdentifier: "DishDetailOptionNameCell")
        tableView.register(DishDetailOptionPriceCell.self, forCellReuseIdentifier: "DishDetailOptionPriceCell")
        
        return tableView
        
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.optionList.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            }
            
            if indexPath.row == 1 {
                return dataModel.name_h
            }
            
            if indexPath.row == 2 || indexPath.row == 3 {
                return 65
            }
            
            if indexPath.row == 4 {
                return 55
            }
        } else {
            if indexPath.row == 0 {
                return 45
            }
            if indexPath.row == 1 {
                return dataModel.optionList[indexPath.section - 1].name_h
            }
//            if indexPath.row == 2  {
//                return 60
//            }
            if indexPath.row == 2 {
                return 70
            }
                
        }
        
        return 50

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecHeaderEditeCell") as! SpecHeaderEditeCell
                cell.setCellData(numStr: curIdx)
                cell.clickBlock = { [unowned self] (_) in
                    //编辑规格
                    self.clickEditeSpecBlock?("")
                }
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailSpecNameCell") as! DishDetailSpecNameCell
                cell.setCellData(model: dataModel)
                return cell
            }
            
            if indexPath.row == 2 || indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msgStr = ""
                
                if indexPath.row == 2 {
                    if dataModel.required == "2" {
                        msgStr = "Required".local
                    } else {
                        msgStr = "Optional".local
                    }
                    cell.setCellData(titStr: "Choose".local, msgStr: msgStr)
                }
                
                if indexPath.row == 3 {
                    if dataModel.multiple == "1" {
                        msgStr = "Disable".local
                    } else {
                        msgStr = "Enable".local
                    }
                    cell.setCellData(titStr: "Multi-select".local, msgStr: msgStr)
                }
                
//                if indexPath.row == 4 {
//                    if dataModel.statusId == "1" {
//                        msgStr = "On menu"
//                    } else {
//                        msgStr = "Off menu"
//                    }
//                    cell.setCellData(titStr: "Specification state", msgStr: msgStr)
//                }
                
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionHeaderCell") as! OptionHeaderCell
                return cell
            }
            
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionHeaderEditeCell") as! OptionHeaderEditeCell
                cell.setCellData(number: indexPath.section)
                cell.clickBlock = { [unowned self] (_) in
                    //编辑选项
                    self.clickEditeOptionBlock?(indexPath.section - 1)
                }

                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailOptionNameCell") as! DishDetailOptionNameCell
                cell.setCellData(model: dataModel.optionList[indexPath.section - 1])
                return cell
            }
            
//            if indexPath.row == 2 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailOptionMsgCell") as! DishDetailOptionMsgCell
//                var msgStr = ""
//                if dataModel.optionList[indexPath.section - 1].statusId == "1" {
//                    msgStr = "On menu"
//                } else {
//                    msgStr = "Off menu"
//                }
//                cell.setCellData(titStr: "Option state", msgStr: msgStr)
//                return cell
//            }
            
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailOptionPriceCell") as! DishDetailOptionPriceCell
                let price = dataModel.optionList[indexPath.section - 1].price
                cell.setCellData(price: price)
                return cell
            }
        
        }
        
        let cell = UITableViewCell()
        return cell
    }

    
    
    
    func setCellData(model: DishDetailSpecModel, idx: Int) {
        self.dataModel = model
        self.curIdx = idx
        self.table.reloadData()
    }

}
