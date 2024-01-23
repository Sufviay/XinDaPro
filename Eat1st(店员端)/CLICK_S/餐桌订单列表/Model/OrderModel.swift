//
//  OrderModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit
import SwiftyJSON

class OrderModel: NSObject {
    ///订单编码[...]
    var orderId: String = ""
    ///订单流水号[...]
    var orderDayNum: String = ""
    ///订单渠道（1用户下单、2商家赠送、3商家下单）[...]
    var orderType: String = ""
    /// 支付方式（-1未选择，1现金，2卡，3POS，4现金&POS）[...]
    var payType: String = ""
    ///订单状态（8支付成功,9已接单,10已出餐,12配送中）[...]
    var status: String = ""
    ///订单支付金额[...]
    var payPrice: Double = 0
    ///订单金额[...]
    var orderPrice: Double = 0
    ///下单时间[...]
    var createTime: String = ""
    ///支付时间[...]
    var payTime: String = ""
    

    
    var isShow: Bool = false
    var dishesArr: [OrderDishModel] = []
    
    
    func updateModel(json: JSON) {
    
        orderId = json["orderId"].stringValue
        orderDayNum = json["orderDayNum"].stringValue
        orderType = json["orderType"].stringValue
        payType = json["payType"].stringValue
        status = json["status"].stringValue
        payPrice = json["payPrice"].doubleValue
        orderPrice = json["orderPrice"].doubleValue
        createTime = json["createTime"].stringValue
        payTime = json["payTime"].stringValue
        
    }
    

}
