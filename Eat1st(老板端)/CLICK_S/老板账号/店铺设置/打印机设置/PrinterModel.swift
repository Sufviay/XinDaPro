//
//  PrinterModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import SwiftyJSON
import HandyJSON

class PrinterModel: HandyJSON {
    
    /// 是否点心（1否，2是）[...]
    var dimType: String = ""
    ///打印机IP[...]
    var ip: String = ""
    ///打印语言（1中文，2英文，3中文英文）[...]
    var langType: String = ""
    ///打印机简体名称[...]
    var nameCn: String = ""
    ///打印机英文名称[...]
    var nameEn: String = ""
    ///打印机繁体名称[...]
    var nameHk: String = ""
    ///主打印机（1否，2是）[...]
    var printMain: String = "1"
    ///打印份数（1一份，2两份，3三份，4四份）[...]
    var printNum: String = ""
    ///打印机类型（1热敏，2针式、3标签）[...]
    var printType: String = ""
    ///打印机备注[...]
    var remark: String = ""
    ///分开打印（1否，2是）[...]
    var splitType: String = ""
    ///打印机状态[...]
    var status: String = ""
    var printerId: String = ""
    /// 打印平台来源,半角逗号拼接code ( 1->Deliveroo, 2->UberEats, 3->JustEat)
    var printSource: String = ""
    
    
    required init() {}

   
//    var name: String = ""
//    var ip: String = ""
//    var printNum: String = ""
//    
//    ///启用禁用状态 1启用 2禁用
//    var status: String = ""
//    var remark: String = ""
//    ///打印机类型（1热敏，2针式）
//    var printType: String = ""
//    ///分开打印（1否，2是）
//    var splitType: String = ""
//    ///是否是主打印机 主打印机（1否，2是）
//    var printMain: String = ""
//    
//    func updateModel(json: JSON) {
//        
//        printerId = json["printerId"].stringValue
//        name = json["nameHk"].stringValue
//        ip = json["ip"].stringValue
//        printNum = json["printNum"].stringValue
//        status = json["status"].stringValue
//        remark = json["remark"].stringValue
//        
//        splitType = json["splitType"].stringValue
//        printType = json["printType"].stringValue
//        printMain = json["printMain"].stringValue
//        
//    }
    
}
