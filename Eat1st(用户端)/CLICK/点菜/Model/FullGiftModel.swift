//
//  FullGiftModel.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/19.
//

import UIKit
import SwiftyJSON

class FullGiftModel: NSObject {

    ///订单满赠金额
    var giftName: String = ""
    ///订单满赠金额
    var price: Double = 0
    ///是否可选择 1否 2是
    var chooseType: String = ""
    ///菜品列表
    var dishesList: [CartDishModel] = []
    
    ///Cell高度
    var fullGift_H: CGFloat = 0
    
    
    
    func updateModel(json: JSON) {
        giftName = json["giftName"].stringValue
        price = json["price"].doubleValue
        chooseType = json["chooseType"].stringValue
        
        
        var tArr: [CartDishModel] = []
        var tH: CGFloat = 0
        for jsonData in json["dishesList"].arrayValue {
            let model = CartDishModel()
            model.updateGiftModel(json: jsonData)
            tArr.append(model)
            tH += model.giftDish_H
        }
        dishesList = tArr
        
        
        fullGift_H = tH + 10 + 40
    }
    
}
