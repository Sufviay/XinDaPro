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
        tableView.register(OrderHeaderTypeCell.self, forCellReuseIdentifier: "OrderHeaderTypeCell")
        tableView.register(OrderNumberInfoCell.self, forCellReuseIdentifier: "OrderNumberInfoCell")
        tableView.register(OrderAddressCell.self, forCellReuseIdentifier: "OrderAddressCell")
        tableView.register(OrderGoodsCell.self, forCellReuseIdentifier: "OrderGoodsCell")
        tableView.register(OrderMoneyCell.self, forCellReuseIdentifier: "OrderMoneyCell")
        tableView.register(OrderRefuseCell.self, forCellReuseIdentifier: "OrderRefuseCell")
        tableView.register(OrderEvaluateCell.self, forCellReuseIdentifier: "OrderEvaluateCell")
        tableView.register(OrderDealButCell.self, forCellReuseIdentifier: "OrderDealButCell")
        tableView.register(OrderComplaintCell.self, forCellReuseIdentifier: "OrderComplaintCell")
        tableView.register(OrderBottomButCell.self, forCellReuseIdentifier: "OrderBottomButCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        //tableView.layer.cornerRadius = 10
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
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.sectionNum = 12
            self.dataModel.updateModel2(json: json["data"])
            self.mainTabel.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum //12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if self.dataModel.type == "1" {
                return 0
            }
            if self.dataModel.type == "2" {
                return 1
            }
            
        }
        
        if section == 2 {
            
            if self.dataModel.address == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 3 {
            if self.dataModel.remarks == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 4 {
            return dataModel.dishArr.count
        }
        
        if section == 6 {
            //拒接
            if dataModel.status == .reject {
                return 1
            } else {
                return 0
            }
        }
        if section == 7 {
            //评价
            if dataModel.pjStatus == "1" {
                return 0
            } else {
                return 1
            }
        }
        if section == 8 {
            //投诉按钮
            return 0
        }
        if section == 9 {
            //投诉内容
            return 0

        }
        if section == 10 {
            //投诉处理
            if dataModel.status == .finished && dataModel.tsStatus != "1" && dataModel.tsStatus != "2" {
                return 1
            } else {
                return 0
            }
        }
        if section == 11 {
            //底部按钮  1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
//            if dataModel.status == .pay_success || dataModel.status == .takeOrder || dataModel.status == .cooked || dataModel.status == .delivery_ing {
//                return 1
//            }
            if dataModel.status == .finished && dataModel.tsStatus == "2" {
                return 1
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return dataModel.h0
        }
        if indexPath.section == 1 {
            return dataModel.h1
        }
        if indexPath.section == 2 {
            
//            let str = "太原街 陕西路 绍兴街18号 900444室 就在这里的啊"
//            let h = str.getTextHeigh(SFONT(14), S_W - 60)
//            return h + 40
            return dataModel.h2
        }
        
        if indexPath.section == 3 {
            return dataModel.h3
        }
        
        if indexPath.section == 4 {
            return 90
        }
        if indexPath.section == 5 {
            return dataModel.h5
        }
        if indexPath.section == 6 {
            return dataModel.h6
        }
        if indexPath.section == 7 {
//            let str = "还可以吧挺好吃的，还可以吧挺好吃的，还可以吧挺好吃的，还可以吧挺好吃的，还可以吧挺好吃的"
//            let h = str.getTextHeigh(SFONT(13), S_W - 160)
//            return h + 55
            return dataModel.h7
        }
        
        if indexPath.section == 8 {
            
            return dataModel.h8
        }
        
        if indexPath.section == 9 {
//            let str = "看起来不太好的样子"
//            let h = str.getTextHeigh(SFONT(13), S_W - 180)
//            return h + 20
            return dataModel.h9
        }
        
        if indexPath.section == 10 {
            
//            let str = "看起来不太好的样子"
//            let h = str.getTextHeigh(SFONT(13), S_W - 180)
//            return h + 20
            return dataModel.h10
        }
        
        if indexPath.section == 11 {
            return dataModel.h11
        }

        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHeaderTypeCell") as! OrderHeaderTypeCell
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNumberInfoCell") as! OrderNumberInfoCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAddressCell") as! OrderAddressCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRemarkCell") as! OrderRemarkCell
            cell.msgLab.text = dataModel.remarks
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderGoodsCell") as! OrderGoodsCell
            cell.setCellData(model: dataModel.dishArr[indexPath.row])
            return cell
        }
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderMoneyCell") as! OrderMoneyCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRefuseCell") as! OrderRefuseCell
            cell.msgLab.text = dataModel.refuseReason
            return cell
        }
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderEvaluateCell") as! OrderEvaluateCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDealButCell") as! OrderDealButCell
//            cell.clickBlock = { [unowned self] _ in
//                self.clickBlock?(["ts", dataModel.id])
//            }
            return cell
        }
        
        if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderComplaintCell") as! OrderComplaintCell
            cell.tlab.text = "Complaint content"
            cell.msgLab.text = dataModel.tsContent
            return cell
        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderComplaintCell") as! OrderComplaintCell
            cell.tlab.text = "Complaint result"
            cell.msgLab.text = dataModel.tsDealDes
            return cell
        }
        
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBottomButCell") as! OrderBottomButCell
            cell.setCellData(type: dataModel.type, model: dataModel)
        
            cell.clickBlock = { [unowned self] (type) in
                self.dealClickBlock(type: type as! String)
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    private func dealClickBlock(type: String) {
        
        if type == "jujie" {
            ///拒接
            let nextVC = JuJieReasonController()
            nextVC.orderID = orderID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if type == "jiedan" {
            ///接单
            self.jiedanAction_Net(orderID: orderID)
        }
        
        if type == "chucan" {
            ///出餐
            self.chuCanAciton_Net(orderID: orderID)
        }
        
        if type == "peisong" {
            ///开始配送
            self.kaiShiPeiSongAction_Net(orderID: orderID)
        }

        if type == "qucan" {
            //取餐
            self.shouHuoAction_Net(orderID: orderID)
        }
        
        if type == "songda" {
            ///送达
            
            self.shouHuoAction_Net(orderID: orderID)
        }
        
        if type == "ts" {
            ///投诉处理
            let nextVC = DealComplaintController()
            nextVC.orderID = orderID
            nextVC.tsName = dataModel.perName
            nextVC.tsPhone = dataModel.perPhone
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    
    
    ///接单
    private func jiedanAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.jiedanAction(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    ///出餐
    func chuCanAciton_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.chuCanAciton(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //开始配送
    func kaiShiPeiSongAction_Net(orderID: String)  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.kaiShiPeiSongAction(orderID: orderID).subscribe(onNext: { (json) in
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
            HTTPTOOl.shouHuoAction(orderID: orderID).subscribe(onNext: { (json) in
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
