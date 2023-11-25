//
//  CouponListCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/23.
//

import UIKit

class CouponListCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var clickRuleBlock: VoidBlock?
    
    var clickDishesMoreBlock: VoidBlock?
    
    private var dataModel = CouponModel()


    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        
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
        tableView.isScrollEnabled = false
        tableView.register(CouponContentCell.self, forCellReuseIdentifier: "CouponContentCell")
        tableView.register(GiftDishesCell.self, forCellReuseIdentifier: "GiftDishesCell")
        tableView.register(CouponShowMoreCell.self, forCellReuseIdentifier: "CouponShowMoreCell")
        return tableView
    }()

    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if dataModel.dishesList.count == 0 {
                return 0
            } else {
                if dataModel.dishIsOpen {
                    return dataModel.dishesList.count
                } else {
                    return 0
                }
            }
        }
        
        if section == 2 {
            if dataModel.dishesList.count == 0 {
                return 0
            } else {
                return 1
            }
        }

        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return dataModel.content_H
        }
        if indexPath.section == 1 {
            return dataModel.dishesList[indexPath.row].giftDish_H
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CouponContentCell") as! CouponContentCell
            cell.setCellData(model: dataModel)
            cell.clickRuleBlock = { [unowned self] (_) in
                clickRuleBlock?("")
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiftDishesCell") as! GiftDishesCell
            cell.setCouponCellData(model: dataModel.dishesList[indexPath.row], canChoose: false, isSelected: false)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponShowMoreCell") as! CouponShowMoreCell
        cell.setCellData(isShow: dataModel.dishIsOpen)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            clickDishesMoreBlock?("")
        }
    }
    
    
    func setCellData(model: CouponModel) {
        self.dataModel = model
        table.reloadData()
    }

}
