//
//  FullGiftModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/17.
//

import UIKit
import SwiftyJSON

class FullGiftModel: NSObject {

    
    var giftId: String = ""
    ///1启用，2禁用）
    var status: String = ""
    var name: String = ""
    var giftNum: String = ""
    var dishArr: [ComboDishModel] = []
    var price: String = ""
    
    var listCell_H: CGFloat = 0
    
    
    func updateModel(json: JSON) {
        giftId = json["giftId"].stringValue
        name = json["nameCn"].stringValue
        status = json["status"]["id"].stringValue
        giftNum = json["giftNum"].stringValue
        price = D_2_STR(json["price"].doubleValue)
        
        let h = name.getTextHeigh(TIT_18, S_W - 100)
        listCell_H = h + 95
        
        
        var tarr: [ComboDishModel] = []
        for jsonData in json["dishesList"].arrayValue {
            
            let model = ComboDishModel()
            model.updatePrinterDishModel(json: jsonData)
            tarr.append(model)
        }
        dishArr = tarr
    
    }
    
}
