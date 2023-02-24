//
//  OrderDishModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit
import SwiftyJSON

class OrderDishModel: NSObject {
    
    var count: Int = 0
    
    ///列表图片
    var listImg: String = ""
    ///详情图片
    var detailImg: String = ""
    ///名字中文
    var name_C: String = ""
    ///名字英文
    var name_E: String = ""
    ///购物车商品总价
    var subFee: Double = 0
    
    ///描述中文
    var des_C: String = ""
    ///描述英文
    var des_E: String = ""
    
    ///菜品标签
    var tagList: [DishTagsModel] = []
    
    ///菜的优惠价格
    var discountPrice: Double = 0
    ///菜品是否有优惠 1无优惠 2有优惠
    var discountType: String = ""
    ///优惠百分比
    var discountSale: String = ""
    ///菜品类型（1单品， 2套餐）
    var dishesType: String = ""
    
    ///cell的高度
    var dish_H: CGFloat = 0
    
    
    
    
    func updateModel(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = json["dishesName"].stringValue
        self.name_E = json["dishesName"].stringValue
        self.detailImg = json["imageUrl"].stringValue
        self.subFee = json["dishesPrice"].doubleValue
        
        
        self.discountPrice = json["discountPrice"].doubleValue
        self.discountType = json["discountType"].stringValue
        self.dishesType = json["dishesType"].stringValue
        
        if subFee - discountPrice > 0 {
            let ts = (subFee - discountPrice) / subFee * 100
            self.discountSale = String(Int(floor(ts)))

        }
        
        
        var t1: String = ""
        var t2: String = ""

        if dishesType == "2" {
            //套餐
            for (idx, jsonData) in json["comboList"].arrayValue.enumerated() {
                if idx == 0 {
                    t1 = jsonData["dishesName"].stringValue
                    t2 = jsonData["dishesName"].stringValue
                } else {
                    t1 = t1 + "\n" + jsonData["dishesName"].stringValue
                    t2 = t2 + "\n" + jsonData["dishesName"].stringValue
                }
            }
            
        } else  {
            //单品
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
        
        let h1 = self.name_C.getTextHeigh(BFONT(14), S_W - 155)
        let h2 = self.des_C.getTextHeigh(SFONT(11), S_W - 145)
        self.dish_H = h1 + h2 + 35 < 75 ? 75 : h1 + h2 + 35

        
        var tArr2: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.tagList = tArr2
    }

}
