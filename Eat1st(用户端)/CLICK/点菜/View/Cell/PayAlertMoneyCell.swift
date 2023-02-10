//
//  PayAlertMoneyCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/27.
//

import UIKit

class PayAlertMoneyCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    private var discountScale: String = ""
    
    private let titStrArr: [String] = ["Subtotal", "Delivery fee", "Service fee", "Bag fee", "Dishes discount", "Coupon", "Discount", "Total"]
    private var moneyArr: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]

    
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
        
        if section == 3 || section == 4 || section == 5 || section == 6 {
            if moneyArr[section] == 0 {
                return 0
            } else {
                return 1
            }
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell") as! MoneyCell
        cell.setCellData(titStr: titStrArr[indexPath.section], money: moneyArr[indexPath.section], scale: self.discountScale)
        return cell
    }
    
    func setCellData(money: [Double], scale: String) {
        discountScale = scale
        moneyArr = money
        self.table.reloadData()
    }
    

}



class PayAlertPayCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    private let titStrArr: [String] = ["Wallet", "Payment"]
    private var moneyArr: [Double] = [0, 0]

    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if moneyArr[section] == 0 {
                return 0
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell") as! MoneyCell
        cell.setCellData(titStr: titStrArr[indexPath.section], money: moneyArr[indexPath.section], scale: "")
        return cell
    }
    
    func setCellData(money: [Double]) {
        moneyArr = money
        self.table.reloadData()
    }
    
}

