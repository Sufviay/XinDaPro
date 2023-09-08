//
//  ComplaintsCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    var clickDealBlock: VoidBlock?
    
    var clickDetailBlock: VoidBlock?
    
    var clickShowBlock: VoidBlock?
    
    private var dataModel = ComplaintsModel()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ComplaintsNameCell.self, forCellReuseIdentifier: "ComplaintsNameCell")
        tableView.register(ComplaintsReasonCell.self, forCellReuseIdentifier: "ComplaintsReasonCell")
        tableView.register(ComplaintsPictureCell.self, forCellReuseIdentifier: "ComplaintsPictureCell")
        tableView.register(ComplaintsContentCell.self, forCellReuseIdentifier: "ComplaintsContentCell")
        tableView.register(ComplaintsReplyCell.self, forCellReuseIdentifier: "ComplaintsReplyCell")
        tableView.register(ComplaintsButtonCell.self, forCellReuseIdentifier: "ComplaintsButtonCell")
        return tableView
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if dataModel.isShow {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 2 {
            if dataModel.isShow {
                if dataModel.plaintImgs.count == 0 {
                    return 0
                } else {
                    return 1
                }
            } else {
                return 0
            }
        }
        
        if section == 3 {
            if dataModel.isShow {
                if dataModel.userHope == "" {
                    return 0
                } else {
                    return 1
                }
            } else {
                return 0
            }
        }
        
        if section == 4 {
            if dataModel.isShow  {
                if dataModel.handleType == "1" {
                    //未处理
                    return 0
                } else {
                    return 1
                }
            } else {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        if indexPath.section == 1 {
            return dataModel.reason_H
        }
        if indexPath.section == 2 {
            return dataModel.picture_H
        }
        if indexPath.section == 3 {
            return dataModel.hope_H
        }
        if indexPath.section == 4 {
            return dataModel.reply_H
        }
        
        if indexPath.section == 5 {
            return 75
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsNameCell") as! ComplaintsNameCell
            cell.setCellData(name: dataModel.name, orderNum: dataModel.orderId, tsNum: dataModel.plaintNum, xdNum: dataModel.buyNum, time: dataModel.createTime)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsReasonCell") as! ComplaintsReasonCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsPictureCell") as! ComplaintsPictureCell
            cell.setCellData(imgs: dataModel.plaintImgs)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsContentCell") as! ComplaintsContentCell
            cell.setCellData(content: dataModel.userHope)
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsReplyCell") as! ComplaintsReplyCell
            cell.setCellData(content: dataModel.replyContent, time: dataModel.handleTime)
            return cell
        }
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsButtonCell") as! ComplaintsButtonCell
            cell.clickDealBlock = { [unowned self] _ in
                clickDealBlock?("")
                
            }
            cell.clickDetailBlock = { [unowned self] _ in
                clickDetailBlock?("")
                
            }
            
            cell.setCellData(type: dataModel.handleType)
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if !dataModel.isShow {
                clickShowBlock?("")
            }
        }
    }
    
    
    func setCellData(model: ComplaintsModel) {
        dataModel = model
        table.reloadData()
    }
    
    
}



