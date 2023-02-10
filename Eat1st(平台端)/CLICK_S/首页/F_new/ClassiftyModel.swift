//
//  ClassiftyModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit
import SwiftyJSON


class ClassiftyModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    
    
    func updateModel(json: JSON) {
        self.id = json["classifyId"].stringValue
        self.name = json["classifyName"].stringValue
    }

}
