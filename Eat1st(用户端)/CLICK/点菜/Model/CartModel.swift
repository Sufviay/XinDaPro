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
    //var storeID: String = ""
    
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
    ///是否有优惠券
    var isHaveCoupon: Bool = false
    
    
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
    ///余额支付金额
    var rechargePrice: Double = 0
    ///税的金额
    var vatAmount: Double = 0
    
    
    

    
    ///赠送优惠券需达到的订单数
    var giveCouponReachNum: Int = 0
    ///赠送优惠券已有的订单数
    var giveCouponHaveNum: Int = 0
    ///赠送的优惠券金额
    var giveCouponPrice: String = ""
    ///赠送需要达到的订单金额
    var giveCouponOrderPrice: String = ""
    
    
    ///满赠菜品
    var fullGiftList: [FullGiftModel] = []
    ///是否可以选择满赠菜品
    var canChooseFullGift: Bool = false
    
    
    var discountMsg_H: CGFloat = 0
    var confirmMoney_H: CGFloat = 0
    

    
    
    ///下单的菜品
    var dishArr: [CartDishModel] = []
    ///优惠券菜品
    var couponDish = CartDishModel()
    
    ///店铺种类（1外卖店，2超市）
    var storeKind: String = ""
    ///超市预约时间
    var reserveDateList: [String] = []
    
    
    
    
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
        //self.storeID = json["storeId"].stringValue
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
        self.rechargePrice = json["rechargePrice"].doubleValue
        self.storeKind = json["storeKind"].stringValue
        
        
        if type == "3" {
            self.vatAmount = json["vatPirce"].doubleValue
        } else {
            self.vatAmount = json["vatAmount"].doubleValue
        }
        
        
    
        var timeArr: [String] = []
        for jsondata in json["reserveDateList"].arrayValue {
            timeArr.append(jsondata["date"].stringValue)
        }
        self.reserveDateList = timeArr
        
        
        self.giveCouponReachNum = json["fiveGiveCouponResult"]["reachNum"].intValue
        self.giveCouponHaveNum = json["fiveGiveCouponResult"]["haveNum"].intValue
        self.giveCouponPrice = D_2_STR(json["fiveGiveCouponResult"]["couponPrice"].doubleValue)
        self.giveCouponOrderPrice = D_2_STR(json["fiveGiveCouponResult"]["orderReachPrice"].doubleValue)
        

        
        var tArr: [CartDishModel] = []
        for jsonData in json["orderDishesList"].arrayValue {
            let model = CartDishModel()
            model.updateConfirmModel(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr
        
        self.couponDish.updateModel(json: json["orderCoupon"])
        
        
        var tArr1: [FullGiftModel] = []
        for jsonData in json["orderFullGiftList"].arrayValue {
            let model = FullGiftModel()
            model.updateModel(json: jsonData)
            tArr1.append(model)
        }
        self.fullGiftList = tArr1
        

        if (fullGiftList.filter { $0.chooseType == "2" }).count == 0 {
            canChooseFullGift = false
        } else {
            canChooseFullGift = true
        }
        
        
        if discountMsg == "" {
            self.discountMsg_H = 0
        } else {
            self.discountMsg_H = discountMsg.getTextHeigh(SFONT(10), S_W - 60) + 20
        }
        
        if type == "1" {
            //外卖
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee, rechargePrice, vatAmount].filter { $0 != 0 }
            self.confirmMoney_H = 3 * 30 +  CGFloat(arr.count) * 30 + discountMsg_H + 20
        } else {
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee, deliverFee, rechargePrice, vatAmount].filter { $0 != 0 }
            self.confirmMoney_H = 2 * 30 +  CGFloat(arr.count) * 30 + discountMsg_H + 20
        }
 

    }
    
    
    
    func updateGiftDishesID(selectGiftID: String) -> String {
        
        if selectGiftID != "" {
            
            for giftModel in fullGiftList {
                
                for dishModel in giftModel.dishesList {
                    
                    if selectGiftID == dishModel.giftDishesId {
                        
                        if giftModel.chooseType == "1" {
                            return ""
                        } else {
                            return selectGiftID
                        }
                    }
                }
            }
        }
        return ""
        
        
    }
    
    
}


