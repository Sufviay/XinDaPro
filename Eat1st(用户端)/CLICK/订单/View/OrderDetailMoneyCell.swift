//
//  OrderDetailMoneyCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/27.
//

import UIKit

class OrderDetailMoneyCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    private var dataModel = OrderDetailModel()
    
    private let titStrArr: [String] = ["Food and drink total", "Delivery charge", "Service charge", "Bag fee", "Dishes discount", "Coupon", "Store discount", "", "Checkout discount", "Total", "Wallet", "Wallet Spent", "Payment"]
    private var moneyArr: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(MoneyCell.self, forCellReuseIdentifier: "MoneyCell")
        tableView.register(DiscountMsgCell.self, forCellReuseIdentifier: "DiscountMsgCell")
        return tableView
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titStrArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 7 {
            if dataModel.discountMsg == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 1 {
            if dataModel.type == "1" {
                return 1
            } else {
                if moneyArr[section] == 0 {
                    return 0
                } else {
                    return 1
                }
            }
        }
        
        if section == 2 || section == 3 || section == 4 || section == 5 || section == 6 || section == 10 || section == 8 || section == 11 {
            if moneyArr[section] == 0 {
                return 0
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 7 {
            return dataModel.discountMsg_H
        }
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountMsgCell") as! DiscountMsgCell
            cell.setCellData(discountMsg: dataModel.discountMsg)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell") as! MoneyCell
            cell.setCellData(titStr: titStrArr[indexPath.section], money: moneyArr[indexPath.section], scale: dataModel.discountScale)
            return cell
        }
    }
    
    
    func setCellData(model: OrderDetailModel) {

        dataModel = model
        moneyArr = [model.actualFee, model.deliveryFee, model.serviceFee, model.packPrice, model.dishesDiscountAmount, model.couponAmount, model.discountAmount, 0, model.noPaidPrice, model.orderPrice, model.walletPrice, model.rechargePrice, model.payPrice]
        self.table.reloadData()
    }
    
}
