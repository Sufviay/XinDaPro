//
//  UserModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/18.
//

import UIKit
import SwiftyJSON

class UserModel: NSObject {
    
    ///生日[...]
    var birthday: String = ""
    ///邮箱[...]
    var email: String = ""
    ///最后一次下单时间[...]
    var lastOrderTime: String = ""
    ///登录时间[...]
    var loginTime: String = ""
    ///用户昵称[...]
    var nickName: String = ""
    ///下单金额[...]
    var orderAmount: Double = 0
    ///下单数[...]
    var orderNum: String = ""
    ///手机号码[...]
    var phone: String = ""
    /// 邮编[...]
    var postCode: String = ""
    ///用户状态（1正常，2申请注销，3禁用，4平台注销，5用户注销）[...]
    var status: String = ""
    ///用户id[...]
    var userId: String = ""
    
    var tagList: [CustomerTagModel] = []
    
    var tagStr: String = ""
    var numberStr: String = "--"
    
    var listCell_H: CGFloat = 0
    
    
    func updateModel(json: JSON) {
        birthday = json["birthday"].stringValue
        email = json["email"].stringValue
        lastOrderTime = json["lastOrderTime"].stringValue
        loginTime = json["loginTime"].stringValue
        nickName = json["nickName"].stringValue
        orderAmount = json["orderAmount"].doubleValue
        orderNum = json["orderNum"].stringValue
        phone = json["phone"].stringValue
        postCode = json["postCode"].stringValue
        userId = json["userId"].stringValue
        status = json["status"]["id"].stringValue
        
        var tStr = ""
        var tarr: [CustomerTagModel] = []
        for (idx, jsonData) in json["tagList"].arrayValue.enumerated() {
            
            let model = CustomerTagModel()
            model.updateModel(json: jsonData)
            tarr.append(model)
            
            if idx == 0 {
                tStr = model.name1
            } else {
                tStr = tStr + ", " + model.name1
            }
            
        }
        tagList = tarr
        tagStr = tStr
        
        
        if phone != "" {
            numberStr = phone
        } else if email != "" && phone == "" {
            numberStr = email
        }
        
        let h1 = numberStr.getTextHeigh(TXT_1, (S_W * 3 / 8) - 25)
        let h2 = tagStr.getTextHeigh(TXT_1, (S_W * 3 / 8) - 25)
        
        listCell_H = (h1 + h2 + 40 + 10) > 90 ? (h1 + h2 + 40 + 10) : 90
        
    }

}
