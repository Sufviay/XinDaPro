//
//  OrderListModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/30.
//

import UIKit
import SwiftyJSON


class OrderListModel: NSObject {
    
    ///订单总金额
    var amountTotal: Double = 0
    ///店铺名称
    var name: String = ""
    ///店铺ID
    var storeID: String = ""
    ///订单状态 订单状态
    ///1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
    var status: OrderStatus = .unKnown
    ///菜品列表图
    var dishImgArr: [String] = []

    ///菜品数量
    var dishCount: Int = 0
    ///状态文字
    var statusStr: String = ""
    ///订单ID
    var orderID: String = ""
    
    ///订单类型(1：外卖 2：自取)
    var type: String = ""
    
    ///订单评价状态 （1未评价，2已评价）
    var evaluateStatus: String = ""
    
    ///订单投诉状态（1未投诉，2未处理，3商家拒绝，4商家退款，5再送一单，6下次优惠）
    var plaintStatus: String = ""
    
    //创建时间
    var createTime: String = ""
    
    //是否有按钮
    var isHaveBotton: Bool = false
    
    ///是否可抽奖 1否 2是
    var prizeStatus: Bool = false
    
    
    func updateModel(json: JSON) {
        
        
        self.amountTotal = json["orderPrice"].doubleValue
        self.name = json["storeName"].stringValue
        self.storeID = json["storeId"].stringValue
        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        
        self.dishImgArr = json["imageUrlList"].arrayObject as! [String]
        self.dishCount = json["dishesNum"].intValue
        self.statusStr = json["statusName"].stringValue
        self.orderID = json["orderId"].stringValue
        self.type = json["deliveryType"].stringValue
        self.evaluateStatus = json["evaluateStatusId"].stringValue
        self.plaintStatus = json["plaintStatusId"].stringValue
        self.createTime = json["createTime"].stringValue
        self.prizeStatus = json["prizeStatus"].stringValue == "1" ? false : true
        
        //1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
        if self.status == .pay_wait || self.status == .pay_fail || self.status == .pay_success || self.status == .pay_ing || self.status == .finished {
            self.isHaveBotton = true
        }
//        else if (self.status == .cooked && self.type == "2" ) {
//            self.isHaveBotton = true
//        }
//        else if self.status == .finished && self.plaintStatus == "1" && self.evaluateStatus == "1" {
//            self.isHaveBotton = true
//        }
        else {
            self.isHaveBotton = false
        }
    
    }

}
