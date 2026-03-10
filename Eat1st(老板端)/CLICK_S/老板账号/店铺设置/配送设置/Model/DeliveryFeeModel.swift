//
//  DeliveryFeeModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/11.
//

import UIKit
import SwiftyJSON


class DeliveryFeeModel: NSObject {

    var amount: Float = 0
    var distance: Float = 0
    var postCode: String = ""
    var id: String = ""
    var type: String = ""
    
    
    func updateModel(json: JSON) {
        self.amount = json["amount"].floatValue
        self.distance = json["distance"].floatValue
        self.postCode = json["postCode"].stringValue
        self.id = json["feeId"].stringValue
        self.type = json["feeType"].stringValue
    }
    
}
