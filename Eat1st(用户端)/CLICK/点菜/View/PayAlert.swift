//
//  PayAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/1/25.
//

import UIKit

class PayAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var clickPayBlock: VoidBlock?

    ///是否可以现金付款或是否可以在线付款 1现金 2卡  99都行
    var paymentSupport: String = ""

    ///1 现金  2 卡
    private var payWay: String = ""
    
    private var H: CGFloat = bottomBarH + 570
    
//    ///钱包金额
//    var walletAmount: Double = 0
    ///配送金额
    var deliveryPrice: Double = 0
    ///菜的价格
    var subtotal: Double = 0
    ///订单金额 除去折扣  不除钱包
    var total: Double = 0
    ///支付金额
    var payPrice: Double = 0
    ///抵扣金额
    var deductionAmount: Double = 0
    ///服务费
    var servicePrice: Double = 0
    ///折扣金额
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            if buyType == "1" {
                //外卖
                let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, servicePrice].filter { $0 != 0 }
                return 3 * 35 + CGFloat(arr.count) * 35 + 20
                
            } else {
                let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, servicePrice, deliveryPrice].filter { $0 != 0 }
                return 2 * 35 + CGFloat(arr.count) * 35 + 20
            }

        }
        
        if indexPath.row == 1 {
            
            if deductionAmount == 0 {
                return 35 + 20
            } else {
                return 70 + 20
            }
        }
        
        if indexPath.row == 2 {
            return 160
        }
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayAlertMoneyCell") as! PayAlertMoneyCell
        
            cell.setCellData(money: [subtotal, deliveryPrice, servicePrice, packPrice, dishesDiscountAmount, couponAmount, discountAmount, total], scale: discountScale, buyType: buyType)
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayAlertPayCell") as! PayAlertPayCell
            cell.setCellData(money: [deductionAmount, payPrice])
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderChoosePayWayCell") as! OrderChoosePayWayCell
            cell.setCellData(status: paymentSupport, type: payWay)
            
            cell.clickTypeBlock = { [unowned self] (type) in
                self.payWay = type as! String
                self.mainTable.reloadData()
            }

            return cell
        }
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayButCell") as! OrderPayButCell
            cell.clickPayBlock = { [unowned self] (_) in
                print("支付")
                
                if self.payWay == "" {
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





//class PayAlertMoneyCell: BaseTableViewCell {
//
//
//    private let backView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    private let tlab1: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "Subtotal"
//        return lab
//    }()
//    
//    private let tlab2: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "Delivery fee"
//        return lab
//    }()
//    
//    private let tlab3: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "Service fee"
//        return lab
//    }()
//    
//    private let tlab4: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "Discount"
//        return lab
//    }()
//
//    
//    private let tlab5: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "Total"
//        return lab
//    }()
//
//
//    
//    private let moneyLab1: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
//        lab.text = "£10"
//        return lab
//    }()
//    
//    
//    private let moneyLab2: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
//        lab.text = "£10"
//        return lab
//    }()
//    
//    
//    private let moneyLab3: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
//        lab.text = "£10"
//        return lab
//    }()
//    
//    private let moneyLab4: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FF461C"), BFONT(15), .right)
//        lab.text = "-£10"
//        return lab
//    }()
//
//    
//    private let moneyLab5: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
//        lab.text = "£10"
//        return lab
//    }()
//    
//    
//    private let discountScaleLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FF461C"), SFONT(13), .left)
//        return lab
//    }()
//    
//    private let discountImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("discount")
//        return img
//    }()
//
//
//
//
//    override func setViews() {
//        
//        self.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
//        
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.bottom.equalToSuperview()
//        }
//        
//        backView.addSubview(tlab1)
//        tlab1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalToSuperview().offset(20)
//        }
//        
//        backView.addSubview(tlab2)
//        tlab2.snp.makeConstraints {
//            $0.left.equalTo(tlab1)
//            $0.top.equalToSuperview().offset(55)
//        }
//        
//        backView.addSubview(tlab3)
//        tlab3.snp.makeConstraints {
//            $0.left.equalTo(tlab1)
//            $0.top.equalToSuperview().offset(90)
//        }
//        
//        backView.addSubview(tlab4)
//        tlab4.snp.makeConstraints {
//            $0.left.equalTo(tlab1)
//            $0.top.equalToSuperview().offset(125)
//        }
//        
//        backView.addSubview(tlab5)
//        tlab5.snp.makeConstraints {
//            $0.left.equalTo(tlab1)
//            $0.top.equalToSuperview().offset(160)
//        }
//
//        
//        
//        backView.addSubview(moneyLab1)
//        moneyLab1.snp.makeConstraints {
//            $0.right.equalToSuperview().offset(-10)
//            $0.centerY.equalTo(tlab1)
//        }
//        
//        backView.addSubview(moneyLab2)
//        moneyLab2.snp.makeConstraints {
//            $0.centerY.equalTo(tlab2)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        backView.addSubview(moneyLab3)
//        moneyLab3.snp.makeConstraints {
//            $0.centerY.equalTo(tlab3)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        backView.addSubview(moneyLab4)
//        moneyLab4.snp.makeConstraints {
//            $0.centerY.equalTo(tlab4)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        backView.addSubview(moneyLab5)
//        moneyLab5.snp.makeConstraints {
//            $0.centerY.equalTo(tlab5)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        backView.addSubview(discountImg)
//        discountImg.snp.makeConstraints {
//            $0.centerY.equalTo(tlab4)
//            $0.right.equalTo(moneyLab1.snp.left).offset(-7)
//        }
//        
//        backView.addSubview(discountScaleLab)
//        discountScaleLab.snp.makeConstraints {
//            $0.centerY.equalTo(tlab4)
//            $0.left.equalTo(tlab1.snp.right).offset(5)
//        }
//
//        
//    }
//    
//
//    func setCellPayAlertData(subtotal: String, dePrice: String, orderTotal: String, service: String, discountPrice: String, discountScale: String) {
//        
//        if discountScale == "" {
//            self.discountScaleLab.text = ""
//        } else {
//            self.discountScaleLab.text = "(\(discountScale)OFF)"
//        }
//
//        
//        self.moneyLab1.text = "£\(subtotal)"
//        self.moneyLab2.text = "£\(dePrice)"
//        self.moneyLab3.text = "£\(service)"
//        self.moneyLab4.text = "-£\(discountPrice)"
//        self.moneyLab5.text = "£\(orderTotal)"
//  
//     }
//    
//}

