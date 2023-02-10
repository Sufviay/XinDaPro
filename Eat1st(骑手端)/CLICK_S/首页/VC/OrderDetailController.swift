//
//  OrderDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/10.
//

import UIKit
import RxSwift

class OrderDetailController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    var orderID: String = ""
    
    private var dataModel = OrderModel()
    
    private var sectionNum: Int = 0
    
    var haveBut: Bool = false
    
    private lazy var mainTabel: UITableView = {
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
        tableView.register(OrderNumberInfoCell.self, forCellReuseIdentifier: "OrderNumberInfoCell")
        tableView.register(OrderAddressCell.self, forCellReuseIdentifier: "OrderAddressCell")
        tableView.register(OrderGoodsCell.self, forCellReuseIdentifier: "OrderGoodsCell")
        tableView.register(OrderMoneyCell.self, forCellReuseIdentifier: "OrderMoneyCell")
        tableView.register(OrderBottomButCell.self, forCellReuseIdentifier: "OrderBottomButCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        return tableView
    }()
    
    
    
    override func setViews() {
        
        setUpUI()
        loadData_Net()
        addNotificationCenter()
        
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Your orders"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }

    private func setUpUI() {
        
        self.view.addSubview(mainTabel)
        mainTabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        if section == 1 {
            if self.dataModel.address == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 2 {
            if self.dataModel.remarks == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 3 {
            return dataModel.dishArr.count
        }
        

        if section == 5 {
            
            if dataModel.status == .delivery_ing || dataModel.status == .paiDan {
                if haveBut {
                    return 1
                } else {
                    return 0
                }
            } else {
                return 0
            }
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        
        if indexPath.section == 1 {
            return dataModel.address_H
        }
        if indexPath.section == 2 {
            return dataModel.remark_H
        }
        
        if indexPath.section == 3 {
            return dataModel.dishArr[indexPath.row].dish_H
        }
        
        if indexPath.section == 4 {
            return 240
        }
        if indexPath.section == 5 {
            return 60
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNumberInfoCell") as! OrderNumberInfoCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAddressCell") as! OrderAddressCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRemarkCell") as! OrderRemarkCell
            cell.msgLab.text = dataModel.remarks
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderGoodsCell") as! OrderGoodsCell
            cell.setCellData(model: dataModel.dishArr[indexPath.row])
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderMoneyCell") as! OrderMoneyCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBottomButCell") as! OrderBottomButCell
            cell.setCellData(model: dataModel)
        
            cell.clickBlock = { [unowned self] (type) in
                self.dealClickBlock(type: type as! String)
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    private func dealClickBlock(type: String) {
        
        if type == "start" {
            ///开始送单
            self.startAction_Net(orderID: orderID)
            
        }
        if type == "unsuccessful" {
            ///无法送单
             let nextVC = JuJieReasonController()
            nextVC.orderID = orderID
            self.navigationController?.pushViewController(nextVC, animated: true)

        }
        
        if type == "complete" {
            ///送达
            self.shouHuoAction_Net(orderID: orderID)
        }
    }
    
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.sectionNum = 6
            self.dataModel.updateModel(json: json["data"])
            self.mainTabel.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    
    
    ///开始送单
    private func startAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderStart(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
        
    
    ///确认收货
    func shouHuoAction_Net(orderID: String) {
        
        self.showSystemChooseAlert("Alert", "Are you sure you want to confirm the order?", "YES", "NO") {
            HUD_MB.loading("", onView: self.view)
            HTTPTOOl.riderDoReceiveOrder(orderID: orderID).subscribe(onNext: { (json) in
                HUD_MB.showSuccess("", onView: self.view)
                self.loadData_Net()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } _: {}
    }

    
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(orderRefresh), name: NSNotification.Name(rawValue: "orderList"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("orderList"), object: nil)
    }
    
    @objc func orderRefresh() {
        loadData_Net()
    }
}


