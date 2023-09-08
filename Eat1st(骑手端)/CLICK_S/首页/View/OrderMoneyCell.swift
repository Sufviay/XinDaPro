//
//  OrderMoneyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderMoneyCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    private var dataModel = OrderModel()
    
    private let titStrArr: [String] = ["Subtotal", "Delivery fee", "Service charge", "Bag fee", "Dishes discount", "Coupon", "Discount", "", "Total", "Wallet", "Payment", "Payment Method"]
    private var moneyArr: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
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
        if section == 3 || section == 4 || section == 5 || section == 6 || section == 9 {
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
            cell.setCellData(titStr: titStrArr[indexPath.section], money: moneyArr[indexPath.section], scale: dataModel.discountScale, method: dataModel.paymentMethod)
            return cell
        }
    }
    

    func setCellData(model: OrderModel) {

        dataModel = model
        moneyArr = [model.actualFee, model.deliveryFee, model.serviceFee, model.packPrice, model.dishesDiscountAmount, model.couponAmount, model.discountAmount, 0, model.orderPrice, model.walletPrice, model.payPrice, 0]
        self.table.reloadData()
    }
}



class MoneyCell: BaseTableViewCell {
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Service fee"
        return lab
    }()
    
    private let discountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF461C"), SFONT(13), .left)
        lab.text = "(50%OFF)"
        return lab
    }()

    private let discountImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("discount")
        return img
    }()
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(discountLab)
        discountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titLab.snp.right).offset(10)
        }
        
        contentView.addSubview(discountImg)
        discountImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(moneyLab.snp.left).offset(-10)
        }
        
    }
    
    func setCellData(titStr: String, money: Double , scale: String, method: String) {
        
        
        
        
        if titStr == "Discount" || titStr == "Wallet" || titStr == "Dishes discount" || titStr == "Coupon" {
            self.moneyLab.textColor = HCOLOR("FF461C")
            self.titLab.textColor = FONTCOLOR
        } else if titStr == "Payment" {
            self.moneyLab.textColor = MAINCOLOR
            self.titLab.textColor = MAINCOLOR
        } else {
            self.moneyLab.textColor = FONTCOLOR
            self.titLab.textColor = FONTCOLOR
        }
        
        if titStr == "Discount" {
            self.discountImg.isHidden = false
            self.discountLab.isHidden = false
        } else {
            self.discountImg.isHidden = true
            self.discountLab.isHidden = true
        }
        
        if titStr == "Discount" || titStr == "Wallet" || titStr == "Dishes discount" || titStr == "Coupon"{
            self.moneyLab.text = "-£\(D_2_STR(money))"
        } else if titStr == "Payment Method" {
            if method == "1" {
                //现金
                self.moneyLab.text = "cash"
            }
            else if method == "2" {
                self.moneyLab.text = "card"
            }
            else {
                self.moneyLab.text = ""
            }
        }
        else {
            self.moneyLab.text = "£\(D_2_STR(money))"
        }
        self.titLab.text = titStr
        self.discountLab.text = "(\(scale)OFF)"
        
    }
    
    
}

class DiscountMsgCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFF6F3")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF4E26"), SFONT(10), .left)
        lab.numberOfLines = 0
        return lab
    }()

    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    
    func setCellData(discountMsg: String) {
        self.msgLab.text = discountMsg
    }
    
    
}


