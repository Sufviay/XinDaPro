//
//  CustomerTagModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/23.
//

import UIKit
import SwiftyJSON

class CustomerTagModel: NSObject {
    
    ///標籤ID
    var tagId: String = ""
    ///標籤綁定的人數
    var userNum: String = ""
    ///英文名字
    var nameEn: String = ""
    ///中文名字
    var nameCn: String = ""
    var nameHk: String = ""
    ///標籤狀態 1启用，2禁用
    var status: String = ""
    
    
    var name1: String = ""
    var name2: String = ""
    
    func updateModel(json: JSON) {
        tagId = json["tagId"].stringValue
        userNum = json["userNum"].stringValue
        status = json["status"]["id"].stringValue
        nameEn = json["nameEn"].stringValue
        nameCn = json["nameCn"].stringValue
        nameHk = json["nameHk"].stringValue
        
        if MyLanguageManager.shared.language == .Chinese {
            name1 = nameHk
            name2 = nameEn
        } else {
            name1 = nameEn
            name2 = nameHk
        }
    }
    


}
