//
//  ScreenTagsModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/16.
//

import UIKit
import SwiftyJSON


class ScreenTagsModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    
    func updateModel(json: JSON) {
        self.id = json["tagId"].stringValue
        self.name = json["tagName"].stringValue
    }

}
