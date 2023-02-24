//
//  OrderDetailController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/2.
//

import UIKit
import RxSwift

class OrderDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol  {

    private let bag = DisposeBag()
    
    var timer1: Timer?
    var timer2: Timer?
    
    var orderID: String = ""
    
    private var dataModel = OrderDetailModel()
    
    private let titStrArr: [String] = ["Name", "Phone", "Address", "Hope Time","Remarks", "Order Time", "Payment method", "Order number"]

    ///控制展开和收起
    private var isShowAll: Bool = false
    
    ///控制分区数量
    private var sectionNum: Int = 0
    
    ///是否是刚支付结束
    var isPayAfter: Bool = false

    
    private lazy var mainTable: UITableView = {
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
        
        tableView.register(OrderDetailStatusCell.self, forCellReuseIdentifier: "OrderDetailStatusCell")
        tableView.register(OrderDetailMapCell.self, forCellReuseIdentifier: "OrderDetailMapCell")
        tableView.register(TopCornersCell.self, forCellReuseIdentifier: "TopCornersCell")
        tableView.register(BottomCornersCell.self, forCellReuseIdentifier: "BottomCornersCell")
        tableView.register(OrderStoreInfoCell.self, forCellReuseIdentifier: "OrderStoreInfoCell")
        tableView.register(OrderGoodsCell.self, forCellReuseIdentifier: "OrderGoodsCell")
        tableView.register(OrderShowMoreCell.self, forCellReuseIdentifier: "OrderShowMoreCell")
        tableView.register(OrderDetailMoneyCell.self, forCellReuseIdentifier: "OrderDetailMoneyCell")
        tableView.register(DetailOneCell.self, forCellReuseIdentifier: "DetailOneCell")
        tableView.register(OrderReviewCell.self, forCellReuseIdentifier: "OrderReviewCell")
        tableView.register(OrderDetailMsgCell.self, forCellReuseIdentifier: "OrderDetailMsgCell")
        tableView.register(OrderYuYueMsgCell.self, forCellReuseIdentifier: "OrderYuYueMsgCell")

        tableView.register(DetailTwoCell.self, forCellReuseIdentifier: "DetailTwoCell")
        tableView.register(OrderRejectCell.self, forCellReuseIdentifier: "OrderRejectCell")
        tableView.register(OrderDetailButCell.self, forCellReuseIdentifier: "OrderDetailButCell")
        
        tableView.register(OrderTSImageCell.self, forCellReuseIdentifier: "OrderTSImageCell")
        tableView.register(OrderTSContentCell.self, forCellReuseIdentifier: "OrderTSContentCell")
        tableView.register(OrderTSDealCell.self, forCellReuseIdentifier: "OrderTSDealCell")
        tableView.register(OrderDetailLuckyDrawCell.self, forCellReuseIdentifier: "OrderDetailLuckyDrawCell")
        tableView.register(OrderCouponDishCell.self, forCellReuseIdentifier: "OrderCouponDishCell")
        
        return tableView
    }()
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
        addNotificationCenter()
        
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Order"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
        self.loadData_Net()
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(naviBar.snp.bottom)
        }
    }
    

    //MARK: - 网络请求
    func loadData_Net() {
        self.invalidateTimer()
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: orderID).subscribe(onNext: { (json) in
            
            self.dataModel.updateModel(json: json["data"])
            
            self.sectionNum = 29
            
            //获取配送员地理位置
            if self.dataModel.status == .delivery_ing {
                HTTPTOOl.getCurrentPSLocation(orderID: self.dataModel.orderID).subscribe(onNext: { (json1) in
                    HUD_MB.dissmiss(onView: self.view)
                    self.dataModel.deliveryLat = json1["data"]["lat"].stringValue
                    self.dataModel.deliveryLng = json1["data"]["lng"].stringValue
                    self.mainTable.reloadData()


                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                    
                    self.mainTable.reloadData()

                }).disposed(by: self.bag)
            } else {
                HUD_MB.dissmiss(onView: self.view)
                
                self.mainTable.reloadData()
            }
            
            self.startTimer()
            
            if self.isPayAfter && self.dataModel.prizeStatus {
                //弹出转盘
                let wheelVC = ContentController()
                wheelVC.orderID = self.orderID
                wheelVC.storeID = self.dataModel.storeInfo.storeID
                self.present(wheelVC, animated: true) {
                    self.isPayAfter = false
                }
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //刷新骑手位置
    private func refreshRiderLocationData() {
        HTTPTOOl.getCurrentPSLocation(orderID: self.dataModel.orderID).subscribe(onNext: { (json1) in
            self.dataModel.deliveryLat = json1["data"]["lat"].stringValue
            self.dataModel.deliveryLng = json1["data"]["lng"].stringValue
            self.mainTable.reloadSections([0], with: .none)
        }, onError: { (error) in  }).disposed(by: self.bag)
    }
    
    //刷新订单状态
    private func refreshOrderStatus() {
        HTTPTOOl.refreshOrderStatus(id: orderID).subscribe(onNext: { (json) in
            self.dataModel.type = json["data"]["deliveryType"].stringValue
            self.dataModel.status = PJCUtil.getOrderStatus(StatusString: json["data"]["statusId"].stringValue)
            self.dataModel.statusStr = json["data"]["statusName"].stringValue
            self.dataModel.startTime = json["data"]["hopeTimeResult"]["startTime"].stringValue
            self.dataModel.endTime = json["data"]["hopeTimeResult"]["endTime"].stringValue
            self.dataModel.timeOut = json["data"]["hopeTimeResult"]["timeOut"].stringValue == "1" ? true : false
            self.mainTable.reloadSections([2], with: .none)
        }).disposed(by: bag)
    }
    
    ///获取刷新的数据
    private func getRefreshData() {
        HTTPTOOl.getCurrentPSLocation(orderID: self.dataModel.orderID).subscribe(onNext: { (json1) in
            self.dataModel.deliveryLat = json1["data"]["lat"].stringValue
            self.dataModel.deliveryLng = json1["data"]["lng"].stringValue
            
            HTTPTOOl.getOrderDetail(orderID: self.orderID).subscribe(onNext: { (json) in
                self.dataModel.updateModel(json: json["data"])
                self.mainTable.reloadSections([0, 2], with: .none)
            }, onError: {_ in}).disposed(by: self.bag)
            
        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    

    ///取消订单
    private func cancelOrder_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderCancelAction(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    ///确认订单
    func confiromOrder_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderConfirmAction(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //再来一单
    func orderAgain_Net(orderID: String, storeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderAgain(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            //跳转到点餐页面
            let nextVC = StoreMenuOrderController()
            nextVC.storeID = storeID
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    //MARK: - 定时相关
    private func startTimer() {
        invalidateTimer()
        
        
        if dataModel.status == .delivery_ing {
            //获取骑手位置
            timer1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
                //获取刷新的数据
                print("timer1")
                self.refreshRiderLocationData()
            })
            
            RunLoop.current.add(timer1!, forMode: .common)
        }
        
        
        if dataModel.status != .user_cancel && dataModel.status != .shops_cancel && dataModel.status != .system_cancel && dataModel.status != .reject && dataModel.status != .finished {
            timer2 = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
                print("timer2")
                self.refreshOrderStatus()
                
            })
            RunLoop.current.add(timer2!, forMode: .common)
        }
    }
    
    

    
    private func invalidateTimer() {
        
        print("定时结束")
        if timer1 != nil {
            timer1!.invalidate()
            timer1 = nil
            print("invalidateTimer")
        }
        if timer2 != nil {
            timer2!.invalidate()
            timer2 = nil
            print("invalidateTimer")
        }

    }
    
    
    override func willDisappear() {
        invalidateTimer()
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


extension OrderDetailController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            if dataModel.status == .delivery_ing {
                return 1
            }
            return 0
        }

        if section == 1  {
            return 1
        }
        if section == 2 {
            return 1
        }
        if section == 3 {
            if dataModel.reserveMsg == "" {
                return 0
            }
            return 1
        }
        if section == 4 {
            return 1
        }
        if section == 5 {
            return 1
        }
        
        if section == 6 {
            
            if dataModel.prizeStatus {
                return 1
            }
            
            return 0
        }

        if section == 7  {
            return 2
        }
        
        if section == 8 {
            if dataModel.dishArr.count > 2 {
                if isShowAll {
                    return dataModel.dishArr.count
                } else {
                    return 2
                }
            } else {
                return dataModel.dishArr.count
            }
        }
        
        if section == 9 {
            
            return 1
        }
        
        if section == 10 {
            if dataModel.couponDish.dishName == "" {
                return 0
            } else {
                return 1
            }
        }

        if section == 11 {
            return 1
        }
        
        if section == 12 {
            return 1
        }
        
        if section == 21 {
            return 1
        }
        
        if section == 22 {
            if dataModel.refuseReason == "" && dataModel.cancelReason == "" {
                return 0
            }
            return 1
        }
    
        if section == 23 {
            if dataModel.pjStatus == "1" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 24 {
            
            if dataModel.tsReason != "" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 25 {
            
            if dataModel.tsReason != "" {
                return 1
            } else {
                return 0
            }
    
        }
        
        if section == 26 {
            
            if dataModel.tsReason != "" {
                return 1
            } else {
                return 0
            }
        }
           
        if section == 27 {
            if dataModel.tsStauts == "1" || dataModel.tsStauts == "2" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 28 {
            if dataModel.tsReason != "" {
                return 1
            } else {
                return 0
            }
        }
        
        let msg = dataModel.msgArr[section - 13]
        if msg == "" {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 400
        }
        
        if indexPath.section == 1 {
            return 30
        }
        
        if indexPath.section == 2 {
            if dataModel.startTime == "" {
                return 125
            } else {
                return 160
            }
        }
        
        if indexPath.section == 3 {
            //预定信息
            let h = dataModel.reserveMsg.getTextHeigh(SFONT(10), S_W - 80)
            return h + 20

        }
        
        if indexPath.section == 4 {
            return 70
        }
        
        if indexPath.section == 5 {
            return 20
        }
        
        if indexPath.section == 6 {
            return SET_H(64, 327) + 15
        }
                
        if indexPath.section == 7 {
        
            if indexPath.row == 0 {
                return 30
            }
            if indexPath.row == 1 {
                return 40
            }
            
            //return 55
        }
        if indexPath.section == 8 {
            
            let model = dataModel.dishArr[indexPath.row]
            return model.dish_H
        }
        if indexPath.section == 9 {
            if dataModel.dishArr.count <= 2 {
                return 20
            } else {
                return 50
            }
        }
        
        if indexPath.section == 10 {
            return 140
        }
        
        
        if indexPath.section == 11 {
            return dataModel.detailMoney_H
        }
        
        if indexPath.section == 12 {
            return 50
        }
        
        if indexPath.section == 15 {
            let h = dataModel.recipientAddress.getTextHeigh(SFONT(14), S_W - 160) + 30
            return h
        }
        
        if indexPath.section == 17 {
            let h = dataModel.remark.getTextHeigh(SFONT(14), S_W - 160) + 30
            return h
        }
    
        if indexPath.section == 21 {
            return 30
        }
        
        if indexPath.section == 22 {
            return 140
        }
        
        if indexPath.section == 23 {
                        
            if dataModel.pjReplyContent == "" {
                return  20 + 50 + 20  + 80 + dataModel.evaluateContent.getTextHeigh(BFONT(15), S_W - 40)
            } else {
                return  20 + 50 + 20  + 80 + dataModel.evaluateContent.getTextHeigh(BFONT(15), S_W - 40) + dataModel.pjReplyContent.getTextHeigh(SFONT(14), S_W - 60) + 30
            }
        }
        
        if indexPath.section == 24 {
            
            return 50
            
        }
    
        if indexPath.section == 25 {
            
            let W = (S_W - 80) / 5
            
            if dataModel.tsImgArr.count > 5 {
                return W * 2 + 30
            } else {
                return W + 20
            }
            
        }
        
        if indexPath.section == 26 {
            
            var str = ""
            
            if dataModel.tsContent == "" {
                str = dataModel.tsReason
            } else {
                str = dataModel.tsReason + "\n" + dataModel.tsContent
            }
            
            return str.getTextHeigh(SFONT(14), S_W - 40) + 20

        }
        
        if indexPath.section == 27 {
            
            return dataModel.tsDealContent.getTextHeigh(SFONT(14), S_W - 60) + 65
            
        }
        
        if indexPath.section == 28 {
            return 30
        }
        
    
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailMapCell") as! OrderDetailMapCell
            cell.setCellData(model: dataModel)
            
            cell.clickBlock = { [unowned self] (_) in
                self.getRefreshData()
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCornersCell") as! TopCornersCell
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailStatusCell") as! OrderDetailStatusCell
            cell.setCellData(model: dataModel)
            return cell
        }
        if indexPath.section == 3 {
            //预定信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderYuYueMsgCell") as! OrderYuYueMsgCell
            cell.msgLab.text = dataModel.reserveMsg
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailButCell") as! OrderDetailButCell
            cell.setCellData(model: dataModel)
            cell.clickBlock = { [unowned self] (str) in
                
                let type = str as! String
                print(type)
                
                if type == "Contact shop" {
                    //联系店铺
                    PJCUtil.callPhone(phone: self.dataModel.storeInfo.phone)
                }
                
                if type == "Help" {
                    //帮助
                    let nextVC = FAQController()
                    
                    if self.dataModel.status == .finished && self.dataModel.tsStauts == "1" && self.dataModel.pjStatus == "1" {
                        nextVC.isHaveAfter = true
                    } else {
                        nextVC.isHaveAfter = false
                    }
                    
                    nextVC.orderID = self.dataModel.orderID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if type == "Cancel" {
                    //取消
                    self.showSystemChooseAlert("Alert", "Are you sure you want to cancel the order？", "YES", "NO") {
                        self.cancelOrder_Net(orderID: self.orderID)
                    } _: {}
                }
                
                if type == "Confirm" {
                    //确认
                    self.showSystemChooseAlert("Alert", "Confirm receipt of goods?？", "YES", "NO") {
                        self.confiromOrder_Net(orderID: self.orderID)
                    } _: {}

                }
                
                if type == "To pay for" {
                    //支付
                    let nextVC = OderListConfirmController()
                    nextVC.orderID = self.orderID
                    nextVC.isDetailVC = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                
                if type == "Order it again" {
                    //再来一单
                    self.orderAgain_Net(orderID: self.orderID, storeID: dataModel.storeInfo.storeID)
                }
                
                if type == "Review" {
                    //评价
                    let nextVC = EvaluateController()
                    nextVC.orderID = self.dataModel.orderID
                    nextVC.islist = false
                    nextVC.orderType = self.dataModel.type
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if type == "After sales" {
                    //售后
                    let nextVC = AfterSalesController()
                    nextVC.orderID = self.dataModel.orderID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }
                                    
            }
            
            return cell

        }
        
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCornersCell") as! BottomCornersCell
            return cell
        }
        
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailLuckyDrawCell") as! OrderDetailLuckyDrawCell
            return cell
        }
        

        if indexPath.section == 7 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopCornersCell") as! TopCornersCell
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStoreInfoCell") as! OrderStoreInfoCell
                cell.setCell2Data(model: dataModel.storeInfo)
                return cell
            }
        }
        
        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderGoodsCell") as! OrderGoodsCell
            cell.setOrderCellData(model: dataModel.dishArr[indexPath.row])
            return cell
        }
        
        if indexPath.section == 9 {
            
            if dataModel.dishArr.count <= 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCornersCell") as! BottomCornersCell
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderShowMoreCell") as! OrderShowMoreCell
                cell.setCellData(state: self.isShowAll)
                cell.clickBlock = { [unowned self] (bool) in
                    self.isShowAll = bool as! Bool
                    self.mainTable.reloadSections([8], with: .none)
                }
                return cell

            }
        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponDishCell") as! OrderCouponDishCell
            cell.setCellData(model: dataModel.couponDish)
            return cell
        }
        
        
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailMoneyCell") as! OrderDetailMoneyCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        
        
        if indexPath.section == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOneCell") as! DetailOneCell
            cell.titLab.text = "Details"
            return cell
        }
        
        
        if indexPath.section == 21 || indexPath.section == 28 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTwoCell") as! DetailTwoCell
            return cell
        }
        
        if indexPath.section == 22 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRejectCell") as! OrderRejectCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 23 {
                        
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewCell") as! OrderReviewCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        
        if indexPath.section == 24 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOneCell") as! DetailOneCell
            cell.titLab.text = "Complain"
            return cell
        }
        
        if indexPath.section == 25 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTSImageCell") as! OrderTSImageCell
            cell.setCellData(model: dataModel)
            return cell
            
        }
        
        if indexPath.section == 26 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTSContentCell") as! OrderTSContentCell
            cell.setCellData(model: dataModel)
            return cell
            
        }
        
        if indexPath.section == 27 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTSDealCell") as! OrderTSDealCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailMsgCell") as! OrderDetailMsgCell
        cell.setCellData(titStr: titStrArr[indexPath.section - 13], msgStr: dataModel.msgArr[indexPath.section - 13])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            //抽奖
            let wheelVC = ContentController()
            wheelVC.orderID = self.orderID
            wheelVC.storeID = self.dataModel.storeInfo.storeID
            self.present(wheelVC, animated: true)
        }
    }
}
