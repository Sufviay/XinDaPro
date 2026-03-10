//
//  incomRecordModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/5.
//

import UIKit
import SwiftyJSON

class IncomeRecordModel: NSObject {

    ///统计周期开始时间[...]
    var beginTime: String = ""
    ///统计周期结束时间[...]
    var endTime: String = ""
    ///已结佣金[...]
    var commission: Double = 0
    /// 订单数量[...]
    var orderCount: Int = 0
    ///店铺平台结算明细[...]
    var detailList: [IncomePTDetailModel] = []
    
    var storeName: String = ""
    var storeId: String = ""
    
    
    func updateModel(json: JSON) {
        beginTime = json["beginTime"].stringValue
        endTime = json["endTime"].stringValue
        commission = json["commission"].doubleValue
        orderCount = json["orderCount"].intValue
        storeName = json["storeName"].stringValue
        storeId = json["storeId"].stringValue
        
        var tArr: [IncomePTDetailModel] = []
        for jsonData in json["detailList"].arrayValue {
            let model = IncomePTDetailModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        detailList = tArr
        
    }
    
    
}


class IncomeDetailModel: NSObject {
    
    var storeName: String = ""
    var storeId: String = ""
    var storeCommission: Double = 0
    var platform: [IncomePTDetailModel] = []
    
    
    
    func updateModel(recordModel: IncomeRecordModel) {
        storeName = recordModel.storeName
        storeId = recordModel.storeId
        storeCommission = recordModel.commission
        platform = recordModel.detailList
    }
    
    
    func updateModel(json: JSON) {
        storeName = json["storeName"].stringValue
        storeId = json["storeId"].stringValue
        storeCommission = json["storeCommission"].doubleValue
        
        var tarr: [IncomePTDetailModel] = []
        for jsonData in json["detailList"].arrayValue {
            let model = IncomePTDetailModel()
            model.updateModel(json: jsonData)
            tarr.append(model)
        }
        platform = tarr
        
    }
    
}


class IncomePTDetailModel: NSObject {
    
    ///抽成金额[...]
    var amount: Double = 0
    ///每单抽成金额[...]
    var commissionValue: Double = 0

    var id: String = ""
    ///平台订单总数[...]
    var orderCount: Int = 0
    ///平台 0:eat1st,1:deliveroo,2:UberEats,3:justEat[...]
    var platform: String = ""
//    ///店铺code[...]
//    var storeCode: String = ""
//    ///店铺id[...]
//    var storeId: String = ""
//    ///店铺名称[...]
//    var storeName: String = ""
//    ///结算Id[...]
//    var summaryId: String = ""
    
    func updateModel(json: JSON) {
        amount = json["amount"].doubleValue
        commissionValue = json["commissionValue"].doubleValue
        id = json["id"].stringValue
        orderCount = json["orderCount"].intValue
        platform = json["platform"]["wholeName"].stringValue
//        storeCode = json["storeCode"].stringValue
//        storeName = json["storeName"].stringValue
//        summaryId = json["summaryId"].stringValue
    }
    
}




