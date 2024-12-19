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
    ///打印机类型（1热敏，2针式）
    var printType: String = ""
    ///分开打印（1否，2是）
    var splitType: String = ""
    ///是否是主打印机 主打印机（1否，2是）
    var printMain: String = ""
    
    func updateModel(json: JSON) {
        
        printerId = json["printerId"].stringValue
        name = json["nameHk"].stringValue
        ip = json["ip"].stringValue
        printNum = json["printNum"].stringValue
        status = json["status"].stringValue
        remark = json["remark"].stringValue
        
        splitType = json["splitType"].stringValue
        printType = json["printType"].stringValue
        printMain = json["printMain"].stringValue
        
    }
    
}
