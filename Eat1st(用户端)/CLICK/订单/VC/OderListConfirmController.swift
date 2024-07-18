//
//  OderListConfirmController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/24.
//

import UIKit
import RxSwift
import Stripe
import SwiftyJSON


class OderListConfirmController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isDetailVC: Bool = false
    
    ///支付
    private var paymentSheet: PaymentSheet?
    private var sectionNum: Int = 0

    private let bag = DisposeBag()

    var orderID: String = ""

    private var dataModel = OrderDetailModel()
    
    ///控制展开和收起
    private var isShowAll: Bool = false
    
    ///1 现金  2 卡
    private var payWay: String = ""

    ///预计送达时间
    private var minTime: String = ""
    private var maxTime: String = ""

    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("head_img_1")
        return img
    }()

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.text = "Your order"
        return lab
    }()

    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()

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

        tableView.register(OrderTagDineInCell.self, forCellReuseIdentifier: "OrderTagDineInCell")
        tableView.register(OrderSelectTagCell.self, forCellReuseIdentifier: "OrderSelectTagCell")
        tableView.register(OrderStoreInfoCell.self, forCellReuseIdentifier: "OrderStoreInfoCell")
        tableView.register(OrderGoodsCell.self, forCellReuseIdentifier: "OrderGoodsCell")
        tableView.register(OrderShowMoreCell.self, forCellReuseIdentifier: "OrderShowMoreCell")
        tableView.register(OrderRoundedCornersCell.self, forCellReuseIdentifier: "OrderRoundedCornersCell")
        tableView.register(OrderCouponsCell.self, forCellReuseIdentifier: "OrderCouponsCell")
        tableView.register(OrderpayMoneyCell.self, forCellReuseIdentifier: "OrderpayMoneyCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        //tableView.register(OrderTotalMoneyCell.self, forCellReuseIdentifier: "OrderTotalMoneyCell")
        tableView.register(ConfirmMoneyCell.self, forCellReuseIdentifier: "ConfirmMoneyCell")
        tableView.register(OrderPayButCell.self, forCellReuseIdentifier: "OrderPayButCell")
        tableView.register(OrderTagCollectionCell.self, forCellReuseIdentifier: "OrderTagCollectionCell")
        tableView.register(OrderTagDeliveryCell.self, forCellReuseIdentifier: "OrderTagDeliveryCell")
        tableView.register(OrderChoosePayWayCell.self, forCellReuseIdentifier: "OrderChoosePayWayCell")
        tableView.register(OrderListInputCell.self, forCellReuseIdentifier: "OrderListInputCell")
        tableView.register(OrderInputZQCell.self, forCellReuseIdentifier: "OrderInputZQCell")
        tableView.register(OrderCouponDishCell.self, forCellReuseIdentifier: "OrderCouponDishCell")
        return tableView
    }()
    
    
    ///支付提示框
    lazy var payAlert: PayAlert = {
        let alert = PayAlert()
        alert.clickPayBlock = { [unowned self] (payType) in
            //支付
            self.payWay = payType as! String
            self.orderPay_Net()
        }
        return alert
    }()
    
//    ///钱包
//    private let walletView: WalletView = {
//        let view = WalletView()
//        return view
//    }()

    override func setViews() {
        self.naviBar.isHidden = true

        view.backgroundColor = HCOLOR("#F7F7F7")

        view.addSubview(headImg)

        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(R_H(380))
        }

        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }


        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBut)
        }
        setUpUI()
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)

        loadData_Net()
    }
    
    override func setNavi() {
        //getWalletMoney_Net()
    }

    private func setUpUI() {

        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }



    //MARK: - 网络请求
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: orderID).subscribe(onNext: { [unowned self] (json) in

            HUD_MB.dissmiss(onView: self.view)
            self.dataModel.updateModel(json: json["data"], true)
            self.sectionNum = 10
            self.mainTable.reloadData()
            if dataModel.type != "3" {
                self.getYSDTime_Net()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    private func getYSDTime_Net() {
        
        HTTPTOOl.getCalOrderTime(type: dataModel.type, storeID: dataModel.storeInfo.storeID, time: dataModel.hopeTime).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.minTime = json["data"]["startTime"].stringValue
            self.maxTime = json["data"]["endTime"].stringValue
            self.mainTable.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }


    
    
    private func showPayAlert(json: JSON) {
        ///弹出支付弹窗
        
        payAlert.paymentSupport = json["data"]["payType"].stringValue //dataModel.storePayType
        payAlert.payPrice = json["data"]["payAmount"].doubleValue //dataModel.payPrice
        payAlert.subtotal = json["data"]["dishesPrice"].doubleValue  //dataModel.actualFee
        payAlert.deliveryPrice = json["data"]["deliveryPrice"].doubleValue //dataModel.deliveryFee
        payAlert.servicePrice = json["data"]["servicePrice"].doubleValue // dataModel.serviceFee
        payAlert.discountScale = json["data"]["discountScale"].stringValue //dataModel.discountScale
        payAlert.discountAmount = json["data"]["discountAmount"].doubleValue  //dataModel.discountAmount
        payAlert.dishesDiscountAmount = json["data"]["dishesDiscountAmount"].doubleValue //dataModel.dishesDiscountAmount
        payAlert.couponAmount = json["data"]["couponAmount"].doubleValue //dataModel.couponAmount
        payAlert.rechargePrice = json["data"]["rechargePrice"].doubleValue
        payAlert.buyType = dataModel.type
        self.payAlert.alertReloadData()
        self.payAlert.appearAction()
    }

    
    //MARK: - 获取订单金额明细
    private func loadOrderAmountDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getWalletAndOrder(orderID: orderID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            showPayAlert(json: json)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    

    private func orderPay_Net() {
        
        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        HTTPTOOl.orderPay(orderID: self.orderID, payType: payWay).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            self.payAlert.disAppearAction()

            ///1需要stripe支付，2不需要
            let stripeType = json["data"]["stripeType"].stringValue
            
            if stripeType == "1" {
                
                STPAPIClient.shared.publishableKey = json["data"]["publicKey"].stringValue

                let customerId = json["data"]["customerId"].stringValue
                let customerEphemeralKeySecret = json["data"]["ephemeralKey"].stringValue
                let paymentIntentClientSecret = json["data"]["clientSecret"].stringValue

                var config = PaymentSheet.Configuration()
                //config.merchantDisplayName = "Test"

                config.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)

                DispatchQueue.main.async {

                    self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: config)
                    self.paymentSheet?.present(from: self, completion: { [unowned self] paymentResult in
                        switch paymentResult {
                        case .completed:

                            //跳转到订单详情页面
                            self.jumpDetailVC(isCanWheel: true)
                            
                          print("Your order is confirmed!")
                        case .canceled:
                            self.cancelPay_Net()
                            HUD_MB.showWarnig("Canceled!", onView: PJCUtil.getWindowView())
                          print("Canceled!")
                        case .failed(let error):
                            HUD_MB.showWarnig("Payment failed: \n\(error.localizedDescription)", onView: PJCUtil.getWindowView())
                          print("Payment failed: \n\(error.localizedDescription)")
                        }
                    })
                }
            }

            if stripeType == "2" {
                //跳转到订单详情页面
                self.jumpDetailVC(isCanWheel: false)
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            self.payAlert.disAppearAction()
        }).disposed(by: self.bag)
    }
    
    
    private func jumpDetailVC(isCanWheel: Bool) {
        if self.isDetailVC {
            
            //订单详情中点击继续支付
            
            let vcs: [UIViewController] = self.navigationController!.viewControllers
            let detailVC: OrderDetailController = vcs[vcs.count - 2] as! OrderDetailController
            detailVC.isPayAfter = isCanWheel
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            //订单列表中点击继续支付
            
            var vcs: [UIViewController] = self.navigationController!.viewControllers
            vcs.removeLast()
            let orderDetailVC = OrderDetailController()
            orderDetailVC.orderID = self.orderID
            orderDetailVC.isPayAfter = isCanWheel
//            self.navigationController?.pushViewController(orderDetailVC, animated: true)
            vcs += [orderDetailVC]
            self.navigationController?.setViewControllers(vcs, animated: true)
        }
    }
    
        
    ///取消支付
    func cancelPay_Net() {
        HTTPTOOl.payCancel(id: self.orderID).subscribe(onNext: { (josn) in
        }).disposed(by: self.bag)
    }

    
    deinit {
        print("订单确认页面销毁")
    }
    
    
    

}



extension OderListConfirmController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 2 {
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
        
        if section == 3 {
            return 1
        }
        
        if section == 4 {
            if dataModel.couponDish.dishName == "" {
                return 0
            } else {
                return 1
            }
        }
        
        if section == 5 {
            if dataModel.fullGiftDish.dishName == "" {
                return 0
            } else {
                return 1
            }
            
        }
        
        
        if section == 6 {
            if dataModel.type == "3" {
                return 0
            } else {
                return 1
            }
        }
        
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 65
        }
        if indexPath.section == 1 {
            return 55
        }
        if indexPath.section == 2 {
            return dataModel.dishArr[indexPath.row].dish_H
        }
        if indexPath.section == 3 {
            
            if dataModel.dishArr.count <= 2 {
                return 20
            } else {
                return 60
            }
        }
        
        if indexPath.section == 4 {
            return 140
        }
        if indexPath.section == 5 {
            return 140
        }
        
        if indexPath.section == 6 {
            
            let h = dataModel.reserveMsg.getTextHeigh(SFONT(10), S_W - 60) > 11 ? dataModel.reserveMsg.getTextHeigh(SFONT(10), S_W - 60) : 11

            if dataModel.type == "1" {
                //配送
                return 270 + h
            }
            if dataModel.type == "2" {
                return 190 + h
            }
        }
        
        if indexPath.section == 7 {
            return 155
        }
        if indexPath.section == 8 {

            return dataModel.confirmMoney_H
            
        }

        return 85
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            if dataModel.type == "3" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTagDineInCell") as! OrderTagDineInCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSelectTagCell") as! OrderSelectTagCell
                cell.setCellData(type: dataModel.type, isCanEdite: false)
                return cell
            }
            
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStoreInfoCell") as! OrderStoreInfoCell
            cell.setCell2Data(model: dataModel.storeInfo)
            return cell
        }

        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderGoodsCell") as! OrderGoodsCell
            cell.setOrderCellData(model: dataModel.dishArr[indexPath.row])
            return cell
        }

        if indexPath.section == 3 {

            if dataModel.dishArr.count <= 2  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRoundedCornersCell") as! OrderRoundedCornersCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderShowMoreCell") as! OrderShowMoreCell
                cell.setCellData(state: self.isShowAll)
                cell.clickBlock = { [unowned self] (bool) in
                    self.isShowAll = bool as! Bool
                    mainTable.reloadData()
                }
                return cell
            }
        }

        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponDishCell") as! OrderCouponDishCell
            cell.setCellData(titStr: "Gift", model: dataModel.couponDish)
            return cell
        }

        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponDishCell") as! OrderCouponDishCell
            cell.setCellData(titStr: "Free after the order amount is reached", model: dataModel.fullGiftDish)
            return cell
        }
        

        if indexPath.section == 6 {

            if dataModel.type == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListInputCell") as! OrderListInputCell
                

                let addressStr = "\(dataModel.postCode) \(dataModel.recipientAddress)"
                cell.setCellData(name: dataModel.recipient, phone: dataModel.recipientPhone, address: addressStr, doorNum: dataModel.houseNo, time: dataModel.hopeTime, minTime: minTime, maxTime: maxTime, ydMsg: dataModel.reserveMsg)
                return cell
            }
            if dataModel.type == "2" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInputZQCell") as! OrderInputZQCell

                cell.setCellData1(name: dataModel.recipient, phone: dataModel.recipientPhone, time: dataModel.hopeTime, isCanEidte: false, minTime: minTime, maxTime: maxTime, ydMsg: dataModel.reserveMsg)
                return cell
            }
        }
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRemarkCell") as! OrderRemarkCell
            cell.setCellData(cStr: dataModel.remark, isCanEdite: false)
            return cell
        }
        if indexPath.section == 8 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmMoneyCell") as! ConfirmMoneyCell
            cell.setDetailCellData(model: dataModel)
            return cell
        }

        if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayButCell") as! OrderPayButCell

            cell.setCellData(titStr: "Confirm An Order")
            cell.clickPayBlock = { [unowned self] (_) in
                loadOrderAmountDetail_Net()
            }
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
}

