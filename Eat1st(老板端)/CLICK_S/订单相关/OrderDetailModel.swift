//
//  OrderDetailModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/31.
//

import UIKit
import SwiftyJSON


class OrderDetailModel: NSObject {
    
    
    ///订单状态 1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
    var status: OrderStatus = .unKnown
    ///状态文字
    var statusStr: String = ""
    ///订单类型1外卖 2自取 3堂食
    var deliveryType: String = ""

    ///订单流水号
    var dayNum: String = ""
    ///订单号
    var orderNum: String = ""
    
    ///当前订单的支付方式（-1未选择，1现金，2卡，3POS，4现金&POS）
    var paymentMethod: String = ""
    ///实际付款金额
    var payPrice: Double = 0
    
    /// 订单来源(0：Eat1st，1：Deliveroo，2：UberEats，3：JustEat)[
    var source: String = ""
    
    ///订单创建时间
    var createTime: String = ""
    
    
    var payTypeArr: [Double] = []
    
    var posPrice: Double = 0
    var cashPrice: Double = 0
    var cardPrice: Double = 0
    var cashWPrice: Double = 0
    var rechargePrice: Double = 0

    var orderListCell_H: CGFloat = 0
    var payTypeStr: String = ""
    
    
    ///订单ID
    var id: String = ""
    ///配送开始时间
    var startTime: String = ""
    ///配送结束时间
    var endTime: String = ""
    ///邮编
    var postCode: String = ""
    
    ///地址
    var address: String = ""
    var address_H: CGFloat = 0
    
    ///取消原因
    var cancelReason: String = ""
    

    ///订单备注
    var remarks: String = ""
    var remark_H: CGFloat = 0
    
    
    ///购买人姓名
    var perName: String = ""
    ///购买人电话
    var perPhone: String = ""
    ///购买人经度
    var lat: Double = 0
    ///购买人纬度
    var lng: Double = 0
    ///预定送餐时间
    var hopeTime: String = ""
    
    ///距离
    var distance: Double = 0
    
    
    ///商品实际金额
    var actualFee: Double = 0
    ///配送金额
    var deliveryFee: Double = 0
    ///服务费用
    var serviceFee: Double = 0
    ///包装费
    var packPrice: Double = 0
    ///菜品的优惠金额
    var dishesDiscountAmount: Double = 0
    ///优惠券抵扣金额
    var couponAmount: Double = 0
    ///折扣金额
    var discountAmount: Double = 0
    ///订单金额 减去折扣 不减钱包之前的价格
    var orderPrice: Double = 0
    ///优惠金额 钱包抵扣金额
    var walletPrice: Double = 0

    ///总金额
    var totalFee: Double = 0
    ///折扣比例
    var discountScale: String = ""
    ///是否有折扣 1有折扣，2无折扣
    var discountStatus: String = ""
    ///折扣说明
    var discountMsg: String = ""
    ///菜品是否有优惠 1无优惠 2有优惠
    var dishesDiscountType: String = ""
    ///是否有优惠券（1是，2否）
    var couponType: String = ""
    
    
    
    //购买的菜品
    var dishArr: [OrderDishModel] = []
    
    
    //赠送的菜品
    var giftList: [OrderDishModel] = []
    
    //满赠的菜品
    var fullGiftDish = OrderDishModel()
    
    
    var detailMoney_H: CGFloat = 0
    var discountMsg_H: CGFloat = 0
    
    
    
    
    func updateModel(json: JSON) {
        
        self.dayNum = json["orderDayNum"].stringValue
        self.orderNum = json["orderId"].stringValue
        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.statusStr = json["statusName"].stringValue
        self.deliveryType = json["deliveryType"].stringValue
        self.payPrice = json["payPrice"].doubleValue
        self.paymentMethod = json["payType"].stringValue
        self.source = json["source"].stringValue
        self.createTime = json["createTime"].stringValue
        
        posPrice = json["posPrice"].doubleValue
        cashPrice = json["cashPrice"].doubleValue
        rechargePrice = json["rechargePrice"].doubleValue
        cardPrice = json["cardPrice"].doubleValue
        cashWPrice = json["cashWPrice"].doubleValue
        
        payTypeArr = [cardPrice, cashPrice, cashWPrice, posPrice, rechargePrice]
        
        let count = (payTypeArr.filter { $0 != 0 }).count
        
        let typeNameArr = ["Card", "Cash", "WX", "Pos", "Wallet"]
        
        if count >= 2 {
            
            for (idx, price) in payTypeArr.enumerated() {
                if price != 0 {
                    
                    if payTypeStr == "" {
                        payTypeStr = typeNameArr[idx] + ": £" + D_2_STR(price)
                    } else {
                        payTypeStr = payTypeStr + "\n" + typeNameArr[idx] + ": £" + D_2_STR(price)
                    }
                }
            }
            orderListCell_H = 105 + payTypeStr.getTextHeigh(SFONT(14), 200)
            
        } else {
            orderListCell_H = 105
        }
        
        
        
        
        
       
        self.id = json["orderId"].stringValue
        self.address = json["addressResult"]["address"].stringValue
        
        self.address_H = address.getTextHeigh(SFONT(12), S_W - 60) + 15
        
        self.cancelReason = json["cancelReasonResult"]["reasonOther"].stringValue
        
        
        self.remarks = json["remark"].stringValue
        
        self.remark_H = remarks.getTextHeigh(BFONT(14), S_W - 170) + 14
        
        
        
        
        self.postCode = json["addressResult"]["postCode"].stringValue
        self.startTime = json["hopeTimeResult"]["startTime"].stringValue
        self.endTime = json["hopeTimeResult"]["endTime"].stringValue

        
        self.actualFee = json["dishesPrice"].doubleValue
        self.deliveryFee = json["deliveryPrice"].doubleValue
        self.totalFee = json["totalPrice"].doubleValue
        self.serviceFee = json["servicePrice"].doubleValue
        self.walletPrice = json["walletPrice"].doubleValue
        
        self.orderPrice = json["orderPrice"].doubleValue
        self.packPrice = json["packPrice"].doubleValue
        self.dishesDiscountAmount = json["dishesDiscountAmount"].doubleValue
        self.dishesDiscountType = json["dishesDiscountType"].stringValue
        self.couponAmount = json["couponAmount"].doubleValue
        self.couponType = json["couponType"].stringValue
        self.discountStatus = json["discountStatus"].stringValue
        self.discountScale = json["discountScale"].stringValue
        self.discountAmount = json["discountAmount"].doubleValue
        self.discountMsg = json["discountMsg"].stringValue
        
        
    
        

        

        self.perName = json["addressResult"]["name"].stringValue
        self.perPhone = json["addressResult"]["phone"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.distance = json["distance"].doubleValue
        self.lat = json["addressResult"]["lat"].doubleValue
        self.lng = json["addressResult"]["lng"].doubleValue
        
        
        


     
        
        var tArr1: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {
            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr1.append(model)
        }
        dishArr = tArr1
        
        var tArr2: [OrderDishModel] = []
        for jsonData in json["giftList"].arrayValue {
            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        giftList = tArr2

        
        self.fullGiftDish.nameStr = json["fullGiftResult"]["dishesName"].stringValue
        self.fullGiftDish.imageUrl = json["fullGiftResult"]["imageUrl"].stringValue
        

        if discountMsg == "" {
            self.discountMsg_H = 0
        } else {
            self.discountMsg_H = discountMsg.getTextHeigh(SFONT(10), S_W - 60) + 20
        }

        let arr = [actualFee, deliveryFee, serviceFee, packPrice, dishesDiscountAmount, couponAmount, discountAmount, orderPrice, walletPrice, payPrice].filter { $0 != 0 }

        self.detailMoney_H = 5 * 35 + CGFloat(arr.count) * 35 + discountMsg_H + 20
        
        
    }
    

}
