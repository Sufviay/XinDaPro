//
//  StoreSummaryModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/12/31.
//

import UIKit
import SwiftyJSON
import HandyJSON


class StoreSummaryModel: HandyJSON {

    ///总数量（不含充值）[...]
    var salesNum: Int = 0
    ///总金额（不含充值）[...]
    var salesPrice: Double = 0
    
    ///订单总数量[...]
    var allNum: Int = 0
    ///订单总金额[...]
    var allPrice: Double = 0
    
    ///税总金额（不含充值）[...]
    var allVatPrice: Double = 0
    

    ///卡订单总数量[...]
    var cardNum: Int = 0
    ///卡订单总金额[...]
    var cardPrice: Double = 0
    
    ///现金订单总数量[...]
    var cashNum: Int = 0
    /// 现金订单总金额[...]
    var cashPrice: Double = 0
    
    ///Pos订单总数量[...]
    var posNum: Int = 0
    ///Pos订单总金额[...]
    var posPrice: Double = 0
    
    ///微信订单销量[...]
    var cashWNum: Int = 0
    /// 微信订单销售额[...]
    var cashWPrice: Double = 0
    
    ///充值消费订单总数量[...]
    var consumeNum: Int = 0
    ///充值消费总金额[...]
    var consumePrice: Double = 0
    
    ///充值数量[...]
    var rechargeNum: Int = 0
    ///充值金额[...]
    var rechargePrice: Double = 0
    
    
    ///Cash On Hand = cashPrice + rechargePrice
    var Cash_On_Hand: Double = 0
    
    ///外卖订单总数量[...]
    var deliveryNum: Int = 0
    /// 外卖订单总金额[...]
    var deliveryPrice: Double = 0
    
    ///自取订单数量[...]
    var collectionNum: Int = 0
    ///自取订单总金额[...]
    var collectionPrice: Double = 0
    
    ///堂食订单数量[...]
    var dineInNum: Int = 0
    ///堂食订单总金额[...]
    var dineInPrice: Double = 0
    
    
    ///Uber
    var uberNum: Int = 0
    var uberPrice: Double = 0

    ///deliveroo
    var deliverooNum: Int = 0
    var deliverooPrice: Double = 0
    
    ///小费
    var deliverooTipsPrice: Double = 0
    var uberTipsPrice: Double = 0

    ///税号 有稅号就有稅
    var vatNo: String = ""
    ///未结算订单数量
    var unpaidOrderNum: Int = 0
    ///未结算订单金额
    var unpaidOrderPrice: Double = 0
    
    var numberLine: Int = 19
    
    
    
    
    var titStrArr: [String] = ["Type", "Sales", "Revenue", "Card", "Cash", "POS", "WX", "Wallet Spent(S)", "Top up(R)", "Cash On Hand", "Delivery", "Collection", "Dine-in", "Unpaid", "VAT", "Uber Eats", "Uber Eats Tips", "Deliveroo", "Deliveroo Tips"]
    
    var numberArr: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var priceArr: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    
    
    required init() {}
    
    
    func dealModel()  {
        Cash_On_Hand = cashPrice + rechargePrice
        
        numberArr = ["Total", String(salesNum), String(allNum), String(cardNum), String(cashNum), String(posNum), String(cashWNum), String(consumeNum), String(rechargeNum), "", String(deliveryNum), String(collectionNum), String(dineInNum), String(unpaidOrderNum), "", String(uberNum), "", String(deliverooNum), ""]
        
        priceArr = ["Amount", "£ " + D_2_STR(salesPrice), "£ " + D_2_STR(allPrice), "£ " + D_2_STR(cardPrice), "£ " + D_2_STR(cashPrice), "£ " + D_2_STR(posPrice), "£ " + D_2_STR(cashWPrice), "£ " + D_2_STR(consumePrice), "£ " + D_2_STR(rechargePrice), "£ " + D_2_STR(Cash_On_Hand), "£ " + D_2_STR(deliveryPrice), "£ " + D_2_STR(collectionPrice), "£ " + D_2_STR(dineInPrice), "£ " + D_2_STR(unpaidOrderPrice), "£ " + D_2_STR(allVatPrice), "£ " + D_2_STR(uberPrice), "£ " + D_2_STR(uberTipsPrice), "£ " + D_2_STR(deliverooPrice), "£ " + D_2_STR(deliverooTipsPrice)]
        
        
        if vatNo == "" && unpaidOrderNum == 0 {
            numberLine = 17
        }
        
        if vatNo == "" && unpaidOrderNum != 0 {
            numberLine = 18
        }
        
        if vatNo != "" && unpaidOrderNum == 0 {
            numberLine = 18
        }
        
        
    }
    
//    func updateModelByUber(json: JSON) {
//        
//        uberStatus =  json["data"]["status"].stringValue
//        
//        if uberStatus == "2" {
//            uberNum = json["data"]["uberNums"].intValue
//            uberPrice = json["data"]["uberPrice"].doubleValue
//            
//            uberRefundNum = json["data"]["uberRefundNum"].intValue
//            uberRefundPrice = json["data"]["uberRefundPrice"].doubleValue
//            
//            numberArr[15] = String(uberNum)
//            priceArr[15] = "£ " + D_2_STR(uberPrice)
//            
//            numberArr[16] = String(uberRefundNum)
//            priceArr[16] = "£ " + D_2_STR(uberRefundPrice)
//            
//            
//        }
//        
//        if uberStatus == "1" {
//            numberArr[15] = ""
//            priceArr[15] = "Querying".local
//            
//            numberArr[16] = ""
//            priceArr[16] = "Querying".local
//            
//            
//        }
//        
//        if uberStatus == "-1" || uberStatus == "-2" {
//            numberArr[15] = "-"
//            priceArr[15] = "-"
//            
//            numberArr[16] = "-"
//            priceArr[16] = "-"
//
//            
//        }
//        
//    }
    
}
