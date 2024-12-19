//
//  BookingContentModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit
import SwiftyJSON

class BookingContentModel: NSObject {
    
    
    ///创建时间[...]
    var createTime: String = ""
    ///餐桌编码[...]
    var deskId: String = ""
    ///餐桌名称[...]
    var deskName: String = ""
    ///网页用户预定邮箱[...]
    var email: String = ""
    /// 联系人[...]
    var name: String = ""
    ///联系电话[...]
    var phone: String = ""
    ///预定日期（yyyy-MM-dd）[...]
    var reserveDate: String = ""
    ///预定人数[...]
    var reserveNum: String = ""
    ///预定状态（1待确认，2店家拒绝，3取消预定，4预定成功 5顾客已到））[...]
    var reserveStatus: String = ""
    ///开始时间（HH:mm）{...}
    var reserveTime: String = ""
    ///预定类型（1用户，2店家）[...]
    var reserveType: String = ""
    ///用户预定编码[...]
    var userReserveId: String = ""
    
    var reserveId: String = ""
    
    
    
    func updateModel(json: JSON) {
        
        createTime = json["createTime"].stringValue
        deskId = json["deskId"].stringValue
        deskName = json["deskName"].stringValue
        email = json["email"].stringValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        reserveDate = json["reserveDate"].stringValue
        reserveNum = json["reserveNum"].stringValue
        reserveStatus = json["reserveStatus"].stringValue
        reserveTime = json["reserveTime"].stringValue
        reserveType = json["reserveType"].stringValue
        userReserveId = json["userReserveId"].stringValue
        reserveId = json["reserveId"].stringValue
        
//        if reserveStatus == "1" || reserveStatus == "4" {
//            isHaveBut = true
//        } else {
//            isHaveBut = false
//        }
        
    }
    

}
