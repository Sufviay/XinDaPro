//
//  PayAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/1/25.
//

import UIKit

class PayAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var clickPayBlock: VoidBlock?
    ///1 现金  2 卡  已选择的支付方式。
    private var payWay: String = ""


    
    private var H: CGFloat = bottomBarH + 550
    
    ///是否可以现金付款或是否可以在线付款 1现金 2卡  3或99都行 4不需要
    var paymentSupport: String = ""
    ///配送金额
    var deliveryPrice: Double = 0
    ///菜的价格 商品实际金额
    var subtotal: Double = 0
    ///订单金额 除去折扣  不除钱包
    var total: Double = 0
    ///支付金额
    var payPrice: Double = 0
    ///抵扣金额
    //var deductionAmount: Double = 0
    ///服务费
    var servicePrice: Double = 0
    ///店铺的折扣金额
    var discountAmount: Double = 0
    ///菜品的优惠金额
    var dishesDiscountAmount: Double = 0
    
    ///优惠券抵扣金额
    var couponAmount: Double = 0
    ///折扣比例
    var discountScale: String = ""
    
    ///包装费用
    var packPrice: Double = 0
    ///购买方式 1外卖 2自取 3堂食
    var buyType: String = ""
    ///余额支付金额
    var rechargePrice: Double = 0
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.text = "Order payment"
        return lab
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("alert_close"), for: .normal)
        return but
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 570), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
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


        tableView.register(PayAlertMoneyCell.self, forCellReuseIdentifier: "PayAlertMoneyCell")
        tableView.register(PayAlertPayCell.self, forCellReuseIdentifier: "PayAlertPayCell")
        tableView.register(OrderPayButCell.self, forCellReuseIdentifier: "OrderPayButCell")
        tableView.register(OrderChoosePayWayCell.self, forCellReuseIdentifier: "OrderChoosePayWayCell")
        
        return tableView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(titLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
        }

        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clickCloseAction() {
        disAppearAction()
    }
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    func alertReloadData() {
        self.mainTable.reloadData()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if paymentSupport == "4" || paymentSupport == "" {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            if buyType == "1" {
                //外卖
                let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, servicePrice, total].filter { $0 != 0 }
                return 2 * 35 + CGFloat(arr.count) * 35 + 20
                
            } else {
                let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, servicePrice, total, deliveryPrice].filter { $0 != 0 }
                return 1 * 35 + CGFloat(arr.count) * 35 + 20
            }

        }
        
        if indexPath.section == 1 {
            
            if rechargePrice == 0 {
                return 35 + 20
            } else {
                return 70 + 20
            }
        }
        
        if indexPath.section == 2 {
                    
            return 160
        }
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayAlertMoneyCell") as! PayAlertMoneyCell
        
            cell.setCellData(money: [subtotal, deliveryPrice, servicePrice, packPrice, dishesDiscountAmount, couponAmount, discountAmount, total], scale: discountScale, buyType: buyType)
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayAlertPayCell") as! PayAlertPayCell
            cell.setCellData(money: [rechargePrice, payPrice])
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderChoosePayWayCell") as! OrderChoosePayWayCell
            cell.setCellData(status: paymentSupport, type: payWay)
            
            cell.clickTypeBlock = { [unowned self] (type) in
                self.payWay = type as! String
                self.mainTable.reloadData()
            }

            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayButCell") as! OrderPayButCell
            
            if paymentSupport == "4" || paymentSupport == "" {
                cell.setCellData(titStr: "Confirm")
            } else {
                cell.setCellData(titStr: "Pay")
            }
            
            cell.clickPayBlock = { [unowned self] (_) in
                print("支付")
                if paymentSupport != "4" && paymentSupport != "" && payWay == "" {
                    HUD_MB.showWarnig("Please select payment method!", onView: self)
                    return
                }
                self.clickPayBlock?(payWay)

            }
            return cell
        }
        
        
        let cell = UITableViewCell()
        return cell
        
    }
    

    
}




