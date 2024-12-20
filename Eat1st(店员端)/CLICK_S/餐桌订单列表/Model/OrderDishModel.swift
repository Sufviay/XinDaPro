//
//  OrderDishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit
import SwiftyJSON

class OrderDishModel: NSObject {
    
    ///简体名称[...]
    var nameCn: String = ""
    ///繁体名称[...]
    var nameHk: String = ""
    ///英文名称[...]
    var nameEn: String = ""
    ///菜品价格[...]
    var price: Double = 0
    ///购买数量[...]
    var buyNum: Int = 0
    ///是否买一赠一（1否，2是）[...]
    var giveOne: String = "1"
    ///菜品图片[...]
    var imageUrl: String = ""
    ///选项列表[...]
    var optionList: [OrderDishSelectItemModel] = []
    ///套餐菜品列表[...]
    var comboList: [OrderDishSelectItemModel] = []
    ///附加列表[...]
    var attachList: [OrderDishSelectItemModel] = []
    
    
    var cell_H: CGFloat = 0
    
    var name_H: CGFloat = 0
    
    ///0单点 大于0的为套餐
    var baleSort: String = ""
    ///订单菜品ID
    var orderDishesId: String = ""
    
    

    func updateModel(json: JSON) {
        nameCn = HTMLSTR(json["nameCn"].stringValue)
        nameHk = HTMLSTR(json["nameHk"].stringValue)
        nameEn = HTMLSTR(json["nameEn"].stringValue)
        price = json["dishesPrice"].doubleValue
        buyNum = json["buyNum"].intValue
        giveOne = json["giveOne"].stringValue
        imageUrl = json["imageUrl"].stringValue
        baleSort = json["baleSort"].stringValue
        orderDishesId = json["orderDishesId"].stringValue
        
        var tarr1: [OrderDishSelectItemModel] = []
        var o_h: CGFloat = 0
        for jsondata in json["optionList"].arrayValue {
            let model = OrderDishSelectItemModel()
            model.updateModel(json: jsondata, type: "1")
            tarr1.append(model)
            o_h += model.cell_H
        }
        optionList = tarr1
        
        
        var tarr2: [OrderDishSelectItemModel] = []
        var c_h: CGFloat = 0
        for jsondata in json["comboList"].arrayValue {
            let model = OrderDishSelectItemModel()
            model.updateModel(json: jsondata, type: "2")
            tarr2.append(model)
            c_h += model.cell_H
        }
        comboList = tarr2
        
        
        var tarr3: [OrderDishSelectItemModel] = []
        var a_h: CGFloat = 0
        for jsondata in json["attachList"].arrayValue {
            let model = OrderDishSelectItemModel()
            model.updateModel(json: jsondata, type: "3")
            tarr3.append(model)
            a_h += model.cell_H
        }
        attachList = tarr3
        
        
        let n_h = nameEn.getTextHeigh(BFONT(15), S_W - 165) + nameHk.getTextHeigh(SFONT(14),  S_W - 165)
        name_H = (n_h + 30) > 65 ? (n_h + 30) : 65
        
        
        if giveOne == "2" {
            cell_H = name_H + o_h + c_h + a_h + 45
        } else {
            cell_H = name_H + o_h + c_h + a_h
        }
    }
    
    
    func updateTaoCanModel_Hight() {
        
        let n_h = nameEn.getTextHeigh(BFONT(15), S_W - 165) + nameHk.getTextHeigh(SFONT(14),  S_W - 165)
        name_H = (n_h + 30) > 65 ? (n_h + 30) : 65

        var a_h: CGFloat = 0
        for model in attachList {
            a_h += model.cell_H
            if giveOne == "2" {
                cell_H = name_H + a_h + 45
            } else {
                cell_H = name_H + a_h
            }
        }
    }
    
}


class OrderDishSelectItemModel: NSObject {
    ///简体名称[...]
    var nameCn: String = ""
    ///繁体名称[...]
    var nameHk: String = ""
    ///英文名称[...]
    var nameEn: String = ""
    ///菜品价格[...]
    var price: Double = 0
    ///购买数量[...]
    var buyNum: Int = 0
    
    //1规格选项。2套餐菜品。3附加
    var itemType: String = ""
    
    var cell_H: CGFloat = 0
    
    //删除菜品时用到
    var id: String = ""
    
    
    func updateModel(json: JSON, type: String) {
        nameCn = HTMLSTR(json["nameCn"].stringValue)
        nameHk = HTMLSTR(json["nameHk"].stringValue)
        nameEn = HTMLSTR(json["nameEn"].stringValue)
        price = json["price"].doubleValue
        buyNum = json["buyNum"].intValue
        itemType = type
        
        
        if itemType != "3" {
            let n_h = nameEn.getTextHeigh(BFONT(11), S_W - 90) + nameHk.getTextHeigh(SFONT(11), S_W - 90)
            cell_H = (n_h + 10) > 40 ? (n_h + 10) : 40
        } else {
            let n_h = nameEn.getTextHeigh(BFONT(10), S_W - 220) + nameHk.getTextHeigh(SFONT(10), S_W - 220)
            cell_H = (n_h + 15) > 45 ? (n_h + 15) : 45
        }
    }
    
    
    func updateModelByTaoCan(model: OrderDishModel) {
        nameHk = model.nameHk
        nameEn = model.nameEn
        price = model.price
        id = model.orderDishesId
        
        let n_h = nameEn.getTextHeigh(BFONT(10), S_W - 220) + nameHk.getTextHeigh(SFONT(10), S_W - 220)
        cell_H = (n_h + 15) > 45 ? (n_h + 15) : 45
    }
}
