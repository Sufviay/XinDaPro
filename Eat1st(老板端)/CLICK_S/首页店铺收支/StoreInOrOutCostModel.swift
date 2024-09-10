//
//  StoreInOrOutCostModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/7.
//

import UIKit
import SwiftyJSON


class StoreInOrOutCostModel: NSObject {
    
    ///外卖人数[...]
    var deliNum: Int = 0
    ///堂食数量[...]
    var dineNum: Int = 0
    ///订单数量[...]
    var orderNum: Int = 0
    ///订台记录[...]
    var reservation: Int = 0
    ///销售金额[...]
    var salesPrice: Double = 0
    ///小费[...]
    var tipsPrice: Double = 0
    ///堂食金额
    var dinePrice: Double = 0
    ///外卖金额
    var deliPrice: Double = 0
    
    
   
    ///电费（每月）[...]
    var electricPrice: Double = 0
    ///食物成本（每月）[...]
    var foodPrice: Double = 0
    ///天然气费（每月）[...]
    var gasPrice: Double = 0
    ///牌照费（每月）[...]
    var licensePrice: Double = 0
    /// 杂费（每月）[...]
    var otherPrice: Double = 0
    ///租金（每月）[...]
    var rentPrice: Double = 0
    ///税费（每月）[...]
    var taxPrice: Double = 0
    ///员工工资（每月）[...]
    var wagesPrice: Double = 0
    ///水费（每月）[...]
    var waterPrice: Double = 0
    
    var totalOut: Double = 0
    
    var inArr: [String] = ["", "", "", "", "", "", ""]
    
    var outArr: [String] = ["", "", "", "", "", "", "", "", "", ""]
    

    func updateMode_InCost(json: JSON) {
        
        salesPrice = json["salesPrice"].doubleValue
        orderNum = json["orderNum"].intValue
        
        dineNum = json["dineNum"].intValue
        deliNum = json["deliNum"].intValue
        orderNum = json["orderNum"].intValue
        reservation = json["reservation"].intValue
        tipsPrice = json["tipsPrice"].doubleValue
        dinePrice = json["dinePrice"].doubleValue
        deliPrice = json["deliPrice"].doubleValue
    
        
        inArr = ["£\(D_2_STR(salesPrice))", "£\(D_2_STR(dinePrice))", "£\(D_2_STR(deliPrice))", "£\(D_2_STR(tipsPrice))", String(dineNum), String(deliNum), String(reservation)]
        
    }
    
    
    
    
    func updateModel_OutCost(json: JSON, dateType: String) {
        
        electricPrice = numberBy(number: json["electricPrice"].doubleValue, type: dateType)
        foodPrice = numberBy(number: json["foodPrice"].doubleValue, type: dateType)
        gasPrice = numberBy(number: json["gasPrice"].doubleValue, type: dateType)
        licensePrice = numberBy(number: json["licensePrice"].doubleValue, type: dateType)
        otherPrice = numberBy(number: json["otherPrice"].doubleValue, type: dateType)
        rentPrice = numberBy(number: json["rentPrice"].doubleValue, type: dateType)
        taxPrice = numberBy(number: json["taxPrice"].doubleValue, type: dateType)
        wagesPrice = numberBy(number: json["wagesPrice"].doubleValue, type: dateType)
        waterPrice = numberBy(number: json["waterPrice"].doubleValue, type: dateType)
        
        totalOut = electricPrice + foodPrice + gasPrice + licensePrice + otherPrice + rentPrice + taxPrice + wagesPrice + waterPrice
        
        outArr = ["£\(D_2_STR(totalOut))", "£\(D_2_STR(foodPrice))", "£\(D_2_STR(wagesPrice))", "£\(D_2_STR(waterPrice))", "£\(D_2_STR(electricPrice))", "£\(D_2_STR(gasPrice))", "£\(D_2_STR(licensePrice))", "£\(D_2_STR(rentPrice))", "£\(D_2_STR(taxPrice))", "£\(D_2_STR(otherPrice))"]
        
    }
    
    private func numberBy(number: Double, type: String) -> Double {
        
        //日
        if type == "1" {
            
            return (number / Double(30))
        }
        //周
        if type == "2" {
            return (number / Double(4))
        }
        
        return number
        
    }
    
}
