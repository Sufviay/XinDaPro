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
    ///菜品类型（1正常购买，2优惠券赠菜
    var dishesType: String = ""
    
    
    
    
    
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
        for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
            
            if idx == 0 {
                t1 = jsonData["optionName"].stringValue
                t2 = jsonData["optionName"].stringValue
            } else {
                t1 = t1 + "/" + jsonData["optionName"].stringValue
                t2 = t2 + "/" + jsonData["optionName"].stringValue
            }
        }
        
        self.des_C = t2
        self.des_E = t1
        
        var tArr2: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.tagList = tArr2
    }

}
