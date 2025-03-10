//
//  MessageCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/12/15.
//

import UIKit

class MessageCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    
    private var dataModel = MessageModel()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.isUserInteractionEnabled = false
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MessageHearderCell.self, forCellReuseIdentifier: "MessageHearderCell")
        tableView.register(MessageLineCell.self, forCellReuseIdentifier: "MessageLineCell")
        tableView.register(MessageDetailCell.self, forCellReuseIdentifier: "MessageDetailCell")
        tableView.register(MessageChangeCell.self, forCellReuseIdentifier: "MessageChangeCell")
        return tableView
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        

        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }

        
    }
    
    
    func setCellData(model: MessageModel) {
        dataModel = model
        table.reloadData()
        

        
    }
    
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if dataModel.discountPrice == 0 {
                return 0
            }
        }
        
        if section == 2 {
            if !dataModel.isUpdatePayType {
                return 0
            }
        }
        
        if section == 3 {
            if dataModel.payTypeCashPrice == 0 {
                return 0
            }
        }
        
        if section == 4 {
            if dataModel.payTypePosPrice == 0 {
                return 0
            }
        }
        
        if section == 5 {
            if !dataModel.isUpdateDelivery {
                return 0
            }
        }
        
        if section == 6 {
            if !dataModel.isUpdateDishes {
                return 0
            }
        }
        
        if section == 7 {
            if !dataModel.isUpdateTotal {
                return 0
            }
        }
        
        
        if section == 8 {
            if dataModel.deskName == "" {
                return 0
            }
        }
    
        if section == 9 {
            if dataModel.couponPrice == 0 {
                return 0
            }
        }
        
        if section == 10 {
            if dataModel.couponNo == "" {
                return 0
            }
        }
        
        
        if section == 11 {
            if dataModel.cashPrice == 0 {
                return 0
            }
        }
        
        if section == 12 {
            if dataModel.posPrice == 0 {
                return 0
            }
        }
        
        if section == 13 {
            if dataModel.tipCashPrice == 0 {
                return 0
            }
        }
        
        if section == 14 {
            if dataModel.tipPosPrice == 0 {
                return 0
            }
        }
        
        if section == 15 {
//            if dataModel.operateType == "6" || dataModel.operateType == "7" {
//                return 0
//            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            if dataModel.orderID == "0" {
                return 60
            } else {
                return 75
            }
        }
        
        if indexPath.section == 15 {
            return 40
        }
    
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHearderCell") as! MessageHearderCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDetailCell") as! MessageDetailCell
            return cell

        }
        
        if indexPath.section == 2 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChangeCell") as! MessageChangeCell
            
            if indexPath.section == 2 {
                cell.setCellData(titStr: "Payment method", oldStr: dataModel.oldPayType, newStr: dataModel.newPayType)
            }
            
            if indexPath.section == 5 {
                cell.setCellData(titStr: "Delivery price", oldStr: D_2_STR(dataModel.oldDeliveryPrice), newStr: D_2_STR(dataModel.newDeliveryPrice))
            }

            if indexPath.section == 6 {
                cell.setCellData(titStr: "Dishes price", oldStr: D_2_STR(dataModel.oldDishesPrice), newStr: D_2_STR(dataModel.newDishesPrice))
            }

            if indexPath.section == 7 {
                cell.setCellData(titStr: "Order price", oldStr: D_2_STR(dataModel.oldOrderPrice), newStr: D_2_STR(dataModel.newOrderPrice))
            }

            
            return cell
            
        }
        
        
        if indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 10 || indexPath.section == 11 || indexPath.section == 12 || indexPath.section == 13 || indexPath.section == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLineCell") as! MessageLineCell
            if indexPath.section == 1 {
                cell.setCellData(titStr: "Order checkout discount", money: D_2_STR(dataModel.discountPrice), isHide: false)
            }
            if indexPath.section == 3 {
                cell.setCellData(titStr: "Cash payment", money: D_2_STR(dataModel.payTypeCashPrice), isHide: false)
            }
            if indexPath.section == 4 {
                cell.setCellData(titStr: "Pos payment", money: D_2_STR(dataModel.payTypePosPrice), isHide: false)
            }
            
            if indexPath.section == 8 {
                cell.setCellData(titStr: dataModel.deskName, money: "", isHide: true)
            }
            
            if indexPath.section == 9 {
                cell.setCellData(titStr: "Credit coupon", money: "£" + D_2_STR(dataModel.couponPrice), isHide: false)
            }
            
            if indexPath.section == 10 {
                cell.setCellData(titStr:  "Number", money:  dataModel.couponNo, isHide: false)
            }
            
            if indexPath.section == 11 {
                cell.setCellData(titStr: "Cash", money: "£" + D_2_STR(dataModel.cashPrice), isHide: false)
            }
            
            if indexPath.section == 12 {
                cell.setCellData(titStr: "Pos", money: "£" + D_2_STR(dataModel.posPrice), isHide: false)
            }
            
            if indexPath.section == 13 {
                cell.setCellData(titStr: "Cash tips", money: "£" + D_2_STR(dataModel.tipCashPrice), isHide: false)
            }
            
            if indexPath.section == 14 {
                cell.setCellData(titStr: "Pos tips", money: "£" + D_2_STR(dataModel.tipPosPrice), isHide: false)
            }
            
            return cell
        }
    
        let cell = UITableViewCell()
        return cell

    }
}


class MessageHearderCell: BaseTableViewCell {
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("msgimg")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .left)
        lab.text = "Rejected order"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .right)
        lab.text = "2021-05-16 12:45"
        return lab
    }()
    
    private let czrLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "操作人"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(11), .left)
        lab.text = "orderID"
        return lab
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.top.equalToSuperview().offset(15)
        }
        
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(10)
        }
        
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(czrLab)
        czrLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.top.equalTo(czrLab.snp.bottom).offset(0)
            $0.left.equalTo(czrLab)
        }
        
    }
    
    func setCellData(model: MessageModel) {
        czrLab.text = model.createBy
        
        if model.orderID == "0" {
            orderLab.text = ""
        } else {
            orderLab.text = "#\(model.orderID)"
        }
        
        timeLab.text = model.createTime

        if model.operateType == "1" {
            //拒接订单
            titLab.text = "Rejected order"
        }

        if model.operateType == "2" {
            //取消订单
            titLab.text = "Cancelled order"
        }

        if model.operateType == "3" {
            //修改订单
            titLab.text = "Changed order"
        }
        
        if model.operateType == "4" {
            //打折订单
            titLab.text = "Discounted order"
        }
        
        
        if model.operateType == "5" {
            //修改支付方式
            titLab.text = "Changed payment method"
        }

        if model.operateType == "6" {
            //预付
            titLab.text = "Credit"
        }
        
        if model.operateType == "7" {
            //删除预付
            titLab.text = "Delete credit"
        }
        
        if model.operateType == "8" {
            ///
            titLab.text = "Print summary"
        }
        
        if model.operateType == "9" {
            titLab.text = "Delete dishes"
        }
        
        if model.operateType == "10" {
            titLab.text = "Top up"
        }
        
        if model.operateType == "11" {
            titLab.text = "Wallet spent"
        }
        
        if model.operateType == "12" {
            titLab.text = "change service charge"
        }
    }
    
}


class MessageLineCell: BaseTableViewCell {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(11), .left)
        lab.text = "Orders are discounted"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(11), .left)
        lab.text = ""
        return lab
    }()

    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(titLab.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    func setCellData(titStr: String, money:String, isHide: Bool) {
    
        moneyLab.isHidden = isHide
        
        titLab.text = titStr
        moneyLab.text = money 
    }
    
}


class MessageDetailCell: BaseTableViewCell {
    
    private let detailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(13), .left)
        lab.text = "View order details"
        return lab
    }()

    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()
    
    override func setViews() {
    
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.addSubview(detailLab)
        detailLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(detailLab)
        }
        
    }
}


class MessageChangeCell: BaseTableViewCell {
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(11), .left)
        lab.text = "Orders are discounted"
        return lab
    }()
    
    private let clab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(11), .left)
        lab.text = ""
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(11), .left)
        lab.text = "to"
        return lab
    }()
    
    private let clab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(11), .left)
        lab.text = ""
        return lab
    }()


    
    
    override func setViews() {
    
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(clab1)
        clab1.snp.makeConstraints {
            $0.left.equalTo(tlab1.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(clab1.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(clab2)
        clab2.snp.makeConstraints {
            $0.left.equalTo(tlab2.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }

    }
    
    
    func setCellData(titStr: String, oldStr: String, newStr: String) {
        tlab1.text = titStr
        clab1.text = oldStr
        clab2.text = newStr
    }
    
}


