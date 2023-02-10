//
//  MonthSalesModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/9/2.
//

import UIKit
import SwiftyJSON


class MonthSalesModel: NSObject {

    var salesNum: Int = 0
    var week: String = ""
    
    func updateModel(json: JSON) {
        self.salesNum = json["salesNum"].intValue
        self.week = json["week"].stringValue
    }
    
}
