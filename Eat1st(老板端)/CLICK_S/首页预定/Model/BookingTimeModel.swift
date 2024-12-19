//
//  BookingTimeModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit
import SwiftyJSON


class BookingTimeModel: NSObject {

    ///当前时间是否过期（1否，2是）[...]
    var expire: Bool = false
    ///店铺预定编码[...]
    var reserveId: String = ""
    ///可预定人数[...]
    var reserveNum: Int = 0
    ///开始时间（HH:mm）{...}
    var reserveTime: String = ""
    
    func updateModel(json: JSON) {
    
        expire = json["expire"].stringValue == "2" ? true : false
        reserveId = json["reserveId"].stringValue
        reserveNum = json["reserveNum"].intValue
        reserveTime = json["reserveTime"].stringValue
    }
    
    
}
