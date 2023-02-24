//
//  PlaintDishModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/7.
//

import UIKit
import SwiftyJSON

class PlaintDishModel: NSObject {
    
    
    var count: Int = 0
    
    ///列表图片
    var listImg: String = ""
    ///详情图片
    var detailImg: String = ""
    ///名字中文
    var name_C: String = ""
    ///名字英文
    var name_E: String = ""
    ///商品价格
    var price: Double = 0
    
    ///描述中文
    var des_C: String = ""
    ///描述英文
    var des_E: String = ""
    ///id
    var dishID: String = ""
    
    
    ///选择的数量
    var selectCount: Int = 0
    
    
    var dish_H: CGFloat = 0
    ///2 套餐
    var dishesType: String = ""
    
    
    
    func updateModel(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = json["dishesName"].stringValue
        self.name_E = json["dishesName"].stringValue
        self.detailImg = json["imageUrl"].stringValue
        self.price = json["price"].doubleValue
        self.dishID = json["orderDishesId"].stringValue
        self.dishesType = json["dishesType"].stringValue
        
        var t1: String = ""
        var t2: String = ""
        
        if dishesType == "2" {
            
            for (idx, jsonData) in json["comboList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    t1 = jsonData["dishesName"].stringValue
                    t2 = jsonData["dishesName"].stringValue
                } else {
                    t1 = t1 + "\n" + jsonData["dishesName"].stringValue
                    t2 = t2 + "\n" + jsonData["dishesName"].stringValue
                }
            }
            
        } else {
            for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    t1 = jsonData["optionName"].stringValue
                    t2 = jsonData["optionName"].stringValue
                } else {
                    t1 = t1 + "/" + jsonData["optionName"].stringValue
                    t2 = t2 + "/" + jsonData["optionName"].stringValue
                }
            }
        }
        

        
        self.des_C = t2
        self.des_E = t1
        
        
        let n_h = self.name_E.getTextHeigh(BFONT(14), S_W - 210)
        let d_H = self.des_E.getTextHeigh(SFONT(13), S_W - 210)
        self.dish_H = (n_h + d_H + 40) > 75 ? (n_h + d_H + 40) : 75
    }


}
