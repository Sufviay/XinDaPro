//
//  GiftVoucherModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/12.
//

import UIKit
import SwiftyJSON


class GiftVoucherModel: NSObject {

    var id: String = ""
    var amount: Double = 0
    
    ///购买时间
    var createTime: String = ""
    ///赠送状态 1未领取，2已领取
    var giftStatus: String = ""
    ///已购买礼品券编码
    var rechargeGiftId: String = ""
    ///领取人姓名
    var takeName: String = ""
    ///领取人手机号
    var takePhone: String = ""
    
    
    
    func updateModel(json: JSON) {
        id = json["id"].stringValue
        amount = json["amount"].doubleValue
        
        createTime = json["createTime"].stringValue
        giftStatus = json["giftStatus"].stringValue
        rechargeGiftId = json["rechargeGiftId"].stringValue
        takeName = json["takeName"].stringValue
        takePhone = json["takePhone"].stringValue        
    }
    
}
