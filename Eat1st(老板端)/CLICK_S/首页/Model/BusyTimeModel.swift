//
//  BusyTimeModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/19.
//

import UIKit
import SwiftyJSON

class BusyTimeModel: NSObject {

    var busyID: String = ""
    var busyName: String = ""
    var isSelect: Bool = false
    
    func updateModel(json: JSON) {
        self.busyID = json["busyId"].stringValue
        self.busyName = json["busyName"].stringValue
        self.isSelect = json["select"].stringValue == "1" ? true : false
    }
    
}


class TimeRangeModel: NSObject {
    
    var coMax: String = ""
    var coMin: String = ""
    var deMax: String = ""
    var deMin: String = ""
    
    func updateModel(json: JSON) {
        self.coMax = json["collectionMax"].stringValue
        self.coMin = json["collectionMin"].stringValue
        
        self.deMin = json["deliveryMin"].stringValue
        self.deMax = json["deliveryMax"].stringValue
    }
    
}
