//
//  OccupyListModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/12.
//

import UIKit
import SwiftyJSON


class OccupyListModel: NSObject {
    
    ///店铺编码[...]
    var storeId: String = ""
    ///店铺名称[...]
    var storeName: String = ""
    ///用户预定编码[...]
    var userReserveId: String = ""
    ///联系人[...]
    var name: String = ""
    ///联系电话[...]
    var phone: String = ""
    ///预定日期（yyyy-MM-dd）[...]
    var reserveDate: String = ""
    ///外卖结束时间（HH:mm）{...}
    var reserveTime: String = ""
    ///预定人数[...]
    var reserveNum: String = ""
    ///预定状态（1待确认，2店家拒绝，3取消预定，4预定成功）[...]
    var reserveStatus: String = ""
    
    

    func updateModel(json: JSON) {
        storeId = json["storeId"].stringValue
        storeName = json["storeName"].stringValue
        userReserveId = json["userReserveId"].stringValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        reserveDate = json["reserveDate"].stringValue
        reserveTime = json["reserveTime"].stringValue
        reserveNum = json["reserveNum"].stringValue
        reserveStatus = json["reserveStatus"].stringValue
        
    }
    
    
}
