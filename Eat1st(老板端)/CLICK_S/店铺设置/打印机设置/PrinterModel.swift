//
//  PrinterModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import SwiftyJSON

class PrinterModel: NSObject {

    var printerId: String = ""
    var name: String = ""
    var ip: String = ""
    var printNum: String = ""
    
    ///启用禁用状态 1启用 2禁用
    var status: String = ""
    var remark: String = ""
    
    func updateModel(json: JSON) {
        
        printerId = json["printerId"].stringValue
        name = json["nameHk"].stringValue
        ip = json["ip"].stringValue
        printNum = json["printNum"].stringValue
        status = json["status"].stringValue
        remark = json["remark"].stringValue
        
    }
    
}
