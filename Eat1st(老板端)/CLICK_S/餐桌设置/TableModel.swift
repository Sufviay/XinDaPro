//
//  TableModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit
import SwiftyJSON


class TableModel: NSObject {

    var deskId: String = ""
    var deskName: String = ""
    ///餐桌状态（1启用，2禁用）
    var status: String = ""
    
    func updateModel(json: JSON) {
        deskId = json["deskId"].stringValue
        deskName = json["deskName"].stringValue
        status = json["status"].stringValue
    }
    
}
