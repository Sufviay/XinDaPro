//
//  ShareRecordModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit
import SwiftyJSON

class ShareRecordModel: NSObject {
    
    ///时间[...]
    var createTime: String = ""
    ///邮箱[...]
    var email: String = ""
    ///分享状态（1未注册，2已注册非会员，3分享成功）[...]
    var shareStatus: String = ""
    
    
    func updateModel(json: JSON) {
        createTime = json["createTime"].stringValue
        email = json["email"].stringValue
        shareStatus = json["shareStatus"].stringValue
    }
    

}
