//
//  PlaintReasonModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/7.
//

import UIKit
import SwiftyJSON


class PlaintReasonModel: NSObject {
    
    var reasonID: String = ""
    var reasonName: String = ""
    var hopeList: [JSON] = []
    
    func updateModel(json: JSON) {
        self.reasonID = json["plaintReasonId"].stringValue
        self.reasonName = json["plaintReasonName"].stringValue
        self.hopeList = json["hopeList"].arrayValue
    }
    
}
