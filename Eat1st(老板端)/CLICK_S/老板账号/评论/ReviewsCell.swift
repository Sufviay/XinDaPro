//
//  ReviewsCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/18.
//

import UIKit

class ReviewsCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    var clickDealBlock: VoidBlock?
    var clickDetailBlock: VoidBlock?
    
    
    private var dataModel = ReviewListModel()
    
    
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
        tableView.register(ReviewsStarCell.self, forCellReuseIdentifier: "ReviewsStarCell")
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
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if dataModel.content == "" {
                return 0
            }
        }
        
        if section == 3 {
            if dataModel.replyContent == "" {
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
            return 65
        }
        
        if indexPath.section == 2 {
            return dataModel.content_H
        }

        if indexPath.section == 3 {
            return dataModel.reply_H
        }
        
        if indexPath.section == 4 {
            return 75
        }

        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsNameCell") as! ComplaintsNameCell
            cell.setCellData(name: dataModel.name, orderNum: dataModel.orderId, tsNum: dataModel.plaintNum, xdNum: dataModel.buyNum, time: dataModel.createTime)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsStarCell") as! ReviewsStarCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsContentCell") as! ComplaintsContentCell
            cell.setCellData(content: dataModel.content)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsReplyCell") as! ComplaintsReplyCell
            cell.setCellData(content: "Reply content\n\(dataModel.replyContent)", time: "")
            return cell
        }

        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsButtonCell") as! ComplaintsButtonCell
            cell.setCellData(type: dataModel.replyStatus)
            
            cell.clickDealBlock = { [unowned self] (_) in
                clickDealBlock?("")
            }
            return cell
        }

        let cell = UITableViewCell()
        return cell
    }
    
    
    func setCellData(model: ReviewListModel) {
        self.dataModel = model
        self.table.reloadData()
    }

    
    
}
