//
//  OrderDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/12.
//

import UIKit
import RxSwift

class OrderDetailController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate {
    

    
    var orderID: String = ""
    
    ///订单来源(0：Eat1st，1：Deliveroo，2：UberEats，3：JustEat)[
    var souceType: String = ""
    
    private let bag = DisposeBag()
    
    private var dataModel = OrderDetailModel()
    
    private var sectionNum: Int = 0

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()


    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DetailStatusCell.self, forCellReuseIdentifier: "DetailStatusCell")
        tableView.register(DetailUserInfoCell.self, forCellReuseIdentifier: "DetailUserInfoCell")
        tableView.register(DetailAddressCell.self, forCellReuseIdentifier: "DetailAddressCell")
        tableView.register(DetailMessageCell.self, forCellReuseIdentifier: "DetailMessageCell")
        tableView.register(CancelReasonCell.self, forCellReuseIdentifier: "CancelReasonCell")
        tableView.register(DetailTitleCell.self, forCellReuseIdentifier: "DetailTitleCell")
        tableView.register(DishesShowCell.self, forCellReuseIdentifier: "DishesShowCell")
        tableView.register(DetailMoneyCell.self, forCellReuseIdentifier: "DetailMoneyCell")
        tableView.register(DishesFreeCell.self, forCellReuseIdentifier: "DishesFreeCell")
        return tableView
    }()

    
    
    
    
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Order Details".local
    }

    
    
    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalToSuperview().offset(20)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
    }
    
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

    
    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: orderID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            dataModel.updateModel(json: json["data"])
            dataModel.source = souceType
            sectionNum = 11
            self.table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

}


extension OrderDetailController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        if section == 1 {
            if dataModel.cancelReason == "" {
                return 0
            }
        }
        
        
        if section == 2 {
            if dataModel.perName == "" {
                return 0
            }
        }
        
        if section == 3 {
            if dataModel.address == "" {
                return 0
            }
        }
        
        if section == 5 {
            if dataModel.remarks == "" {
                return 0
            }
        }
        
        if section == 7 {
            return dataModel.dishArr.count
        }
        
        if section == 8 {
            if dataModel.giftList.count == 0 {
                return 0
            } else {
                return dataModel.giftList.count + 1
            }
        }
        if section == 9 {
            if dataModel.fullGiftDish.nameStr == "" {
                return 0
            } else {
                return 2
            }
        }
        

        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        if indexPath.section == 1 {
            return 65
        }
    
        if indexPath.section == 2 {
            return 35
        }
        if indexPath.section == 3 {
            return dataModel.address_H
        }
        if indexPath.section == 4 {
            return 30
        }
        if indexPath.section == 5 {
            return dataModel.remark_H
        }
        if indexPath.section == 6 {
            return 30
        }
        
        if indexPath.section == 7 {
            return dataModel.dishArr[indexPath.row].showCell_H
        }
        
        if indexPath.section == 8 {
            if indexPath.row == 0 {
                return 30
            } else {
                return 75
            }
            
        }
        
        if indexPath.section == 9 {
            
            if indexPath.row == 0 {
                return 30
            } else {
                return 75
            }
        }
        
        if indexPath.section == 10 {
            return dataModel.detailMoney_H
        }
    
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailStatusCell") as! DetailStatusCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CancelReasonCell") as! CancelReasonCell
            cell.setCellData(reason: dataModel.cancelReason)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailUserInfoCell") as! DetailUserInfoCell
            cell.setCellData(name: dataModel.perName, phone: dataModel.perPhone)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAddressCell") as! DetailAddressCell
            cell.setCellData(address: dataModel.address)
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMessageCell") as! DetailMessageCell
            var way: String = ""
            if dataModel.paymentMethod == "1" {
                way = "Cash"
            } else if dataModel.paymentMethod == "2" {
                way = "Card"
            } else if dataModel.paymentMethod == "3" {
                way = "Pos"
            } else if dataModel.paymentMethod == "4" {
                way = "Cash&Pos"
            } else if dataModel.paymentMethod == "5" {
                way = "WX"
            } else if dataModel.paymentMethod == "6" {
                way = "Wallet Spent"
            } else {
                way = "No choice yet"
            }
            
            cell.setCellData(titStr: "Payment method", msg: way)
            return cell
        }
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMessageCell") as! DetailMessageCell
            cell.setCellData(titStr: "Remarks", msg: dataModel.remarks)
            return cell
        }

        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell") as! DetailTitleCell
            cell.titLab.text = "Dishes"
            return cell
        }
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesShowCell") as! DishesShowCell
            cell.setCellData(model: dataModel.dishArr[indexPath.row], isShow: false)
            return cell
        }
        
        if indexPath.section == 8 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell") as! DetailTitleCell
                cell.titLab.text = "Gift"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishesFreeCell") as! DishesFreeCell
                cell.setCellData(model: dataModel.giftList[indexPath.row - 1])
                return cell
            }
        }

        if indexPath.section == 9 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell") as! DetailTitleCell
                cell.titLab.text = "Free after the order amount is reached"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishesFreeCell") as! DishesFreeCell
                cell.setCellData(model: dataModel.fullGiftDish)
                return cell
            }
        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMoneyCell") as! DetailMoneyCell
            cell.setCellData(model: dataModel)
            return cell
        }
    
        let cell = UITableViewCell()
        return cell
    }

    
    
}

