//
//  MenuStoreContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/13.
//

import UIKit

class MenuStoreContentCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    private var dataModel = StoreInfoModel()
    
    private var buyType: String = ""
    
    ///购买方式
    var clickBuyTypeBlock: VoidStringBlock?
    
    
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
        
        tableView.register(MenuStoreInfoCell.self, forCellReuseIdentifier: "MenuStoreInfoCell")
        tableView.register(MenuDiscountCell.self, forCellReuseIdentifier: "MenuDiscountCell")
        tableView.register(MenuSelectCell.self, forCellReuseIdentifier: "MenuSelectCell")
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if !dataModel.isHaveDiscountBar {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return dataModel.storeInfo_H
        }
        if indexPath.section == 1 {
            return 28
        }
        
        if indexPath.section == 2 {
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuStoreInfoCell") as! MenuStoreInfoCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDiscountCell") as! MenuDiscountCell
            cell.setCellData(model: dataModel)
            
            cell.clickBlock = { [unowned self] (_) in
                if PJCUtil.checkLoginStatus() {
                    //MARK: - 积分兑换优惠券
                    let nextVC = ExchangeJiFenController()
                    nextVC.storeID = dataModel.storeID
                    nextVC.storeName = dataModel.name
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }

            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSelectCell") as! MenuSelectCell
            cell.setData(model: dataModel, selectWay: buyType)
            
            cell.clickBlock = { [unowned self] (type) in

                self.clickBuyTypeBlock?(type)
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    

    
    func setCellData(model: StoreInfoModel, selectType: String) {
        self.dataModel = model
        self.buyType = selectType
        self.table.reloadData()
    }
    

}
