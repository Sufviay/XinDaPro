//
//  CartDishModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/18.
//

import UIKit

class CartModel: NSObject {
    
    var showJiaoqi: Bool = false
    var dishesList: [CartDishModel] = []
}

class CartDishItemModel: NSObject {
    
    var nameEn: String = ""
    var nameHk: String = ""
    var itemID: String = ""
    
    var price: Double = 0
    
    var cell_H: CGFloat = 0
    
    //1规格选项。2套餐菜品。3附加
    var itemType: String = ""
    
    
    func updateModel(en: String, hk: String, id: String, pr: Double, type: String) {
        nameEn = en
        nameHk = hk
        itemID = id
        price = pr
        itemType = type
        
        if type != "3" {
            let a_h = nameEn.getTextHeigh(BFONT(11), S_W - 110) + nameHk.getTextHeigh(SFONT(11), S_W - 110)
            cell_H = (a_h + 10) > 40 ? (a_h + 10) : 40
        } else {
            let t_h = nameEn.getTextHeigh(BFONT(10), S_W - 225) + nameHk.getTextHeigh(SFONT(10), S_W - 225)
            cell_H = (t_h + 15) > 45 ? (t_h + 15) : 45

        }
    }
}



class CartDishModel: NSObject {
    
    
    /**
     * 根据分隔线情况，给菜品设置分组参数
     * 如果“叫起”为开始，那么printSort从1（可能是100）开始计数，否则从2（可能是99）开始
     * 如果“叫起”为结束，那么printSort从99结束，否则正常计数结束
     * 如果只有一组printSort，开始时有“叫起”，结束时有“叫起”时：printSort = 100
     * 如果只有一组printSort，开始时没有“叫起”，结束时有“叫起”时 printSort = 99
     */
    

    ///菜品编码[...]
    var dishesId: String = ""
    ///购买数量[...]
    var buyNum: Int = 1
    ///打印顺序（必须大于0）[...]
    var printSort: Int = 1
    ///菜品选项、套餐菜品列表（若无则传null）[...]
    var itemList: [CartDishItemModel] = []
    /// 菜品附加列表（若无则传null）[...]
    var attachList: [CartDishItemModel] = []
    
    ///是否展示叫起
    var showJiaoqi: Bool = false
    
    
    var cell_H: CGFloat = 0
    
    var name_H: CGFloat = 0
    
    var nameEn: String = ""
    var nameHk: String = ""
    var dishesCode: String = ""
    var price: Double = 0
    ///1单品2套餐
    var dishType: String = ""
    
    var isGiveOne: Bool = false
    
    
    
    func updateModel(model: DishModel, selectOption: [OptionModel], selectCombo: [ComboDishesModel], selectAttach: [AttachModel]) {
        
        nameEn = model.dishesNameEn
        nameHk = model.dishesNameHk
        isGiveOne = model.giveOne == "2" ? true : false
        dishesId = model.dishesId
        dishesCode = model.dishesCode
        price = model.price
        dishType = model.dishesType
        
        if dishType == "1" {
            //单品
            var tArr: [CartDishItemModel] = []
            for model in selectOption {
                let item = CartDishItemModel()
                item.updateModel(en: model.optionNameEn, hk: model.optionNameHk, id: model.optionId, pr: model.price, type: "1")
                tArr.append(item)
            }
            itemList = tArr
        }
        
        if dishType == "2" {
            //套餐
            var tArr: [CartDishItemModel] = []
            for model in selectCombo {
                let item = CartDishItemModel()
                item.updateModel(en: model.dishesNameEn, hk: model.dishesNameHk, id: model.dishesComboRelId, pr: 0, type: "2")
                tArr.append(item)
            }
            itemList = tArr
        }
        
        var tArr: [CartDishItemModel] = []
        for model in selectAttach {
            let item = CartDishItemModel()
            item.updateModel(en: model.nameEn, hk: model.nameHk, id: model.attachId, pr: model.price, type: "3")
            tArr.append(item)
        }
        attachList = tArr
        
            
        
        //计算名字的高度
        let t_h = nameEn.getTextHeigh(BFONT(11), S_W - 170) + nameHk.getTextHeigh(SFONT(11), S_W - 170)
        name_H = (t_h + 30 + 10) > 75 ? (t_h + 30 + 10) : 75
        
        
        var a_h: CGFloat = 0
        for item in itemList {
            a_h += item.cell_H
        }
        for item in attachList {
            a_h += item.cell_H
        }
        if isGiveOne {
            a_h += 45
        }
        cell_H = a_h + name_H
    }
    
    
}
