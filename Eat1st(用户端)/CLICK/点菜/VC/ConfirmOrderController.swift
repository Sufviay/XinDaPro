//
//  ConfirmOrderController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit
import RxSwift
import Stripe


class ConfirmOrderController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SelectAddressDelegate, SystemAlertProtocol, SelectCouponDelegate {
    
        
    private let bag = DisposeBag()
    
    ///店铺信息
    var storeModel = StoreInfoModel()
    
    ///1外卖 2自取
    var type: String = "" {
        didSet {
            self.submitModel.type = type
        }
    }
    
    ///店铺ID
    var storeID: String = "" {
        didSet {
            self.submitModel.storeId = storeID
        }
    }
    
    ///支付的订单ID
    var payOrderID: String = ""
    
    ///是否可编辑
    var isCanEidte: Bool = true
    
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

        tableView.register(OrderSelectTagCell.self, forCellReuseIdentifier: "OrderSelectTagCell")
        tableView.register(OrderStoreInfoCell.self, forCellReuseIdentifier: "OrderStoreInfoCell")
        tableView.register(OrderConfirmGoodsCell.self, forCellReuseIdentifier: "OrderConfirmGoodsCell")
        tableView.register(OrderShowMoreCell.self, forCellReuseIdentifier: "OrderShowMoreCell")
        tableView.register(OrderRoundedCornersCell.self, forCellReuseIdentifier: "OrderRoundedCornersCell")
        tableView.register(OrderCouponsCell.self, forCellReuseIdentifier: "OrderCouponsCell")
        tableView.register(OrderpayMoneyCell.self, forCellReuseIdentifier: "OrderpayMoneyCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        
        tableView.register(ConfirmMoneyCell.self, forCellReuseIdentifier: "ConfirmMoneyCell")
        
        tableView.register(OrderPayButCell.self, forCellReuseIdentifier: "OrderPayButCell")
        tableView.register(OrderTagCollectionCell.self, forCellReuseIdentifier: "OrderTagCollectionCell")
        tableView.register(OrderTagDeliveryCell.self, forCellReuseIdentifier: "OrderTagDeliveryCell")
        tableView.register(OrderInputCell.self, forCellReuseIdentifier: "OrderInputCell")
        tableView.register(OrderInputZQCell.self, forCellReuseIdentifier: "OrderInputZQCell")
        
        tableView.register(OrderCouponDishCell.self, forCellReuseIdentifier: "OrderCouponDishCell")
        
        return tableView
    }()
    
    
    ///选择时间
    private lazy var timeAlert: TimeListAlert = {
        let alert = TimeListAlert()
        alert.storeID = self.storeID
        
        alert.clickTimeBlock = { [unowned self] (time) in
            self.submitModel.hopeTime = time as! String
            self.getYSDTime_Net()
        }
        return alert
    }()
    
    //预约时间
    private lazy var yy_timeAlert: YuYueTimeListAlert = {
        let alert = YuYueTimeListAlert()
        alert.storeID = self.storeID
        
        alert.clickTimeBlock = { [unowned self] (time) in
            self.submitModel.hopeTime = time as! String
            self.mainTable.reloadSections([5], with: .none)
        }
        return alert
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
    
    
//    ///钱包
//    private let walletView: WalletView = {
//        let view = WalletView()
//        return view
//    }()

    
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
        
//        let lat = UserDefaults.standard.local_lat ?? ""
//        let lng = UserDefaults.standard.local_lng ?? ""
        
        //加载页面首次请求
        initData_Net()
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
    
//    @objc func walletRefresh() {
//        getWalletMoney_Net()
//    }

    
    
    
    //MARK: - 选择地址
    func didSelectedAddress(model: AddressModel) {
            
        self.setSubmitModelValue(model: model)
    
        //切换地址后 刷新数据
        loadData_Net(lat: model.lat, lng: model.lng)
    }
    
    //MARK: - 选择优惠券
    func didSelectedCoupon(coupon: CouponModel) {
        self.selectCoupon = coupon
        self.submitModel.couponId = coupon.couponId
        
        //选择优惠券后 刷新数据
        loadData_Net(lat: submitModel.recipientLat, lng: submitModel.recipientLng)
    }

    
    private func setSubmitModelValue(model: AddressModel) {
        self.submitModel.recipientLat = model.lat
        self.submitModel.recipientLng = model.lng

        self.submitModel.recipient = model.receiver
        self.submitModel.recipientPhone = model.phone
        self.submitModel.recipientPostcode = model.postcode
        self.submitModel.doorNum = model.detail
        self.submitModel.address = model.address
    }
    
    
    //MARK: - 网络请求
    private func initData_Net() {
        //请求地址 获取默认地址
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getAddressList(storeID: storeID, type: "1", page: 1).subscribe(onNext: { (json) in
            if json["data"].arrayValue.count != 0  {
                if json["data"].arrayValue.first!["defaultAddr"].stringValue == "2" &&  json["data"].arrayValue.first!["deliverType"].stringValue == "1" {
                    //有默认地址
                    let defaultModel = AddressModel()
                    defaultModel.updateModel(json: json["data"].arrayValue.first!)
                    ///赋值submitModel
                    self.setSubmitModelValue(model: defaultModel)
                }
            }
            //请求确认订单页面的数据
            self.loadData_Net(lat: self.submitModel.recipientLat, lng: self.submitModel.recipientLng)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
        
    }
    
    
    
    
    private func loadData_Net(lat: String, lng: String) {
        HUD_MB.loading("", onView: view)
        
        ///cal
        HTTPTOOl.loadConfirmOrderDetail(storeID: storeID, buyWay: type, lat: lat, lng: lng, couponID: selectCoupon.couponId).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
//            ///如果是优惠券添加赠品菜要更新购物车
//            if self.selectCoupon.couponId != "" && self.selectCoupon.couponType == "3" {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
//            }
            
            self.cartModel.updateModel(json: json["data"])
            
            if self.cartModel.deliveryType == "1" {
                //当前没有位置信息
                HUD_MB.showWarnig("Please select a shipping address!", onView: self.view)
            }
            
            if self.cartModel.deliveryType == "2"{
                //当前位置坐标发生错误！
                HUD_MB.showWarnig("Please select a shipping address!", onView: self.view)
                self.submitModel.address = ""
                self.submitModel.doorNum = ""
                self.submitModel.recipientPostcode = ""
            }
        
            if self.cartModel.deliveryType == "4"{
                //当前位置信息超出配送范围
                self.showSystemAlert("Tip", json["data"]["deliveryMsg"].stringValue, "Sure")
                self.submitModel.address = ""
                self.submitModel.doorNum = ""
                self.submitModel.recipientPostcode = ""
            }
            
            if self.cartModel.deliveryType == "5" {
                //菜品金额不足骑送费用
                self.showSystemAlert("Tip", self.cartModel.deliveryMsg, "Sure")
            }
            
            
            
            if self.submitModel.hopeTime == "" {
                if self.cartModel.reserveMsg == "" {
                    self.submitModel.hopeTime = "ASAP"
                } else {
                    self.submitModel.hopeTime = ""
                }
            }
            self.sectionNum = 10
            self.mainTable.reloadData()
            self.getYSDTime_Net()

        }, onError: { (error) in
            
            if error as! NetworkError  == .errorCode10  {
                /////优惠券无法使用 清除选中的优惠券
                self.selectCoupon = CouponModel()
                self.submitModel.couponId = ""
                HUD_MB.showWarnig(ErrorTool.errorMessage(error), onView: self.view)
            } else {
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }
            self.mainTable.reloadData()
        }).disposed(by: self.bag)
    }
    
    
    private func getYSDTime_Net() {
        
        ///当不是预售订单时 请求送达时间
        if cartModel.reserveMsg == "" {
            HTTPTOOl.getCalOrderTime(type: type, storeID: storeID, time: submitModel.hopeTime).subscribe(onNext: { (json) in
                //HUD_MB.dissmiss(onView: self.view)
                self.minTime = json["data"]["startTime"].stringValue
                self.maxTime = json["data"]["endTime"].stringValue
                self.mainTable.reloadSections([5], with: .none)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        }
    }
    
    
    
    private func clickConfirmAction() {
        
        if cartModel.deliveryType == "5" {
            self.showSystemAlert("Tip", cartModel.deliveryMsg, "Sure")
            return
        }
        
        if submitModel.recipient == "" {
            HUD_MB.showWarnig("Please Enter your name!", onView: self.view)
            return
        }
        
        //外卖
        if type == "1" {

            if submitModel.doorNum == "" {
                HUD_MB.showWarnig("Please Enter your house number!", onView: self.view)
                return
            }
            
        }
    
        if submitModel.recipientPhone == "" {
            HUD_MB.showWarnig("Please Enter your phone!", onView: self.view)
            return
        }
        
        if submitModel.hopeTime == "" {
            HUD_MB.showWarnig("Please Enter the expected time!", onView: self.view)
            return
        }
        
        ///弹出支付弹窗
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
        self.payAlert.alertReloadData()
        self.payAlert.appearAction()
    }
    
    
    ///创建订单
    private func createOrder_Net() {

        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        
        if payOrderID != "" {
            self.orderPay_Net()
        } else {
            //创建订单
            if type == "2" {
                //自取订单
                self.submitModel.recipientPostcode = ""
                self.submitModel.recipientAddress = ""
                self.submitModel.address = ""
                self.submitModel.doorNum = ""
                self.submitModel.recipientLat = ""
                self.submitModel.recipientLng = ""
            } else {
                //外卖订单
                self.submitModel.recipientAddress = submitModel.doorNum + "\n" + submitModel.address
            }

            HTTPTOOl.createOrder(model: self.submitModel).subscribe(onNext: { (json) in
                ///刷新点餐页面
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pageRefresh"), object: nil)
                self.isCanEidte = false
                self.mainTable.reloadData()
                ///获取订单ID
                self.payOrderID = json["data"]["orderId"].stringValue
                self.orderPay_Net()

            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)

        }
    }
    
    
    
    
    private func orderPay_Net() {
        
        HTTPTOOl.orderPay(orderID: payOrderID, payType: payWay).subscribe(onNext: { (json)
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
                    self.paymentSheet?.present(from: self, completion: { paymentResult in
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
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            
        }).disposed(by: self.bag)
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

    
    
//    //获取钱包
//    private func getWalletMoney_Net() {
//        HTTPTOOl.getWalletAmount().subscribe(onNext: { (json) in
//
//            let moneyStr = "£" + json["data"]["amount"].stringValue
//            self.walletView.setData(money: moneyStr)
//            let w = moneyStr.getTextWidth(SFONT(11), 23) > 15 ? moneyStr.getTextWidth(SFONT(11), 23) : 15
//
//
//            self.walletView.snp.makeConstraints {
//                $0.bottom.equalToSuperview().offset(-bottomBarH - 80)
//                $0.right.equalToSuperview().offset(-20)
//                $0.size.equalTo(CGSize(width: w + 50, height: 32))
//            }
//
//            self.walletView.isHidden = false
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
    
    //改变菜品数量
    private func updateDishesCount_Net(count: Int, cartID: String, dishesID: String) {
        
//        if selectCoupon.couponId != "" && selectCoupon.couponType == "3" && count == 0 {
//            ///当选择优惠券是赠送菜品时。 改变菜品的数量时，当要删除赠送菜品时需要校验，必须要取消优惠券后才能删除
//            if selectCoupon.dishesId == dishesID {
//                showSystemAlert("Tip", "Please deselect the coupon first", "Sure")
//                return
//            }
//        }
//
        HUD_MB.loading("", onView: self.view)
        HTTPTOOl.updateCartNum(buyNum: count, cartID: cartID).subscribe(onNext: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
            HTTPTOOl.loadConfirmOrderDetail(storeID: self.storeID, buyWay: self.type, lat: self.submitModel.recipientLat, lng: self.submitModel.recipientLng, couponID: self.selectCoupon.couponId).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.cartModel.updateModel(json: json["data"])
                if self.cartModel.deliveryType == "4" {
                    self.showSystemAlert("Tip", json["data"]["deliveryMsg"].stringValue, "Sure")
                }
                if self.cartModel.deliveryType == "5" {
                    //菜品金额不足骑送费用
                    self.showSystemAlert("Tip", self.cartModel.deliveryMsg, "Sure")
                }
                self.mainTable.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//                DispatchQueue.main.after(time: .now() + 1) {
//                    self.navigationController?.popViewController(animated: true)
//                }
            }).disposed(by: self.bag)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}



extension ConfirmOrderController {
    
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
            
            let h = cartModel.reserveMsg.getTextHeigh(SFONT(10), S_W - 60) > 11 ? cartModel.reserveMsg.getTextHeigh(SFONT(10), S_W - 60) : 11
            
            if type == "1" {
                //配送
                return 270 + h
            }
            if type == "2" {
                return 190 + h
            }
        }
        if indexPath.section == 6 {
            return 100
        }
        
        if indexPath.section == 7 {
            return 155
        }
        
        if indexPath.section == 8 {
            return cartModel.confirmMoney_H
            
        }
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if storeModel.deStatus == "1" && storeModel.coStatus == "2" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTagDeliveryCell") as! OrderTagDeliveryCell
                return cell
            }
            if storeModel.deStatus == "2" && storeModel.coStatus == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTagCollectionCell") as! OrderTagCollectionCell
                return cell
            }
            if storeModel.deStatus == "1" && storeModel.coStatus == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSelectTagCell") as! OrderSelectTagCell
                cell.setCellData(type: self.type, isCanEdite: self.isCanEidte)
                cell.clickTypeBlock = { [unowned self] (tStr) in
                    self.type = tStr as! String
                    
                    //切换购买方式  外卖 还是自取
                    self.loadData_Net(lat: submitModel.recipientLat, lng: submitModel.recipientLng)
                }
                return cell
            }
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
            cell.setCellData(model: cartModel.couponDish)
            return cell
        }
        
        
        if indexPath.section == 5 {
            
            if type == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInputCell") as! OrderInputCell
                
                var addressStr = ""
                if submitModel.recipientPostcode != "" && submitModel.address != "" {
                    addressStr = "\(submitModel.recipientPostcode) \(submitModel.address)"
                }
                cell.setCellData(name: submitModel.recipient, phone: submitModel.recipientPhone, address: addressStr, doorNum: submitModel.doorNum, time: submitModel.hopeTime, isCanEdite: self.isCanEidte, minTime: minTime, maxTime: maxTime, ydMsg: cartModel.reserveMsg)
                
                cell.clickAddressBlock = { [unowned self] (_) in
                    let nextVC = ChooseAddressController()
                    nextVC.storeID = self.storeID
                    nextVC.delegate = self
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                cell.clickTimeBlock = { [unowned self] (_) in
                    self.showTimeAlert()
                }
                
                cell.editeNameBlock = { [unowned self] (str) in
                    self.submitModel.recipient = str as! String
                }
                cell.editePhoneBlock = { [unowned self] (str) in
                    self.submitModel.recipientPhone = str as! String
                }
                cell.editeDoorNumBlock = { [unowned self] (str) in
                    self.submitModel.doorNum = str as! String
                }
            
                return cell
            }
            
            if type == "2" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInputZQCell") as! OrderInputZQCell
                cell.setCellData1(name: submitModel.recipient, phone: submitModel.recipientPhone, time: submitModel.hopeTime, isCanEidte: self.isCanEidte, minTime: minTime, maxTime: maxTime, ydMsg: cartModel.reserveMsg)
                
                cell.editeNameBlock = { [unowned self] (str) in
                    self.submitModel.recipient = str as! String
                }
                cell.editePhoneBlock = { [unowned self] (str) in
                    self.submitModel.recipientPhone = str as! String
                }
            
                cell.clickTimeBlock = { [unowned self] (_) in
                    self.showTimeAlert()
                }
                
                return cell
            }
            
        }
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCouponsCell") as! OrderCouponsCell
            cell.setCellData(coupon: self.selectCoupon, isCanEdite: self.isCanEidte)
            
            cell.clickBlock = { [unowned self] (_) in
                //选择优惠券
                let couponVC = SelectCouponListController()
                couponVC.delegate = self
                couponVC.storeID = self.storeID
                couponVC.dishesPrice = D_2_STR(self.cartModel.subFee - self.cartModel.dishesDiscountAmount)
                couponVC.selectCoupon = self.selectCoupon
                self.navigationController?.pushViewController(couponVC, animated: true)
            }
            
            return cell
        }
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRemarkCell") as! OrderRemarkCell
            cell.setCellData(cStr: submitModel.remark, isCanEdite: self.isCanEidte)
            cell.editedBlock = { [unowned self] (str) in
                self.submitModel.remark = str as! String
            }
            return cell
        }
        if indexPath.section == 8 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmMoneyCell") as! ConfirmMoneyCell
            cell.setCellData(model: cartModel)
            return cell
        }
        
                
        if indexPath.section == 9 {
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

extension ConfirmOrderController {
    
    private func showTimeAlert() {
        if self.cartModel.reserveMsg == "" {
            self.timeAlert.type = self.type
            self.timeAlert.appearAction()
        } else {
            self.yy_timeAlert.type = self.type
            self.yy_timeAlert.appearAction()
        }
    }
    
}






