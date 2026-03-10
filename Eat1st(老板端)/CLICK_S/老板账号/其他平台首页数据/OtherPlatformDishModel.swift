//
//  OtherPlatformDishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/25.
//

import UIKit
import SwiftyJSON

class OtherPlatformDishModel: NSObject {
    
    var name: String = ""
    var salesNum: Int = 0
    
    func updateModel(json: JSON) {
        name = json["name"].stringValue
        salesNum = json["salesNum"].intValue
        
    }
}
