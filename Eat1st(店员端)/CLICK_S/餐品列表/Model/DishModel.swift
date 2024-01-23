//
//  DishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit
import SwiftyJSON

class DishModel: NSObject {

    ///菜品编码
    var dishesId: String = ""
    ///菜品编号
    var dishesCode: String = ""
    ///菜品繁体中文名称
    var dishesNameHk: String = ""
    ///菜品英文名称
    var dishesNameEn: String = ""
    ///菜品分类编码
    var classifyId: String = ""
    /// 菜品价格
    var price: Double = 0
    ///菜品类型（1单品，2套餐）
    var dishesType: String = ""
    ///是否有规格（1是，2否）
    var haveSpec: String = ""
    ///是否热门（1是，2否）
    var hot: String = ""
    ///是否买一赠一（1否，2是）
    var giveOne: String = ""
    
    ///过敏原
    var allergen: String = ""
    
    ///菜品规格
    var specList: [SpecModel] = []
    ///套餐菜品
    var comboSpecList: [ComboModel] = []
    
    
    
    
    ///Cell高度
    var dish_H: CGFloat = 0
    
    
    var detail_Name_H: CGFloat = 0
    var allergen_H: CGFloat = 0
    
    
    func updateModel(json: JSON) {
        
        dishesId = json["dishesId"].stringValue
        dishesCode = json["dishesCode"].stringValue
        dishesNameHk = json["dishesNameHk"].stringValue
        dishesNameEn = json["dishesNameEn"].stringValue
        classifyId = json["classifyId"].stringValue
        price = json["price"].doubleValue
        dishesType = json["dishesType"].stringValue
        haveSpec = json["haveSpec"].stringValue
        hot = json["hot"].stringValue
        giveOne = json["giveOne"].stringValue
        
        
        let h1 = dishesNameEn.getTextHeigh(BFONT(15), S_W - 160)
        let h2 = dishesNameHk.getTextHeigh(SFONT(15), S_W - 160)
        
        dish_H = (h1 + h2 + 63) > 100 ? (h1 + h2 + 63) : 100
        
    }
    
    
    func updateDetailModel(json: JSON) {
        dishesId = json["dishesId"].stringValue
        dishesCode = json["dishesCode"].stringValue
        dishesNameHk = json["dishesNameHk"].stringValue
        dishesNameEn = json["dishesNameEn"].stringValue
        classifyId = json["classifyId"].stringValue
        price = json["price"].doubleValue
        dishesType = json["dishesType"].stringValue
        allergen = json["allergen"].stringValue
        giveOne = json["giveOne"].stringValue
        
        var sArr: [SpecModel] = []
        for jsondata in json["specList"].arrayValue {
            let model = SpecModel()
            model.updateModel(json: jsondata)
            sArr.append(model)
        }
        specList = sArr
        
        var cArr: [ComboModel] = []
        for jsondata in json["comboSpecList"].arrayValue {
            let model = ComboModel()
            model.updateModel(json: jsondata)
            cArr.append(model)
        }
        comboSpecList = cArr
        
        
        detail_Name_H = dishesNameEn.getTextHeigh(BFONT(12), S_W - 60) + dishesNameHk.getTextHeigh(SFONT(13), S_W - 60) + 40
        allergen_H = allergen.getTextHeigh(BFONT(11), S_W - 70) + 35
        

    }
    
    
}


class SpecModel: NSObject {
    ///规格编码[...]
    var specId: String = ""
    ///规格繁体中文名称[...]
    var specNameHk: String = ""
    ///规格英文名称[...]
    var specNameEn: String = ""
    ///是否必选（1否，2是）[...]
    var required: String = ""
    ///是否多选（1否，2是）[...]
    var multiple: String = ""
    ///规格选项列表[...]
    var optionList: [OptionModel] = []
    
    
    var name_H: CGFloat = 0
    
    var cell_H: CGFloat = 0
    
    
    
    
    func updateModel(json: JSON) {
        specId = json["specId"].stringValue
        specNameHk = json["specNameHk"].stringValue
        specNameEn = json["specNameEn"].stringValue
        required = json["required"].stringValue
        multiple = json["multiple"].stringValue
        
        let tH = specNameEn.getTextHeigh(BFONT(12), S_W - 30 - 15 - 135) + specNameHk.getTextHeigh(SFONT(11), S_W - 30 - 15 - 135)
    
        name_H = (tH + 20) > 50 ? (tH + 20) : 50

        var tarr: [OptionModel] = []
        var op_H: CGFloat = 0
        for jsondata in json["optionList"].arrayValue {
            let model = OptionModel()
            model.updateModel(json: jsondata)
            tarr.append(model)
            op_H += model.cell_H
        }
        optionList = tarr
        
        cell_H = op_H + name_H
    }
}


class OptionModel: NSObject {
    ///菜品选项编码[...]
    var optionId: String = ""
    ///菜品选项繁体中文名称[...]
    var optionNameHk: String = ""
    ///菜品选项英文名称[...]
    var optionNameEn: String = ""
    ///菜品选项价格[...]
    var price: Double = 0
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        optionId = json["optionId"].stringValue
        optionNameHk = json["optionNameHk"].stringValue
        optionNameEn = json["optionNameEn"].stringValue
        price = json["price"].doubleValue
        
        let name_H = optionNameEn.getTextHeigh(BFONT(13), S_W - 60 - 105) + optionNameHk.getTextHeigh(SFONT(11), S_W - 60 - 105)
        cell_H = (name_H + 20) > 50 ? (name_H + 20) : 50
        
    }
    
}



class ComboModel: NSObject {
    ///套餐规格编码[...]
    var comboId: String = ""
    ///套餐规格繁体名称[...]
    var comboNameHk: String = ""
    ///套餐规格英文名称[...]
    var comboNameEn: String = ""
    ///菜品列表[...]
    var comboDishesList: [ComboDishesModel] = []
    
    var name_H: CGFloat = 0
    
    var cell_H: CGFloat = 0

    
    func updateModel(json: JSON) {
        comboId = json["comboId"].stringValue
        comboNameHk = json["comboNameHk"].stringValue
        comboNameEn = json["comboNameEn"].stringValue
        
        let tH = comboNameEn.getTextHeigh(BFONT(12), S_W - 30 - 15 - 135) + comboNameHk.getTextHeigh(SFONT(11), S_W - 30 - 15 - 135)
    
        name_H = (tH + 20) > 50 ? (tH + 20) : 50
        
        
        var tarr: [ComboDishesModel] = []
        var op_H: CGFloat = 0
        for jsondata in json["comboDishesList"].arrayValue {
            let model = ComboDishesModel()
            model.updateModel(json: jsondata)
            tarr.append(model)
            op_H += model.cell_H
        }
        comboDishesList = tarr
        cell_H = op_H + name_H
    }
    
}


class ComboDishesModel: NSObject {
    
    ///套餐规格菜品编码[...]
    var dishesComboRelId: String = ""
    ///菜品繁体名称[...]
    var dishesNameHk: String = ""
    ///菜品英文名称[...]
    var dishesNameEn: String = ""
    ///菜品图片[...]
    var imageUrl: String = ""
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        dishesComboRelId = json["dishesComboRelId"].stringValue
        dishesNameHk = json["dishesNameHk"].stringValue
        dishesNameEn = json["dishesNameEn"].stringValue
        imageUrl = json["imageUrl"].stringValue
        
        
        let name_H = dishesNameEn.getTextHeigh(BFONT(13), S_W - 60 - 105) + dishesNameHk.getTextHeigh(SFONT(11), S_W - 60 - 105)
        cell_H = (name_H + 20) > 50 ? (name_H + 20) : 50
    }
    
}







