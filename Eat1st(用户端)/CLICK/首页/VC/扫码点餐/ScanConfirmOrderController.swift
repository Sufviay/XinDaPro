//
//  ScanConfirmOrderController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/6/14.
//

import UIKit
import RxSwift
import Stripe

class ScanConfirmOrderController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol, SelectCouponDelegate {

    private let bag = DisposeBag()
    
    var deskID: String = "" {
        didSet {
            self.submitModel.deskId = deskID
        }
    }
    
    ///店铺ID
    var storeID: String = "" {
        didSet {
            self.submitModel.storeId = storeID
        }
    }
    
    ///支付的订单ID
    private var payOrderID: String = ""
    
    ///是否可编辑
    private var isCanEidte: Bool = true
    
    ///支付
    private var paymentSheet: PaymentSheet?
    
    ///构建页面的购物车数据
    private var cartModel = ConfirmOrderCartModel()
        

    private var sectionNum: Int = 0
        
    ///1 现金  2 卡
    private var payWay: String = "" {
        didSet {
            self.submitModel.paymentMethod = payWay
        }
    }
    
    
    ///提交model
    private var submitModel = CreateOrderModel()


    ///控制菜品展开和收起
    private var isShowAll: Bool = true
    
    ///预计送达时间
    private var minTime: String = ""
    private var maxTime: String = ""
    
    ///选择的优惠券
    private var selectCoupon = CouponModel()
    
    ///满赠菜品的ID
    private var giftDishesId: String = "" {
        didSet {
            submitModel.giftDishesId = giftDishesId
        }
    }
        
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
        //tableView.bounces = false

        tableView.register(OrderTagDineInCell.self, forCellReuseIdentifier: "OrderTagDineInCell")
        tableView.register(OrderStoreInfoCell.self, forCellReuseIdentifier: "OrderStoreInfoCell")
        tableView.register(OrderConfirmGoodsCell.self, forCellReuseIdentifier: "OrderConfirmGoodsCell")
        tableView.register(OrderShowMoreCell.self, forCellReuseIdentifier: "OrderShowMoreCell")
        tableView.register(OrderRoundedCornersCell.self, forCellReuseIdentifier: "OrderRoundedCornersCell")
        tableView.register(OrderCouponsCell.self, forCellReuseIdentifier: "OrderCouponsCell")
        tableView.register(OrderpayMoneyCell.self, forCellReuseIdentifier: "OrderpayMoneyCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        
        tableView.register(ConfirmMoneyCell.self, forCellReuseIdentifier: "ConfirmMoneyCell")
        
        tableView.register(OrderPayButCell.self, forCellReuseIdentifier: "OrderPayButCell")
        tableView.register(OrderInputCell.self, forCellReuseIdentifier: "OrderInputCell")
        tableView.register(OrderInputZQCell.self, forCellReuseIdentifier: "OrderInputZQCell")
        
        tableView.register(OrderCouponDishCell.self, forCellReuseIdentifier: "OrderCouponDishCell")
        
        tableView.register(OrderFullGiftCell.self, forCellReuseIdentifier: "OrderFullGiftCell")
        tableView.register(OrderTitleCell.self, forCellReuseIdentifier: "OrderTitleCell")
        tableView.register(OrderCouponProgressCell.self, forCellReuseIdentifier: "OrderCouponProgressCell")

        return tableView
    }()
    
    
    
    ///支付提示框
    lazy var payAlert: PayAlert = {
        let alert = PayAlert()
        alert.clickPayBlock = { [unowned self] (payType) in
            //支付
            self.payWay = payType as! String
            self.createOrder_Net()
        }
        return alert
    }()
    
    
    ///选择优惠券提示框
    lazy var couponAlert: CouponAlertView = {
        let alert = CouponAlertView()
        alert.clickBlock = { [unowned self] (str) in
            if str == "yes" {
                //去选择优惠券
                goSelectCoupon()
            }
            if str == "no" {
                //忽略
                popUpPayAlert()
            }
        }
        return alert
    }()

    
    override func setViews() {
        self.naviBar.isHidden = true
        
        addNotificationCenter()
        
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
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        setUpUI()

        
        //加载页面首次请求
        loadData_Net()
    }
    
    
    override func setNavi() {

        
    }
    
    private func setUpUI() {
        
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
//        view.addSubview(walletView)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(walletRefresh), name: NSNotification.Name(rawValue: "wallet"), object: nil)
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name("wallet"), object: nil)
    }
    
    
    
    

    
    //MARK: - 选择优惠券
    func didSelectedCoupon(coupon: CouponModel) {
        self.selectCoupon = coupon
        self.submitModel.couponId = coupon.couponId
        self.submitModel.couponUserDishesId = coupon.selCouponUserDishesId
        //选择优惠券后 刷新数据
        loadData_Net()
    }

    
    
    //MARK: - 网络请求
    
    
    
    //MARK: - 请求可用的优惠券
    private func loadCouponStatus(price: String) {
        
        if price == "0" {
            cartModel.isHaveCanUseCoupon = false
            cartModel.isHaveCoupon = false
            mainTable.reloadData()
        } else {
            HTTPTOOl.getAvabliableCouponList(dishesPrice: price, storeID: storeID).subscribe(onNext: { [unowned self] (json) in
                
                if json["data"].arrayValue.count == 0 {
                    cartModel.isHaveCoupon = false
                } else {
                    cartModel.isHaveCoupon = true
                }
                
                
                for jsonData in json["data"].arrayValue {
                    if jsonData["status"].stringValue == "1" {
                        cartModel.isHaveCanUseCoupon = true
                        break
                    } else {
                        cartModel.isHaveCanUseCoupon = false
                    }
                }
                mainTable.reloadData()
            }).disposed(by: bag)
        }
    }
    
    

    //MARK: - 获取订单信息
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        ///cal
        HTTPTOOl.loadConfirmOrderDetail(storeID: storeID, buyWay: "3", lat: "", lng: "", couponID: selectCoupon.couponId, postCode: "", couponUserDishesId: selectCoupon.selCouponUserDishesId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
                        
            self.cartModel.updateModel(json: json["data"], type: "3")
            ///更新选择的赠送菜品
            giftDishesId = cartModel.updateGiftDishesID(selectGiftID: giftDishesId)

            self.sectionNum = 12
            self.mainTable.reloadData()
            
            self.loadCouponStatus(price: D_2_STR(self.cartModel.subFee - self.cartModel.dishesDiscountAmount))

        }, onError: { [unowned self] (error) in
            
            if error as! NetworkError  == .errorCode10  {
                /////优惠券无法使用 清除选中的优惠券
                self.selectCoupon = CouponModel()
                self.submitModel.couponId = ""
                self.submitModel.couponUserDishesId = ""
                HUD_MB.showWarnig(ErrorTool.errorMessage(error), onView: self.view)
            } else {
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }
            self.mainTable.reloadData()
        }).disposed(by: self.bag)
    }
    

    
    
    private func clickConfirmAction() {
        
        if cartModel.deliveryType == "5" {
            self.showSystemAlert("Tip", cartModel.deliveryMsg, "Sure")
            return
        }
        
        if cartModel.canChooseFullGift && giftDishesId == "" {
            HUD_MB.showWarnig("Please choose free dishes!", onView: self.view)
            return
        }
        
        if cartModel.isHaveCanUseCoupon && selectCoupon.couponId == "" {
            //是否有可用优惠券且有没有选择优惠券
            couponAlert.appearAction()
            return
        }
        
        
        ///弹出支付弹窗
        popUpPayAlert()

    }
    
    
    ///创建订单
    private func createOrder_Net() {

        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        
        if payOrderID != "" {
            self.orderPay_Net()
        } else {
            //创建订单
            self.submitModel.recipientPostcode = ""
            //self.submitModel.recipientAddress = ""
            self.submitModel.address = ""
            self.submitModel.doorNum = ""
            self.submitModel.recipientLat = ""
            self.submitModel.recipientLng = ""
            self.submitModel.type = "3"

            HTTPTOOl.createOrder(model: self.submitModel).subscribe(onNext: { [unowned self] (json) in
                ///刷新点餐页面
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pageRefresh"), object: nil)
                self.isCanEidte = false
                self.mainTable.reloadData()
                ///获取订单ID
                self.payOrderID = json["data"]["orderId"].stringValue
                self.orderPay_Net()

            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)

        }
    }
    
    
    
    
    private func orderPay_Net() {
        
        if cartModel.paymentSupport == "4" {
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            payAlert.disAppearAction()
            jumpDetailVC(isCanWheel: false)
        } else {
            HTTPTOOl.orderPay(orderID: payOrderID, payType: payWay).subscribe(onNext: { [unowned self] (json)
                in
                
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                self.payAlert.disAppearAction()
                
                ///1需要stripe支付，2不需要
                let stripeType = json["data"]["stripeType"].stringValue
                
                if stripeType == "1" {
                    //调起支付
                    
                    STPAPIClient.shared.publishableKey = json["data"]["publicKey"].stringValue

                    let customerId = json["data"]["customerId"].stringValue
                    let customerEphemeralKeySecret = json["data"]["ephemeralKey"].stringValue
                    let paymentIntentClientSecret = json["data"]["clientSecret"].stringValue

                    var config = PaymentSheet.Configuration()
                    //config.merchantDisplayName = "Test"

                    config.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)

                    DispatchQueue.main.async {

                        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: config)
                        self.paymentSheet?.present(from: self, completion: {  [unowned self] paymentResult in
                            switch paymentResult {
                            case .completed:
                                //跳转到订单详情页面
                                self.jumpDetailVC(isCanWheel: true)
                                
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
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
                
            }).disposed(by: self.bag)

        }
    }
    
    
    private func jumpDetailVC(isCanWheel: Bool) {
        if UserDefaults.standard.local_lat ?? "" != "" {
            UserDefaults.standard.receiver = self.submitModel.recipient
            UserDefaults.standard.phone = self.submitModel.recipientPhone
        }
        //跳转到订单详情页面
        var vcs: [UIViewController] = self.navigationController!.viewControllers
        vcs.removeLast()
        
        let orderDetailVC = OrderDetailController()
        orderDetailVC.orderID = self.payOrderID
        orderDetailVC.isPayAfter = isCanWheel
        vcs += [orderDetailVC]
        self.navigationController?.setViewControllers(vcs, animated: true)

    }
    
    
    ///取消支付
    func cancelPay_Net() {
        HTTPTOOl.payCancel(id: self.payOrderID).subscribe(onNext: { (josn) in
        }).disposed(by: self.bag)
    }

    
    //改变菜品数量
    private func updateDishesCount_Net(count: Int, cartID: String, dishesID: String) {

        HUD_MB.loading("", onView: self.view)
        HTTPTOOl.updateCartNum(buyNum: count, cartID: cartID).subscribe(onNext: { [unowned self] (json) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
            //取消优惠券
            selectCoupon = CouponModel()
            submitModel.couponId = ""
            submitModel.couponUserDishesId = ""

            HTTPTOOl.loadConfirmOrderDetail(storeID: self.storeID, buyWay: "3", lat: "", lng: "", couponID: self.selectCoupon.couponId, postCode: "", couponUserDishesId: selectCoupon.selCouponUserDishesId).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.cartModel.updateModel(json: json["data"], type: "3")
                ///更新选择的赠送菜品
                giftDishesId = cartModel.updateGiftDishesID(selectGiftID: giftDishesId)

                if self.cartModel.deliveryType == "4" {
                    self.showSystemAlert("Tip", json["data"]["deliveryMsg"].stringValue, "Sure")
                }
                if self.cartModel.deliveryType == "5" {
                    //菜品金额不足骑送费用
                    self.showSystemAlert("Tip", self.cartModel.deliveryMsg, "Sure")
                }
                self.mainTable.reloadData()
                self.loadCouponStatus(price: D_2_STR(self.cartModel.subFee - self.cartModel.dishesDiscountAmount))
            }, onError: {[unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.mainTable.reloadData()
            }).disposed(by: self.bag)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}



extension ScanConfirmOrderController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if cartModel.dishArr.count > 2 {
                if isShowAll {
                    return cartModel.dishArr.count
                } else {
                    return 2
                }
            } else {
                return cartModel.dishArr.count
            }
        }
        
        if section == 3 {
            return 1
        }
        
        //是否有优惠菜品
        if section == 4 {
            if cartModel.couponDish.dishName == "" {
                return 0
            } else {
                return 1
            }
        }
        
        //满赠菜品
        if section == 5 {
            if cartModel.fullGiftList.count == 0 {
                return 0
            } else {
                return cartModel.fullGiftList.count + 2
            }
        }
        //满五单送优惠券
        if section == 6 {
            if cartModel.giveCouponReachNum == 0 {
                return 0
            } else {
                return 1
            }
        }

        
        if section == 7 {
            return 0
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
            return cartModel.dishArr[indexPath.row].confirm_cart_dish_H
        }
        if indexPath.section == 3 {
            
            if cartModel.dishArr.count <= 2 {
                return 20
            } else {
                return 60
            }
        }
        
        if indexPath.section == 4 {
            return 140
        }
        
        if indexPath.section == 5 {
            ///满赠
            if indexPath.row == 0 {
                return 50
            }
            else if indexPath.row == cartModel.fullGiftList.count + 1 {
                return 20
            } else {
                return cartModel.fullGiftList[indexPath.row - 1].fullGift_H
            }
        }

        if indexPath.section == 6 {
            ///满单赠
            return 115
        }

        if indexPath.section == 8 {
            return 100
        }
        
        if indexPath.section == 9 {
            return 155
        }
        
        if indexPath.section == 10 {
            return cartModel.confirmMoney_H
            
        }
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTagDineInCell") as! OrderTagDineInCell
            return cell

        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStoreInfoCell") as! OrderStoreInfoCell
            cell.setCellData(model: cartModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderConfirmGoodsCell") as! OrderConfirmGoodsCell
            cell.setCellData(model: cartModel.dishArr[indexPath.row], isCanEdite: self.isCanEidte)
        

            cell.clickCountBlock = { [unowned self] (num) in
                //改变菜品的数量
                let count = num as! Int
                let cartID = self.cartModel.dishArr[indexPath.row].cartID
                let dishID = self.cartModel.dishArr[indexPath.row].dishID
                self.updateDishesCount_Net(count: count, cartID: cartID, dishesID: dishID)
            }
            
            return cell
        }
        
        if indexPath.section == 3 {
            
            if cartModel.dishArr.count <= 2  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRoundedCornersCell") as! OrderRoundedCornersCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderShowMoreCell") as! OrderShowMoreCell
                cell.setCellData(state: self.isShowAll)
                cell.clickBlock = { [unowned self] (bool) in
                    self.isShowAll = bool as! Bool
                    self.mainTable.reloadSections([2, 3], with: .none)
                }
                
                return cell
            }
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponDishCell") as! OrderCouponDishCell
            cell.setCellData(titStr: "Gift", model: cartModel.couponDish)
            return cell
        }
        
        if indexPath.section == 5 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTitleCell") as! OrderTitleCell
                cell.titLab.text = "Free after the order amount is reached"
                return cell
            }
            
            else if indexPath.row == cartModel.fullGiftList.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRoundedCornersCell") as! OrderRoundedCornersCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFullGiftCell") as! OrderFullGiftCell
                
                cell.setCellData(model: cartModel.fullGiftList[indexPath.row - 1], selGiftDishesID: giftDishesId)
                
                cell.selectGiftDishBlock = { [unowned self] (id) in
                    giftDishesId = id as! String
                    mainTable.reloadData()
                }
                
                return cell
            }
        }
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponProgressCell") as! OrderCouponProgressCell
            cell.setCellData(model: cartModel)
            return cell
        }
        

        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponsCell") as! OrderCouponsCell
            cell.setCellData(coupon: self.selectCoupon, isHave: cartModel.isHaveCoupon, isCanEdite: self.isCanEidte)
            
            cell.clickBlock = { [unowned self] (_) in
                //选择优惠券
                goSelectCoupon()
            }
            
            return cell
        }
        if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRemarkCell") as! OrderRemarkCell
            cell.setCellData(cStr: submitModel.remark, isCanEdite: self.isCanEidte)
            cell.editedBlock = { [unowned self] (str) in
                self.submitModel.remark = str as! String
            }
            return cell
        }
        if indexPath.section == 10 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmMoneyCell") as! ConfirmMoneyCell
            cell.setCellData(model: cartModel, buyType: "3")
            return cell
        }
        
                
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayButCell") as! OrderPayButCell
            cell.setCellData(titStr: "Confirm An Order")
            cell.clickPayBlock = { [unowned self] (_) in
                            
                self.clickConfirmAction()
            }
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
}


extension ScanConfirmOrderController {
    
    ///选择优惠券
    private func goSelectCoupon() {
        let couponVC = SelectCouponListController()
        couponVC.delegate = self
        couponVC.storeID = self.storeID
        couponVC.dishesPrice = D_2_STR(self.cartModel.subFee - self.cartModel.dishesDiscountAmount)
        couponVC.selectCoupon = self.selectCoupon
        self.navigationController?.pushViewController(couponVC, animated: true)

    }

    ///弹出支付框
    private func popUpPayAlert() {
        payAlert.paymentSupport = cartModel.paymentSupport
        payAlert.deductionAmount = cartModel.deductionAmount
        payAlert.payPrice = cartModel.payPrice
        payAlert.subtotal = cartModel.subFee
        payAlert.total = cartModel.orderPrice
        payAlert.deliveryPrice = cartModel.deliverFee
        payAlert.servicePrice = cartModel.serviceFee
        payAlert.discountScale = cartModel.discountScale
        payAlert.discountAmount = cartModel.discountAmount
        payAlert.dishesDiscountAmount = cartModel.dishesDiscountAmount
        payAlert.couponAmount = cartModel.couponAmount
        payAlert.packPrice = cartModel.packPrice
        payAlert.buyType = "3"
        self.payAlert.alertReloadData()
        self.payAlert.appearAction()
    }
    
}







