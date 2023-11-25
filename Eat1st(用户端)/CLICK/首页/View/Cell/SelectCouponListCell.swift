//
//  SelectCouponListCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/23.
//

import UIKit

class SelectCouponListCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //private var couponSelected: Bool = false
    
    private var selectCouponModel = CouponModel()
    
    var clickRuleBlock: VoidBlock?
    
    var clickDishesMoreBlock: VoidBlock?
    
    var clickCouponBlock: VoidBlock?
    
    var clickCouponDishBlock: VoidBlock?

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
        tableView.register(SeledctCouponContentCell.self, forCellReuseIdentifier: "SeledctCouponContentCell")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeledctCouponContentCell") as! SeledctCouponContentCell
            let isSelect = dataModel.couponId == selectCouponModel.couponId ? true : false
            
            cell.setCellData(model: dataModel, isSelect: isSelect)
            cell.clickRuleBlock = { [unowned self] (_) in
                clickRuleBlock?("")
            }
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiftDishesCell") as! GiftDishesCell
            
            let isSelect = dataModel.dishesList[indexPath.row].couponUserDishesId == selectCouponModel.selCouponUserDishesId ? true : false
            
            cell.setCouponCellData(model: dataModel.dishesList[indexPath.row], canChoose: true, isSelected: isSelect)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponShowMoreCell") as! CouponShowMoreCell
        cell.setCellData(isShow: dataModel.dishIsOpen)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            clickCouponBlock?("")
        }
        
        if indexPath.section == 2 {
            clickDishesMoreBlock?("")
        }
        
        if indexPath.section == 1 {
            //点击菜品
            
            let dishModel = dataModel.dishesList[indexPath.row]
            
            if dishModel.couponUserDishesId == selectCouponModel.selCouponUserDishesId {
                //取消选中
                clickCouponDishBlock?(["", ""])
            } else {
                //选中
                clickCouponDishBlock?([dishModel.dishName, dishModel.couponUserDishesId])
            }
            
        }
    }
    
    
    func setCellData(model: CouponModel, selectModel: CouponModel) {
        
        selectCouponModel = selectModel
        dataModel = model
        table.reloadData()
    }

}
