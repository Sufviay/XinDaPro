//
//  OrderDishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderDishCell: BaseTableViewCell, UITableViewDataSource, UITableViewDelegate {

    
    private var dataModel = OrderDishModel()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderDishInfoCell.self, forCellReuseIdentifier: "OrderDishInfoCell")
        tableView.register(OrderDishSelectItemCell.self, forCellReuseIdentifier: "OrderDishSelectItemCell")
        tableView.register(OrderDishAttatchItemCell.self, forCellReuseIdentifier: "OrderDishAttatchItemCell")
        tableView.register(OrderDishFreeCell.self, forCellReuseIdentifier: "OrderDishFreeCell")

        return tableView
    }()
    
    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return dataModel.optionList.count
        }
        if section == 2 {
            return dataModel.comboList.count
        }
        if section == 3 {
            return dataModel.attachList.count
        }
        if section == 4 {
            if dataModel.giveOne == "2" {
                return 1
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return dataModel.name_H
        }
        if indexPath.section == 1 {
            return dataModel.optionList[indexPath.row].cell_H
        }
        if indexPath.section == 2 {
            return dataModel.comboList[indexPath.row].cell_H
        }
        if indexPath.section == 3 {
            return dataModel.attachList[indexPath.row].cell_H
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishInfoCell") as! OrderDishInfoCell
            cell.setCellData(model: dataModel)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishSelectItemCell") as! OrderDishSelectItemCell
            cell.setCellData(model: dataModel.optionList[indexPath.row])
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishSelectItemCell") as! OrderDishSelectItemCell
            cell.setCellData(model: dataModel.comboList[indexPath.row])
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishAttatchItemCell") as! OrderDishAttatchItemCell
            cell.setCellData(model: dataModel.attachList[indexPath.row])
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishFreeCell") as! OrderDishFreeCell
            cell.setCellData(count: dataModel.buyNum)
            return cell
        }
    
        let cell = UITableViewCell()
        return cell
    }
    

    func setCellData(model: OrderDishModel) {
        dataModel = model
        table.reloadData()
    }
    
    
}
