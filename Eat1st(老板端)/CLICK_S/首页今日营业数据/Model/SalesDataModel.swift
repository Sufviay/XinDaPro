//
//  SalesDataModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/7.
//

import UIKit
import HandyJSON
import SwiftyJSON


class SalesDataModel: HandyJSON {
    
    /// 周几[...]
    var week: String = ""
    
    var weekStr: String = ""
    
    ///堂食成人人数[...]
    var adultNum: Int = 0
    ///堂食儿童人数[...]
    var childNum: Int = 0
    ///堂食总人数[...]
    var totalUserNums: Int = 0
    ///上期-堂食总人数[...]
    var prevTotalUserNums: Int = 0
    ///上期-堂食总人数类型（1上涨，2相等，3下降）
    var prevTotalUserNumsType: String = ""
    
    //var totalUserCompare: Int = 0
    
    
    
    ///堂食人均金额[...]
    var averagePrice: Double = 0
    ///上期-堂食人均金额[...]
    var prevAveragePrice: Double = 0
    ///上期-堂食人均金额类型（1上涨，2相等，3下降）[...]
    var prevAveragePriceType: String = ""
    
    //var averagePriceCompare: Double = 0
    

    /// 堂食未结账金额[...]
    var notSettlePrice: Double = 0
//    ///上期-未结账金额类型（1上涨，2相等，3下降）[...]
//    var prevNotSettlePriceType: String = ""
//    ///上期-未结账金额[...]
//    var prevNotSettlePrice: Double = 0
    
    
    ///堂食未结账单数[...]
    var notSettleOrders: Int = 0
//    ///上期-未结账单数[...]
//    var prevNotSettleOrders: Int = 0
//    ///上期-未结账单数类型（1上涨，2相等，3下降）[...]
//    var prevNotSettleOrdersType: String = ""
    
    
    
    ///已结账金额[...]
    var settlePrice: Double = 0
    ///堂食上期-已结账金额[...]
    var prevSettlePrice: Double = 0
    ///上期-已结账金额类型（1上涨，2相等，3下降）[...]
    var prevSettlePriceType: String = ""
    
    //var settlePriceCompare: Double = 0
    
    
    
    ///已结账单数[...]
    var settleOrders: Int = 0
    ///上期-已结账单数[...]
    var prevSettleOrders: Int = 0
    ///上期-已结账单数类型（1上涨，2相等，3下降）[...]
    var prevSettleOrdersType: String = ""
    
    //var settleOrderCompare: Int = 0

    
    ///总营业额[...]
    var totalPrice: Double = 0
    ///上期-总营业额[...]
    var prevTotalPrice: Double = 0
    ///上期-总营业额类型（1上涨，2相等，3下降）[...]
    var prevTotalPriceType: String = ""
    
    //var totalPriceCompare: Double = 0
    
    
    ///总订单数[...]
    var totalOrders: Int = 0
    ///上期-总订单数[...]
    var prevTotalOrders: Int = 0
    ///上期-总订单数类型（1上涨，2相等，3下降）[...]
    var prevTotalOrdersType: String = ""
    
    //var totalOrdersCompare: Int = 0
    
    
    
    ///今日桌数[...]
    var curDeskNums: Int = 0
    ///比较上周桌数[...]
    var prevDeskNums: Int = 0
    ///桌数类型（1上涨，2相等，3下降）[...]
    var deskNumsType: String = ""
    
    //var deskNumCompare: Int = 0
    
    
    ///今日桌均价[...]
    var curDeskPrice: Double = 0
    ///比较上周桌均价[...]
    var prevDeskPrice: Double = 0
    ///桌均价类型（1上涨，2相等，3下降）[...]
    var deskPriceType: String = ""
    
    //var deskPriceCompare: Double = 0
    
    
    var date: String = ""
    
    
    
    /// 外卖未结账金额[...]
    var de_notSettlePrice: Double = 0
    ///外卖未结账单数[...]
    var de_notSettleOrders: Int = 0

    
    ///外卖总营业额
    var de_totalPrice: Double = 0
    ///上期-总营业额[...]
    var de_prevTotalPrice: Double = 0
    ///上期-总营业额类型（1上涨，2相等，3下降）[...]
    var de_prevTotalPriceType: String = ""

    //var de_totalPriceCompare: Double = 0
    
    
    ///外卖总订单
    var de_totalOrders: Int = 0
    ///上期-总订单数[...]
    var de_prevTotalOrders: Int = 0
    ///上期-总订单数类型（1上涨，2相等，3下降）[...]
    var de_prevTotalOrdersType: String = ""

    //var de_totalOrdersCompare: Int = 0
    
    
    
    ///Uber
    ///查询状态  -1异常 1查询中 2已返回
//    var uber_status: String = "1"
    ///总订单
    var uberNums: Int = 0
    ///上期-总订单数[...]
    var uberPrevNums: Int = 0
    ///上期-总订单数类型（1上涨，2相等，3下降）[...]
    var uberPrevNumsType: String = ""

    
    

    var uberPrice: Double = 0
    ///上期-总营业额[...]
    var uberPrevPrice: Double = 0
    ///上期-总营业额类型（1上涨，2相等，3下降）[...]
    var uberPrevPriceType: String = ""

//    ///订单退款数量
//    var uber_RefundNum: Int = 0
//    ///uber订单退款金额
//    var uber_RefundPrice: Double = 0
    
    
    
    ///deliveroo
    
    ///deliveroo订单数[...]
    var deliverooNums: Int = 0
    ///deliveroo上期订单数[...]
    var deliverooPrevNums: Int = 0
    ///deliveroo上期订单类型（1上涨，2相等，3下降）[...]
    var deliverooPrevNumsType: String = ""
    
    ///deliveroo上期订单金额[...]
    var deliverooPrevPrice: Double = 0
    ///deliveroo上期订单金额类型（1上涨，2相等，3下降）[...]
    var deliverooPrevPriceType: String = ""
    ///deliveroo订单金额[...]
    var deliverooPrice: Double = 0

    
    
    

    
    required init() {}
    
    
    func updateModel_dine() {
        
        
//        let num1 = totalUserNums - prevTotalUserNums
//        totalUserCompare = num1 >= 0 ? num1 : -num1
//    
//        let num2 = settlePrice - prevSettlePrice
//        settlePriceCompare = num2 >= 0 ? num2 : -num2
//        
//        let num3 = settleOrders - prevSettleOrders
//        settleOrderCompare = num3 >= 0 ? num3 : -num3
//
//        let num4 = totalOrders - prevTotalOrders
//        totalOrdersCompare = num4 >= 0 ? num4 : -num4
//
//        let num5 = totalPrice - prevTotalPrice
//        totalPriceCompare = num5 >= 0 ? num5 : -num5
//
//        let num6 = averagePrice - prevAveragePrice
//        averagePriceCompare = num6 >= 0 ? num6 : -num6
//        
//        
//        let num7 = curDeskNums - prevDeskNums
//        deskNumCompare = num7 >= 0 ? num7 : -num7
//        
//        let num8 = curDeskPrice - prevDeskPrice
//        deskPriceCompare = num8 >= 0 ? num8 : -num8
        
        
        if week == "1" {
            weekStr = "Mon".local
        }
        
        if week == "2" {
            weekStr = "Tue".local
        }

        if week == "3" {
            weekStr = "Wed".local
        }

        if week == "4" {
            weekStr = "Thu".local
        }

        if week == "5" {
            weekStr = "Fri".local
        }

        if week == "6" {
            weekStr = "Sat".local
        }

        if week == "7" {
            weekStr = "Sun".local
        }

        
    }
    
    
    func updateModel_de(json: JSON) {
        de_totalOrders = json["settleOrders"].intValue
        de_prevTotalOrders = json["prevSettleOrders"].intValue
        de_prevTotalOrdersType = json["prevSettleOrdersType"].stringValue
        
//        let num2 = de_totalOrders - de_prevTotalOrders
//        de_totalOrdersCompare = num2 >= 0 ? num2 : -num2
        
        
        de_totalPrice = json["settlePrice"].doubleValue
        de_prevTotalPrice = json["prevSettlePrice"].doubleValue
        de_prevTotalPriceType = json["prevSettlePriceType"].stringValue
        
        de_notSettlePrice = json["de_notSettlePrice"].doubleValue
        de_notSettleOrders = json["notSettleOrders"].intValue
        
    }
    
    
    
//    func updateModel_Uber(json: JSON) {
//        
//        uber_status = json["status"].stringValue
//        
//        if uber_status == "2" {
//            uber_totalPrice = json["uberPrice"].doubleValue
//            uber_prevTotalPrice = json["uberPrevPrice"].doubleValue
//            uber_prevTotalPriceType = json["uberPrevPriceType"].stringValue
//            
//            uber_prevTotalOrders = json["uberPrevNums"].intValue
//            uber_totalOrders = json["uberNums"].intValue
//            uber_prevTotalOrdersType = json["uberPrevNumsType"].stringValue
//            
//            uber_RefundNum = json["uberRefundNum"].intValue
//            uber_RefundPrice = json["uberRefundPrice"].doubleValue
//        }
//    }
}
