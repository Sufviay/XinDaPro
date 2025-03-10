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
    
    
    var titStrArr: [String] = ["Type", "Sales", "Revenue", "Card", "Cash", "POS", "WX", "Wallet Spent(S)", "Top up(R)", "Cash On Hand", "Delivery", "Collection", "Dine-in"]
    
    var numberArr: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    var priceArr: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    
    
    required init() {}
    
    
    func dealModel()  {
        Cash_On_Hand = cashPrice + rechargePrice
        
        numberArr = ["Total", String(salesNum), String(allNum), String(cardNum), String(cashNum), String(posNum), String(cashWNum), String(consumeNum), String(rechargeNum), "", String(deliveryNum), String(collectionNum), String(dineInNum), ""]
        
        priceArr = ["Amount", "£ " + D_2_STR(salesPrice), "£ " + D_2_STR(allPrice), "£ " + D_2_STR(cardPrice), "£ " + D_2_STR(cashPrice), "£ " + D_2_STR(posPrice), "£ " + D_2_STR(cashWPrice), "£ " + D_2_STR(consumePrice), "£ " + D_2_STR(rechargePrice), "£ " + D_2_STR(Cash_On_Hand), "£ " + D_2_STR(deliveryPrice), "£ " + D_2_STR(collectionPrice), "£ " + D_2_STR(dineInPrice)]
        
    }
    
}
