//
//  DineInStoreInfoView.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/27.
//

import UIKit

class DineInStoreInfoView: UIView, UITableViewDelegate, UITableViewDataSource {

    
    private var storeInfo = StoreInfoModel()

    
    ///显示信息的TableView
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 14
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
        tableView.register(ScanOrderStoreInfoCell.self, forCellReuseIdentifier: "ScanOrderStoreInfoCell")
        tableView.register(DineInMenuDiscountCell.self, forCellReuseIdentifier: "DineInMenuDiscountCell")
        tableView.register(MenuVipCell.self, forCellReuseIdentifier: "MenuVipCell")
        return tableView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .clear
        
        self.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
        }

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
//            if !storeInfo.isHaveDiscountBar {
//                return 0
//            }
            return 0
        }
    
        if section == 2 {
            if !storeInfo.isVip {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return storeInfo.scanStoreInfo_H
        }
        if indexPath.section == 1 {
            return 28
        }
        if indexPath.section == 2 {
            return SET_H(50, 345) + 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanOrderStoreInfoCell") as! ScanOrderStoreInfoCell
            cell.setCellData(model: storeInfo)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DineInMenuDiscountCell") as! DineInMenuDiscountCell
            cell.setCellData(model: storeInfo)
            
            cell.clickRedeemBlock = { [unowned self] (_) in
                if PJCUtil.checkLoginStatus() {
                    //MARK: - 积分兑换优惠券
                    let nextVC = ExchangeJiFenController()
                    nextVC.storeID = storeInfo.storeID
                    nextVC.storeName = storeInfo.name
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }

            return cell
        }

        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuVipCell") as! MenuVipCell
            cell.setCellData(model: storeInfo, canClick: true)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }

    
    func setData(model: StoreInfoModel) {
        self.storeInfo = model
        self.table.reloadData()
    }

}
