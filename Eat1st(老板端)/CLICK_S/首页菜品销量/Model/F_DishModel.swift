//
//  F_DishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/10.
//

import UIKit
import SwiftyJSON

class F_DishModel: NSObject {
    
    var id: String = ""
    var name_En: String = ""
    var name_Hk: String = ""
    
    var dishNum: Int = 0
    
    var name1: String = ""
    var name2: String = ""
    
    var dishArr: [DishModel] = []
    var isShow: Bool = false
    
    var isSelectAll: Bool = false 

    func updateModel(json: JSON) {
        self.id = json["classifyId"].stringValue
        self.dishNum = json["num"].intValue
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue

        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
        }
    }
}



class DishModel: NSObject {
    
    var isSelect: Bool = false
    
    var c_id: String = ""
    var id: String = ""
    ///状态ID  1上架 2下架
    var statusID: String = ""
    ///原价格
    var price: String = "0"
    
    ///外卖价格
    var deliPrice: String = "0"
    
    ///堂食价格
    var dinePrice: String = "0"
    
    ///售卖类型（1外卖，2堂食，3均可）
    var sellType: String = ""
    
    ///是否是自主餐
    var buffetType: String = ""
    
    ///优惠价格
    var discountPrice: String = "0"
    ///是否有优惠 1无 2有
    var discountType: String = ""
    ///优惠百分比
    var discountSale: String = ""
    
    var discountStartDate: String = ""
    var discountEndDate: String = ""
    
    
    var name_En: String = ""
    var name_Hk: String = ""
    var name_Cn: String = ""
    
    ///是否有规格
    var haveSpec: Bool = false
    
    var dishImg: String = ""
    var salesNum: String = ""
    
    ///类型（查询菜品每周销量、菜品每月销量时带上此参数）
    var type: String = ""
    
    ///菜品描述英文
    var des_En: String = ""
    ///简体中文
    var des_Hk: String = ""
    
    ///拼接好的描述
    var des_all: String = "--"
    
    ///菜品标签
    var tags: [String] = []
     
    ///是否参与优惠  1 参与 2不参与
    var discount: String = ""
    
    ///是否限购 (1否，2是）
    var limitBuy: String = "1"
    ///限购的库存数量
    var limitNum: String = ""
    
    ///菜品类型 1 单品 2套餐
    var dishesType: String = ""
    
    
    var optionArr: [DishOptionModel] = [] {
        didSet {
            if optionArr.count == 0 {
                self.cell_H = self.dish_H
            } else {
                //计算规格高度
                self.getOptionHeight()
            }
        }
    }
    

    var name1: String = ""
    var name2: String = ""
    
    var cell_H: CGFloat = 0
    
    //菜品名高度
    var dish_H: CGFloat = 0
    //规格名高度
    var option_H: CGFloat = 0
    //规格选项的高度
    var optionItem_H: CGFloat = 0
    

    
    
    
    
    func updateModel(json: JSON) {
        self.c_id = json["classifyId"].stringValue
        self.id = json["dishesId"].stringValue
        self.statusID = json["statusId"].stringValue
        self.price = D_2_STR(json["price"].doubleValue)
        self.deliPrice = D_2_STR(json["deliPrice"].doubleValue)
        self.dinePrice = D_2_STR(json["dinePrice"].doubleValue)
        self.sellType = json["sellType"].stringValue
        self.discountPrice = D_2_STR(json["discountPrice"].doubleValue)
        self.discountStartDate = json["startTime"].stringValue
        self.discountEndDate = json["endTime"].stringValue
        self.dishesType = json["dishesType"].stringValue
        self.discountType = json["discountType"].stringValue
        self.buffetType = json["buffetType"].stringValue
        
        
        let deliPrice = json["deliPrice"].doubleValue
        let dinePrice = json["dinePrice"].doubleValue
        let disPrice = json["discountPrice"].doubleValue
        
        
        if sellType == "2" {
            //堂食
            
            if discountType == "2" {
                //有优惠
                let ts = (dinePrice - disPrice) / dinePrice  * 100
                self.discountSale = String(Int(floor(ts)))
            }
            
        } else {
            if discountType == "2" {
                //有优惠
                let ts = (deliPrice - disPrice) / deliPrice  * 100
                self.discountSale = String(Int(floor(ts)))
            }
        }
                
        
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue
        
        self.des_En = json["remarkEn"].stringValue
        self.des_Hk = json["remarkHk"].stringValue
        //self.tags = json["tags"].stringValue == "" ? [] : json["tags"].stringValue.components(separatedBy: "·")
        self.discount = json["discount"].stringValue
        
        self.dishImg = json["imageUrl"].stringValue
        self.salesNum = json["salesNum"].stringValue
        self.type = json["type"].stringValue
        
        self.haveSpec = json["haveSpec"].stringValue == "1" ? true : false
        
        self.limitBuy = json["limitBuy"].stringValue
        self.limitNum = json["limitNum"].stringValue
        
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
            
            if des_En == "" && des_Hk == "" {
                self.des_all = "--"
            }
            if des_En == "" && des_Hk != "" {
                self.des_all = des_Hk
            }
            if des_En != "" && des_Hk == "" {
                self.des_all = des_En
            }
            if des_En != "" && des_Hk != "" {
                self.des_all = des_En + "\n" + des_Hk
            }
            
            
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
            
            if des_En == "" && des_Hk == "" {
                self.des_all = "--"
            }
            if des_En == "" && des_Hk != "" {
                self.des_all = des_Hk
            }
            if des_En != "" && des_Hk == "" {
                self.des_all = des_En
            }
            if des_En != "" && des_Hk != "" {
                self.des_all = des_Hk + "\n" + des_En
            }
        }
        
        self.dish_H = self.name1.getTextHeigh(SFONT(13), S_W - 170) + self.name2.getTextHeigh(SFONT(11), S_W - 170) + 25
        self.cell_H = self.dish_H
    }
    
    
    
    
    
    
    private func getOptionHeight() {
        
        var tH: CGFloat = 0
        for model in self.optionArr {
            tH += model.option_H
            for oModel in model.itemArr {
                tH += oModel.optionItem_H
            }
        }
        cell_H = tH + dish_H
    }

    
    func updateAttachModel(json: JSON) {
        self.c_id = json["classifyId"].stringValue
        self.id = json["attachId"].stringValue
        self.statusID = json["statusId"].stringValue
        self.price = D_2_STR(json["price"].doubleValue)
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
            
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
        }
    }
    
    func updateGiftModel(json: JSON) {
        self.c_id = json["classifyId"].stringValue
        self.id = json["giftId"].stringValue
        self.statusID = json["statusId"].stringValue
        self.price = D_2_STR(json["price"].doubleValue)
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
            
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
        }
    }

}


class DishOptionModel: NSObject {
    
    var name_En: String = ""
    var name_Hk: String = ""
    
    ///状态ID  1上架 2下架
    var statusId: String = ""
    ///规格ID
    var specId: String = ""
    ///是否必选 1是 2否
    var required: String = ""
    
    ///规格选项
    var itemArr: [DishOptionItemModel] = []
    
    
    var name1: String = ""
    var name2: String = ""
    
    var option_H: CGFloat = 0
    
    
    
    
    func updateModel(json: JSON) {
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue
        self.statusId = json["statusId"].stringValue
        self.specId = json["specId"].stringValue
        self.required = json["required"].stringValue
        
        var tArr: [DishOptionItemModel] = []
        for jsondata in json["optionList"].arrayValue {
            let model = DishOptionItemModel()
            model.updateModel(json: jsondata)
            tArr.append(model)
        }
        self.itemArr = tArr
        
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
        }
        
        
        self.option_H = self.name1.getTextHeigh(SFONT(13), S_W - 110) + self.name2.getTextHeigh(SFONT(11), S_W - 110) + 15
    }
    
    
    
}


class DishOptionItemModel: NSObject {
    
    var name_En: String = ""
    var name_Hk: String = ""
    
    ///状态ID  1上架 2下架
    var statusId: String = ""

    var optionId: String = ""
    var price: Double = 0
    
    
    var name1: String = ""
    var name2: String = ""
    
    var optionItem_H: CGFloat = 0

    
    func updateModel(json: JSON) {
        self.name_En = json["nameEn"].stringValue == "" ? "--" : json["nameEn"].stringValue
        self.name_Hk = json["nameHk"].stringValue == "" ? "--" : json["nameHk"].stringValue
        self.optionId = json["optionId"].stringValue
        self.price = json["price"].doubleValue
        self.statusId = json["statusId"].stringValue
        
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.name1 = self.name_En
            self.name2 = self.name_Hk
        } else {
            self.name1 = self.name_Hk
            self.name2 = self.name_En
        }
        
        self.optionItem_H = self.name1.getTextHeigh(SFONT(13), S_W - 190) + self.name2.getTextHeigh(SFONT(11), S_W - 190) + 15

    }
}





