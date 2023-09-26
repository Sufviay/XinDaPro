//
//  CartModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/25.
//

import UIKit
import SwiftyJSON

class ConfirmOrderCartModel: NSObject {


    ///店铺名
    var storeName: String = ""
    
    ///店铺电话
    var storePhone: String = ""
    
    ///店铺ID
    var storeID: String = ""
    
    ///繁忙类型 1繁忙 2不繁忙
    var busyType: String = ""
    ///繁忙时间
    var busyTime: String = ""
    
    
    ///经纬度
    var lat: String = ""
    var lng: String = ""

    ///配送状态（1未上传，2坐标错误，3支持，4外卖超出配送范围，5外卖菜品金额小于最低配送金额）
    var deliveryType: String = ""
    var deliveryMsg: String = ""
    
    ///最大配送范围 1609.344
    var maxPSDis: Double = 0
    
    ///预定说明
    var reserveMsg: String = ""
    
    
    ///整单的折扣金额
    var discountAmount: Double = 0
    ///整单的折扣比例
    var discountScale: String = ""
    ///是否有整单折扣 1有折扣，2无折扣
    var discountStatus: String = ""
    ///整单折扣说明
    var discountMsg: String = ""
    
    
    ///菜品的优惠金额
    var dishesDiscountAmount: Double = 0
    ///菜品是否有优惠 1无优惠 2有优惠
    var dishesDiscountType: String = ""
    
    ///优惠券类型 是否有优惠券（1是，2否）
    var couponType: String = ""
    ///优惠券抵扣金额
    var couponAmount: Double = 0
    
    
    ///是否有可用优惠券
    var isHaveCanUseCoupon: Bool = false
    
    
    
    ///支付弹窗的信息
    ///是否可以现金付款或是否可以在线付款 1现金 2卡  3都行 4不需要支付
    var paymentSupport: String = ""
    ///钱包抵扣的金额
    var deductionAmount: Double = 0
    ///实际支付的金额
    var payPrice: Double = 0
    ///菜的价 格购物车商品的总金额（未计算优惠和配送费的）
    var subFee: Double = 0
    ///购物车商品配送费，如果是自取，为0
    var deliverFee: Double = 0
    ///商品的服务费
    var serviceFee: Double = 0
    ///订单价格 减折扣 不减钱包
    var orderPrice: Double = 0
    ///包装费
    var packPrice: Double = 0
    

    
    //    ///购物车实际支付金额
    //    var total: Double = 0

    
    
    var discountMsg_H: CGFloat = 0
    var confirmMoney_H: CGFloat = 0
    

    
    
    ///下单的菜品
    var dishArr: [CartDishModel] = []
    ///优惠券菜品
    var couponDish = CartDishModel()
    
    
    
    func updateModel(json: JSON, type: String) {
        self.paymentSupport = json["payType"].stringValue
        self.deductionAmount = json["deductionAmount"].doubleValue
        self.deliverFee = json["deliveryPrice"].doubleValue
        self.payPrice = json["payAmount"].doubleValue
        self.subFee = json["dishesPrice"].doubleValue
        self.serviceFee = json["servicePrice"].doubleValue
        //self.total = json["totalPrice"].doubleValue
        self.orderPrice = json["orderPrice"].doubleValue
        
        self.reserveMsg = json["reserveMsg"].stringValue
        self.discountStatus = json["discountStatus"].stringValue
        self.discountScale = json["discountScale"].stringValue
        self.discountAmount = json["discountAmount"].doubleValue
        self.discountMsg = json["discountMsg"].stringValue
        
        
        self.deliveryType = json["deliveryType"].stringValue
        self.deliveryMsg = json["deliveryMsg"].stringValue
        self.storeName = json["storeName"].stringValue
        self.storeID = json["storeId"].stringValue
        self.storePhone = json["phone"].stringValue
        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
        self.maxPSDis = json["maxDistance"].doubleValue
        
        self.busyType = json["busyType"].stringValue
        self.busyTime = json["busyTime"].stringValue
        
        self.dishesDiscountAmount = json["dishesDiscountAmount"].doubleValue
        self.dishesDiscountType = json["dishesDiscountType"].stringValue
        
        self.couponType = json["couponType"].stringValue
        self.couponAmount = json["couponAmount"].doubleValue
        
        self.packPrice = json["packPrice"].doubleValue

        
        var tArr: [CartDishModel] = []
        for jsonData in json["orderDishesList"].arrayValue {
            let model = CartDishModel()
            model.updateConfirmModel(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr
        
        self.couponDish.updateModel(json: json["orderCoupon"])
        
        
        if discountMsg == "" {
            self.discountMsg_H = 0
        } else {
            self.discountMsg_H = discountMsg.getTextHeigh(SFONT(10), S_W - 60) + 20
        }
        
        if type == "1" {
            //外卖
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee].filter { $0 != 0 }
            self.confirmMoney_H = 3 * 30 +  CGFloat(arr.count) * 30 + discountMsg_H + 20
        } else {
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee, deliverFee].filter { $0 != 0 }
            self.confirmMoney_H = 2 * 30 +  CGFloat(arr.count) * 30 + discountMsg_H + 20
        }
 

    }
    
    
}


