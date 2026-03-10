//
//  OrderDishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/29.
//

import UIKit
import SwiftyJSON

class OrderDishModel: NSObject {
    
    
    var dishesId :String = ""
    var orderDishesId: String = ""
    var imageUrl: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    ///菜品价格
    var dishesPrice: String = ""
    
    ///是否是买一赠一的
    var isGiveOne: Bool = false
    
    ///菜品类型 1单品2套餐
    var dishesType: String = ""
    ///购买数量
    var buyNum: Int = 0
    ///投诉数量
    var plaintNum: Int = 0
    
    
    
    ///菜品选项名称
    var optionName: String = ""
    
    ///套餐选项名称
    var comboName: String = ""
    
    
    ///菜品附加名称
    var attachName: String = ""
    
    
    
    var nameStr = ""
    
    var desStr = ""
    
    var selectCount: Int = 0
    
    
    ///投诉菜品的Cell高度
    var complaintsCell_H: CGFloat = 0
    
    var showCell_H: CGFloat = 0
    
    
    
    
    func updateModel(json: JSON) {
        
        orderDishesId = json["orderDishesId"].stringValue
        dishesId = json["dishesId"].stringValue
        imageUrl = json["imageUrl"].stringValue
        nameEn = json["nameEn"].stringValue
        nameHk = json["nameHk"].stringValue
        dishesPrice = D_2_STR(json["dishesPrice"].doubleValue)
        dishesType = json["dishesType"].stringValue
        isGiveOne = json["giveOne"].stringValue == "1" ? false : true
        buyNum = json["buyNum"].intValue
        plaintNum = json["plaintNum"].intValue
        
        
        
        if PJCUtil.getCurrentLanguage() == "en_GB" {
            //英文
            nameStr = "\(nameEn)(\(nameHk))"
            
            if json["optionList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["optionList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["optionList"]["nameEn"].stringValue
                    let nameC = jsondata["optionList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameE)(\(nameC))"
                    } else {
                        tStr = tStr + "/" + "\(nameE)(\(nameC))"
                    }
                }
                
                optionName = tStr
                
            }
            
            if json["comboList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["comboList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["comboList"]["nameEn"].stringValue
                    let nameC = jsondata["comboList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameE)(\(nameC))"
                    } else {
                        tStr = tStr + "\n" + "\(nameE)(\(nameC))"
                    }
                }
                comboName = tStr
            }
            
            if json["attachList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["attachList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["attachList"]["nameEn"].stringValue
                    let nameC = jsondata["attachList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameE)(\(nameC))"
                    } else {
                        tStr = tStr + "\n" + "\(nameE)(\(nameC))"
                    }
                }
                
                attachName = tStr
                
            }
            
            
        } else {
            //中文
            nameStr = "\(nameHk)(\(nameEn))"
            
            
            if json["optionList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["optionList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["optionList"]["nameEn"].stringValue
                    let nameC = jsondata["optionList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameC)(\(nameE))"
                    } else {
                        tStr = tStr + "/" + "\(nameC)(\(nameE))"
                    }
                }
                
                optionName = tStr
                
            }
            
            if json["comboList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["comboList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["comboList"]["nameEn"].stringValue
                    let nameC = jsondata["comboList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameC)(\(nameE))"
                    } else {
                        tStr = tStr + "\n" + "\(nameC)(\(nameE))"
                    }
                }
                comboName = tStr
            }
            
            if json["attachList"].arrayValue.count != 0 {
                
                var tStr: String = ""
                
                for (idx, jsondata) in json["attachList"].arrayValue.enumerated() {
                    
                    let nameE = jsondata["attachList"]["nameEn"].stringValue
                    let nameC = jsondata["attachList"]["nameHk"].stringValue
                    
                    if idx == 0 {
                        tStr += "\(nameC)(\(nameE))"
                    } else {
                        tStr = tStr + "\n" + "\(nameC)(\(nameE))"
                    }
                }
                
                attachName = tStr
            }
        }
        
        
        if dishesType == "1" {
            desStr = optionName
        }
        if dishesType == "2" {
            desStr = comboName
        }
        
        
        //投诉菜品高度
        complaintsCell_H = (nameStr.getTextHeigh(BFONT(14), S_W - 155) + desStr.getTextHeigh(SFONT(12), S_W - 195) + 30) > 85 ? (nameStr.getTextHeigh(BFONT(14), S_W - 155) + desStr.getTextHeigh(SFONT(12), S_W - 195) + 30) : 85
        
       
        
        if isGiveOne {
            showCell_H = (nameStr.getTextHeigh(BFONT(11), S_W - 145) + desStr.getTextHeigh(SFONT(11), S_W - 125) + 35 + 30) > 70 ? (nameStr.getTextHeigh(BFONT(11), S_W - 145) + desStr.getTextHeigh(SFONT(11), S_W - 125) + 35 + 30) : 70
        } else {
            showCell_H = (nameStr.getTextHeigh(BFONT(11), S_W - 145) + desStr.getTextHeigh(SFONT(11), S_W - 125) + 35) > 70 ? (nameStr.getTextHeigh(BFONT(11), S_W - 145) + desStr.getTextHeigh(SFONT(11), S_W - 125) + 35) : 70
        }
        
        
        
    }
    

}
