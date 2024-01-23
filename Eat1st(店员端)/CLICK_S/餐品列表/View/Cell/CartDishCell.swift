//
//  CartDishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/19.
//

import UIKit

class CartDishCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var deleteBlock: VoidBlock?
    var detailBlock: VoidBlock?

    private var dataModel = CartDishModel()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(CartDishInfoCell.self, forCellReuseIdentifier: "CartDishInfoCell")
        tableView.register(CartDishSelectItemCell.self, forCellReuseIdentifier: "CartDishSelectItemCell")
        tableView.register(CartDishAttachItemCell.self, forCellReuseIdentifier: "CartDishAttachItemCell")
        tableView.register(CartDishFreeCell.self, forCellReuseIdentifier: "CartDishFreeCell")

        return tableView
    }()
    

    override func setViews() {
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    func setCellData(model: CartDishModel) {
        dataModel = model
        table.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        if section == 1 {
            return dataModel.itemList.count
        }
        if section == 2 {
            return dataModel.attachList.count
        }
        if section == 3 {
            if dataModel.isGiveOne {
                return 1
            } else {
                return 0
            }
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return dataModel.name_H
        }
        if indexPath.section == 1 {
            return dataModel.itemList[indexPath.row].cell_H
        }
        if indexPath.section == 2 {
            return dataModel.attachList[indexPath.row].cell_H
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishInfoCell") as! CartDishInfoCell
            cell.clickDeleteBlock = { [unowned self] (_) in
                deleteBlock?("")
            }
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishSelectItemCell") as! CartDishSelectItemCell
            cell.setCellData(model: dataModel.itemList[indexPath.row])
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishAttachItemCell") as! CartDishAttachItemCell
            cell.setCellData(model: dataModel.attachList[indexPath.row])
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishFreeCell") as! CartDishFreeCell
            cell.setCellData(count: dataModel.buyNum)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //进入详情页
        detailBlock?("")
        
    }
    
}
