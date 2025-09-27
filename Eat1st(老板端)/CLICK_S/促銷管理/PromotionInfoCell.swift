//
//  PromotionInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/18.
//

import UIKit

class PromotionInfoCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    private var isHistory: Bool = false
    
    var clickMoreBlock: VoidStringBlock?
    
    
    private var dataModel = CouponModel()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
            
        //tableView.isUserInteractionEnabled = false
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(NameCell.self, forCellReuseIdentifier: "NameCell")
        tableView.register(PromotionStatusCell.self, forCellReuseIdentifier: "PromotionStatusCell")
        tableView.register(PromotionMessageCell.self, forCellReuseIdentifier: "PromotionMessageCell")
        tableView.register(PromotionEndCell.self, forCellReuseIdentifier: "PromotionEndCell")
        return tableView
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    

    override func setViews() {
    
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let h = dataModel.couponName.getTextHeigh(TIT_4, S_W - 100) + 25
            return h
        }
        if indexPath.section == 1 {
            return 60
        }
        
        if indexPath.section == 2 {
            let h = dataModel.couponContentStr.getTextHeigh(TIT_3, S_W - 40) + 35
            return h
        }
        
        if indexPath.section == 3 {
            let h = dataModel.ruleStr.getTextHeigh(TIT_3, S_W - 40) + 35
            return h
        }
        if indexPath.section == 4 {
            return 20
        }
        
        return 50
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameCell
            cell.nameLab.text = dataModel.couponName
            if isHistory {
                cell.moreBut.isHidden = true
            } else {
                cell.moreBut.isHidden = false
            }
            
            cell.clickMoreBlock = { [unowned self] (type) in
                clickMoreBlock?(type)
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionStatusCell") as! PromotionStatusCell
            cell.setCellData(statusID: dataModel.status, couponType: dataModel.couponType)
            return cell
        }
        
        if indexPath.section == 2 || indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionMessageCell") as! PromotionMessageCell
        
            var titStr = ""
            var msg = ""
            
            if indexPath.section == 2 {
                titStr = "Promotion Content".local + ":"
                msg = dataModel.couponContentStr
                
            }
            if indexPath.section == 3 {
                titStr = "Promotion Cycle".local + ":"
                msg = dataModel.ruleStr
            }
            cell.setCellData(titStr: titStr, msgStr: msg)
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionEndCell") as! PromotionEndCell
            
            if dataModel.deadline == "" {
                cell.msgLab.text = "Indefinitely".local
            } else {
                cell.msgLab.text = dataModel.deadline
            }

            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func setCellData(model: CouponModel, history: Bool)  {
        isHistory = history
        if isHistory {
            table.isUserInteractionEnabled = false
        } else {
            table.isUserInteractionEnabled = true
        }
        dataModel = model
        table.reloadData()
    }

}
