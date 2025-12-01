//
//  MessageController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/10.
//

import UIKit
import RxSwift
import MJRefresh


class MessageController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var page: Int = 1
    
    private var dataArr: [MessageModel] = []
    private var selectType = TypeModel(id: "", name: "All".local)
    
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
        //tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")

        return tableView
    }()
    
    

    private let typeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = BACKCOLOR_3
        but.clipsToBounds = true
        but.layer.cornerRadius = 5
        return but
    }()

    
    private let xlImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl_b")
        return img
    }()

    
    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "All".local
        return lab
    }()


    private lazy var typeAlert: SelectTypeAlert = {
        let view = SelectTypeAlert()
        view.alertType = .logType
        view.selectBlock = { [unowned self] (par) in
            selectType.id = (par as! TypeModel).id
            selectType.name = (par as! TypeModel).name
            typeLab.text = selectType.name
            loadMsg_Net()
        }
        
        return view
    }()

    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Operation record".local
    }

    
    override func setViews() {
        
        setUpUI()
        loadMsg_Net()
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            self.loadMsg_Net(true)
        }

        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            self.loadMsgMore_Net()
        }
    }
    
    
    func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(typeBut)
        typeBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(45)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }

        typeBut.addSubview(xlImg1)
        xlImg1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }

        
        typeBut.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }

        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalTo(typeBut.snp.bottom).offset(10)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        typeBut.addTarget(self, action: #selector(clickTypeAction), for: .touchUpInside)
    }
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickTypeAction() {
        typeAlert.appearAction()
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cell_H
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let model = dataArr[indexPath.row]
        if model.operateType != "6" && model.operateType != "7" {
//            ///合并订单
//            let mergeVC = MergeOrderController()
//            mergeVC.mergeID = model.orderID
//            self.navigationController?.pushViewController(mergeVC, animated: true)
//        } else {
            let detailVC = OrderDetailController()
            detailVC.orderID = model.orderID
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


extension MessageController {
    
    
    func loadMsg_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: backView)
        }
        
        HTTPTOOl.getMsgList(page: 1, typeList: [selectType.id]).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            self.page = 2
            var tArr: [MessageModel] = []
            for jsondata in json["data"].arrayValue {
                let model = MessageModel()
                model.updateModel(json: jsondata)
                tArr.append(model)
            }
            
            dataArr = tArr
            if dataArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
            table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    func loadMsgMore_Net() {
        HTTPTOOl.getMsgList(page: page, typeList: [selectType.id]).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = MessageModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
            table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    
}





import SwiftyJSON

class MessageModel: NSObject {
    
    var orderID: String = ""
    ///操作类型（1拒接订单，2取消订单，3修改订单，4订单折扣，5修改支付方式，6保存预付，7删除预付，8打印汇总，9删除订单菜品，10用户充值，11充值消费，12修改堂食服务费，13充值禮品卡）
    var operateType: String = ""
//    ///订单是否合并（1否，2是），若orderId未合并订单编码，否则为订单编码
//    var mergeType: String = ""
    ///优惠金额（当operator_type=4时有值）
    var discountPrice: Double = 0
    
    ///餐桌名称
    var deskName: String = ""
    
    ///预付类型 1现金券，2现金结算，3POS结算，4现金&POS结算 ），当operate_type=5、6时有值
    var advanceType: String = ""
    
    ///现金优惠券
    var couponPrice: Double = 0
    
    ///现金预缴金额
    var cashPrice: Double = 0
    
    ///pos预缴金额
    var posPrice: Double = 0
    
    ///现金小费金额
    var tipCashPrice: Double = 0
    
    ///pos 小费金额
    var tipPosPrice: Double = 0
    
    ///是否修改支付方式  (1未修改，2修改），当operateType=3时有值
    var isUpdatePayType: Bool = false
    
    ///原来的支付方式 1现金，2卡，3Pos，4现金&POS 未修改为-1  5 微信 6 余额
    var oldPayType: String = ""
    
    ///新的支付方式 1现金，2卡，3Pos，4现金&POS 未修改为-1  5 微信 6 余额
    var newPayType: String = ""
    
    ///现金金额 只有newPayType == 4 时有值
    var payTypeCashPrice: Double = 0
    
    ///POS金额 只有newPayType == 4 时有值
    var payTypePosPrice: Double = 0
   
    ///是否修改配送费（1未修改，2修改）
    var isUpdateDelivery: Bool = false
    ///原配送费
    var oldDeliveryPrice: Double = 0
    ///新的配送费
    var newDeliveryPrice: Double = 0
    
    ///是否修改菜品 1未修改，2修改
    var isUpdateDishes: Bool = false
    ///原来菜品金额
    var oldDishesPrice: Double = 0
    ///新菜品金额
    var newDishesPrice: Double = 0
    
    ///是否修改了订单总金额
    var isUpdateTotal: Bool = false
    ///原来订单金额
    var oldOrderPrice: Double = 0
    ///新的订单金额
    var newOrderPrice: Double = 0
    
    ///现金券编码
    var couponNo: String = ""
    
        
    
    
    ///操作人
    var createBy: String = ""
    ///操作时间
    var createTime: String = ""
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        self.orderID = json["orderId"].stringValue
        self.operateType = json["operateType"].stringValue
        self.discountPrice = json["discountPrice"].doubleValue
        
        self.createBy = json["createBy"].stringValue
        self.createTime = json["createTime"].stringValue
        
        deskName = json["deskName"].stringValue
        
        advanceType = json["advanceType"].stringValue
        
        couponPrice = json["couponPrice"].doubleValue
        
        cashPrice = json["cashPrice"].doubleValue
        
        posPrice = json["posPrice"].doubleValue
        
        tipPosPrice = json["tipPosPrice"].doubleValue
        
        tipCashPrice = json["tipCashPrice"].doubleValue
        
        isUpdatePayType = json["updatePayType"].stringValue == "2" ? true : false
        
        
        let o_type = json["oldPayType"].stringValue
        if o_type == "1" {
            oldPayType = "Cash"
        }
        if o_type == "2" {
            oldPayType = "Card"
        }
        if o_type == "3" {
            oldPayType = "Pos"
        }
        if o_type == "4" {
            oldPayType = "Cash&Pos"
        }
        if o_type == "5" {
            oldPayType = "WX"
        }
        if o_type == "6" {
            oldPayType = "Wallet"
        }

        
        let n_type = json["newPayType"].stringValue
        if n_type == "1" {
            newPayType = "Cash"
        }
        if n_type == "2" {
            newPayType = "Card"
        }
        if n_type == "3" {
            newPayType = "Pos"
        }
        if n_type == "4" {
            newPayType = "Cash&Pos"
        }
        if n_type == "5" {
            newPayType = "WX"
        }
        if n_type == "6" {
            newPayType = "Wallet"
        }

        

        payTypeCashPrice = json["payTypeCashPrice"].doubleValue
        payTypePosPrice = json["payTypePosPrice"].doubleValue
        
        isUpdateDelivery = json["updateDelivery"].stringValue == "2" ? true : false
        oldDeliveryPrice = json["oldDeliveryPrice"].doubleValue
        newDeliveryPrice = json["newDeliveryPrice"].doubleValue
        
        isUpdateDishes = json["updateDishes"].stringValue == "2" ? true : false
        oldDishesPrice = json["oldDishesPrice"].doubleValue
        newDishesPrice = json["newDishesPrice"].doubleValue
        
        isUpdateTotal = json["updateTotal"].stringValue == "2" ? true : false
        oldOrderPrice = json["oldOrderPrice"].doubleValue
        newOrderPrice = json["newOrderPrice"].doubleValue
        
        couponNo = json["couponNo"].stringValue
        
        
        
        var t_h: CGFloat = 0
        
        let tarr = [discountPrice, couponPrice, cashPrice, posPrice, tipCashPrice, tipPosPrice]
        
        let count = tarr.filter { $0 != 0 }.count
        
        t_h = CGFloat(count) * 20 + 75
        
        if deskName != "" {
            t_h += 20
        }
        
        if couponNo != "" {
            t_h += 20
        }
        
        if isUpdatePayType {
            t_h += 20
        }
        
        if payTypePosPrice != 0 {
            t_h += 20
        }
        
        if payTypeCashPrice != 0 {
            t_h += 20
        }
        
        if isUpdateDelivery {
            t_h += 20
        }
        
        if isUpdateDishes {
            t_h += 20
        }

        if isUpdateTotal {
            t_h += 20
        }
        
        
        t_h += 10
        
//        if operateType == "6" || operateType == "7" || operateType == "8" || operateType == "9" {
//            t_h += 10
//        } else {
//            t_h += 40
//        }
//        
        cell_H = t_h
    }
    
}


