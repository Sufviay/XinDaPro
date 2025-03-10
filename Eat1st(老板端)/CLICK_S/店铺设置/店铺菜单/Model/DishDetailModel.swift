//
//  DishDetailModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/22.
//

import UIKit
import HandyJSON
import SwiftyJSON

class DishDetailModel: HandyJSON {
    
    ///过敏源
    var allergenCn: String = ""
    var allergenEn: String = ""
    var allergenHk: String = ""
    ///分类编码
    var classifyId: Int64 = 0
    var classifyNameCn: String = ""
    var classifyNameEn: String = ""
    var classifyNameHk: String = ""
    ///菜品详情图片 -保存用
    var detailUrl: String = ""
    ///菜品代码
    var dishesCode: String = ""
    ///菜品编码
    var dishesId: Int64 = 0
    ///菜品列表图片-保存用
    var listUrl: String = ""
    ///菜品名
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    ///优惠 （1无优惠，2有优惠）
    var discountType: String = ""
    
    
    ///是否限购 1否 2是
    var limitBuy: String = "1"
    ///库存数量
    var limitNum: Int = 0
    
    ///优惠价格
    var discountPrice: String = ""
    ///菜品价格
    var price: String = "0"
    
    ///外卖价格
    var deliPrice: String = ""
    ///堂食价格
    var dinePrice: String = ""
    
    ///售卖类型 1外卖，2堂食，3均可
    var sellType: String = ""
    
    
    ///菜品描述
    var remarkCn: String = ""
    var remarkEn: String = ""
    var remarkHk: String = ""
    
    ///详情图片显示用
    var showDetailUrl: String = ""
    ///列表图片显示用
    var showListUrl: String = ""
    
    ///上下架状态
    var statusId: String = ""
    
    
    ///菜品类型 1是单品2是套餐
    var dishesType: String = ""
    
    ///是否为自助餐 1否 2是
    var buffetType: String = ""
    
    /// 菜品种类（1食物，2饮料）
    var dishesKind: String = ""
    
    ///是否含税（1否，2是）
    var vatType: String = ""
    
    ///特殊菜品 1否 2是
    var baleType: String = ""
    
    
    ///规格选项列表
    var specList: [DishDetailSpecModel] = []
    
    
    ///套餐列表
    var comboList: [DishDetailComboModel] = []
    
    ///标签
    var tagList: [DishDetailTagModel] = []
    
    ///是否买一赠一  1否 2是
    var giveOne: String = ""
    
    ///是否打印别名  1否 2是
    var printType: String = ""
    ///打印别名的名称
    var printAlias: String = ""
    
    var aliasStr: String = ""
    
    ///商品条形码
    var dishesBarCode: String = ""
    
    ///会员价格（1无，2有）[...]
    var vipType: String = ""
    ///会员价格[...]
    var vipPrice: String = ""
    ///会员价格配送类型（1外卖，2自取，3堂食）[...]
    var vipDeliveryStr: String = ""

    
    
    var dishName1: String = ""
    var dishName2: String = ""
    ///分类处理
    var classifyStr: String = ""
    ///描述處理
    var desStr: String = ""
    ///过敏源处理
    var allergenStr: String = ""
    ///标签处理
    var tagsStr: String = ""

    
    
    required init() { }
        

    
    func updateModle() {
        
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            dishName1 = nameEn == "" ? "--" : nameEn
            dishName2 = nameHk == "" ? "--" : nameHk
        } else {
            dishName1 = nameHk == "" ? "--" : nameHk
            dishName2 = nameEn == "" ? "--" : nameEn
        }
        
        classifyStr = self.dealMsg(enStr: classifyNameEn, hkStr: classifyNameHk)
        desStr = self.dealMsg(enStr: remarkEn, hkStr: remarkHk)
        allergenStr = self.dealMsg(enStr: allergenEn, hkStr: allergenHk)
        tagsStr = self.dealTags()
        aliasStr = printAlias == "" ? "--" : printAlias
        
        for smodel in specList {
            for omodel in smodel.optionList {
                omodel.updateModel()
            }
            smodel.updateModel()
        }
        
        
        for cmodel in comboList {
            for cdmodel in cmodel.comboDishesList {
                cdmodel.updateModel()
            }
            cmodel.updateModel()
        }
        
        
        for tagModel in tagList {
            tagModel.updateModel()
        }
        
    }
    
    
    ///处理信息
    private func dealMsg(enStr: String, hkStr: String) -> String {
        var msgStr = ""
        let curL = PJCUtil.getCurrentLanguage()
        
        if enStr == "" && hkStr == "" {
            msgStr = "--"
        }

        if hkStr != "" && enStr == "" {
            msgStr = hkStr
        }
        if enStr != "" && hkStr == "" {
            msgStr = enStr
        }
        if enStr != "" && hkStr != "" {
            if curL == "en_GB" {
                msgStr = enStr + "\n" + hkStr
            } else {
                msgStr = hkStr + "\n" + enStr
            }
        }
        return msgStr
    }
    
    private func dealTags() -> String {
        var msg = "--"
        let curL = PJCUtil.getCurrentLanguage()
        if tagList.count != 0 {
            for (idx, model) in tagList.enumerated() {
                if idx == 0 {
       
                    msg = curL == "en_GB" ? model.nameEn : model.nameHk

                } else {
                    msg = msg + "," + (curL == "en_GB" ? model.nameEn : model.nameHk)
                }
            }
        }
        return msg
    }

}


class DishDetailComboModel: HandyJSON {
    
    var comboDishesList: [ComboDishModel] = []
    var nameEn: String = ""
    var nameHk: String = ""
    var nameCn: String = ""
    
    
    var name1: String = ""
    var name2: String = ""
    
    var name_h: CGFloat = 0

    
    required init() { }
    
    func updateModel() {
        
        let curL = PJCUtil.getCurrentLanguage()
        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
        
        let h1 = name1.getTextHeigh(BFONT(17), S_W - 120)
        let h2 = name2.getTextHeigh(SFONT(15), S_W - 120)
        self.name_h = 30 + h1 + 2 + h2
        
    }
    
}


class ComboDishModel: HandyJSON {
    
    var nameEn: String = ""
    var nameHk: String = ""
    var nameCn: String = ""
    var dishesId: Int64 = 0
    
    
    var name1: String = ""
    var name2: String = ""

    var name_h: CGFloat = 0
    
    
    required init() { }
    
    
    func updateModel() {
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
        
        let h1 = name1.getTextHeigh(BFONT(13), S_W - 95)
        let h2 = name2.getTextHeigh(SFONT(13), S_W - 95)
        self.name_h = 20 + h1 + 2 + h2
    }
    
    
    
    func updatePrinterDishModel(json: JSON) {
        nameEn = json["nameEn"].stringValue
        nameHk = json["nameHk"].stringValue
        nameCn = json["nameCn"].stringValue
        
        dishesId = json["dishesId"].int64Value
        
        
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
        
        let h1 = name1.getTextHeigh(BFONT(14), S_W - 40)
        let h2 = name2.getTextHeigh(SFONT(14), S_W - 40)
        self.name_h = 40 + h1 + 2 + h2

    }
    
    
}


class DishDetailSpecModel: HandyJSON {
    
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    var optionList: [DishDetailOptionModel] = []
    ///1非必选 2必选
    var required: String = ""
    ///规格是否可以多选   1否，2是
    var multiple: String = ""
    
    ///规格状态（1启用、2禁用）
    var statusId: String = "1"
    ///菜品ID
    var dishesId: Int64 = 0
    
    var name1: String = ""
    var name2: String = ""
    
    var name_h: CGFloat = 0
    var spe_H: CGFloat = 0
    
    
    
    var specId: Int64 = 0

    
    
    
    required init() { }
    
    
    func updateModel() {
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }

        let h1 = name1.getTextHeigh(BFONT(16), S_W - 120)
        let h2 = name2.getTextHeigh(SFONT(15), S_W - 120)
        self.name_h = 30 + h1 + h2
        
        var t_h: CGFloat = 0

        for oModel in optionList {
            t_h += oModel.op_h
        }
        self.spe_H = t_h + name_h + 50 + 65 + 55 + 65
    }
    
}


class DishDetailOptionModel: HandyJSON {
    
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    var optionId: Int64 = 0
    var price: String = "0"
    ///选项状态（1启用、2禁用）
    var statusId: String = ""
    ///规格ID
    var specId: Int64 = 0
    
    
    var name1: String = ""
    var name2: String = ""

    var name_h: CGFloat = 0
    var op_h: CGFloat = 0
    
    
    required init() { }
    
    
    func updateModel() {
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
        
        let h1 = name1.getTextHeigh(BFONT(14), S_W - 120)
        let h2 = name2.getTextHeigh(SFONT(14), S_W - 120)
        self.name_h = 30 + h1 + h2
        self.op_h = name_h + 45 + 70
    }
}


class DishDetailTagModel: HandyJSON {
    
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    var tagId: Int64 = 0
    
    var name1: String = ""
    var name2: String = ""
    
    
    func updateModel() {
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
    }
    
    
    func updateModel(json: JSON) {
        self.nameEn = json["nameEn"].stringValue
        self.nameHk = json["nameHk"].stringValue
        self.tagId = json["tagId"].int64Value
        
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            name1 = nameEn == "" ? "--" : nameEn
            name2 = nameHk == "" ? "--" : nameHk
        } else {
            name1 = nameHk == "" ? "--" : nameHk
            name2 = nameEn == "" ? "--" : nameEn
        }
    }
    
    required init() { }
}



