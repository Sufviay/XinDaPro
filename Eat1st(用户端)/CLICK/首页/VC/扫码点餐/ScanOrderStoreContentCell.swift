//
//  ScanOrderStoreContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/6/14.
//

import UIKit

class ScanOrderStoreContentCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    private var storeInfo = StoreInfoModel()
        
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
    ///显示信息的TableView
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(MenuDiscountCell.self, forCellReuseIdentifier: "MenuDiscountCell")
        return tableView
    }()

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if !storeInfo.isHaveDiscountBar {
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanOrderStoreInfoCell") as! ScanOrderStoreInfoCell
            cell.setCellData(model: storeInfo)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDiscountCell") as! MenuDiscountCell
            cell.setCellData(model: storeInfo)
            
            cell.clickBlock = { [unowned self] (_) in
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
    
        
        let cell = UITableViewCell()
        return cell
        
    }
    

    
    func setCellData(model: StoreInfoModel) {
        self.storeInfo = model
        self.table.reloadData()
    }
    

}
