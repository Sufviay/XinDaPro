//
//  DishesItemContentCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/17.
//

import UIKit

class DishesItemContentCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {


    var clickShowBlock: VoidStringBlock?
    var clickSelectBlock: VoidBlock?
    
    var clickSpecBlock: VoidStringBlock?
    var clickOptionBlock: VoidStringBlock?
    
    private var dataModel = DishModel()

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
    
        tableView.register(DishesItemCell.self, forCellReuseIdentifier: "DishesItemCell")
        tableView.register(DishesSpecItemCell.self, forCellReuseIdentifier: "DishesSpecItemCell")
        tableView.register(DishesSpecNameCell.self, forCellReuseIdentifier: "DishesSpecNameCell")
        
        return tableView
        
    }()

    
    override func setViews() {
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.optionArr.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return dataModel.optionArr[section - 1].itemArr.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.section == 0 {
            return dataModel.dish_H
        } else {
            if indexPath.row == 0 {
                return dataModel.optionArr[indexPath.section - 1].option_H
            } else {
                return dataModel.optionArr[indexPath.section - 1].itemArr[indexPath.row - 1].optionItem_H
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesItemCell") as! DishesItemCell
            cell.setCellData(model: dataModel)
            
            cell.selectBlock = { [unowned self] (_) in
                self.clickSelectBlock?("")
            }
            return cell
            
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishesSpecNameCell") as! DishesSpecNameCell
                cell.setCellData(model: dataModel.optionArr[indexPath.section - 1])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishesSpecItemCell") as! DishesSpecItemCell
                cell.setCellData(model: dataModel.optionArr[indexPath.section - 1].itemArr[indexPath.row - 1])
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if dataModel.haveSpec {
                
                if dataModel.optionArr.count == 0 {
                    self.clickShowBlock?("show")
                } else {
                    self.clickShowBlock?("hide")
                }
            }
        } else {
            
            if indexPath.row == 0 {
                self.clickSpecBlock?(dataModel.optionArr[indexPath.section - 1].specId)
            } else {
                self.clickOptionBlock?(dataModel.optionArr[indexPath.section - 1].itemArr[indexPath.row - 1].optionId)
            }
        }
        
        
    }
    
    
    func setCellData(dish: DishModel) {
        self.dataModel = dish
        self.table.reloadData()
    }


    

}
