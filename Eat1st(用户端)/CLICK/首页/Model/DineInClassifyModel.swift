//
//  DineInClassifyModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/25.
//

import UIKit
import SwiftyJSON

class DineInClassifyModel: NSObject {
    
    ///分类编码[...]
    var dineClassifyId: String = ""
    ///分类名称[...]
    var dineName: String = ""
    ///分类图片[...]
    var imageUrl: String = ""
    ///名字
    var name_E: String = ""
    var name_C: String = ""
    
    
    func updateModel(json: JSON) {
        self.dineClassifyId = json["dineClassifyId"].stringValue
        self.dineName = json["dineName"].stringValue
        self.imageUrl = json["imageUrl"].stringValue
        name_C = json["nameHk"].stringValue
        name_E = json["nameEn"].stringValue
    }

}
