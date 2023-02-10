//
//  MenuModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/20.
//

import UIKit
import SwiftyJSON


class DishTagsModel: NSObject {
    
    var tagName: String = ""
    var tagImg: String = ""
    
    func updateModel(json: JSON) {
        self.tagName = json["tagName"].stringValue
        self.tagImg = json["imageUrl"].stringValue
    }
    
}





class DishModel: NSObject {
    
    
    ///菜品所属分类ID
    var belongClassiftyID: String = ""
    ///id
    var dishID: String = ""
    ///菜名中文
    var name_C: String = ""
    ///菜名英文
    var name_E: String = ""
    ///1启用 2禁用 3超库存
    var isOn: String = ""
    ///禁用文字
    var unAlbleMsg: String = ""
    
    ///是否需要选择规格
    var isSelect: Bool = false
    ///列表图片
    var listImg: String = ""
    ///价格 原价
    var price: Double = 0
    ///优惠后的价格
    var discountPrice: Double = 0
    ///是否有优惠 1无优惠  2有优惠
    var discountType: String = ""
    
    ///优惠百分比
    var discountSale: String = ""
    
    ///是否是新品
    var isNew: Bool = false
    
    
    
    ///描述
    var des: String = ""
    ///标签
    var tagList: [DishTagsModel] = []
    ///已购买数量
    var sel_Num: Int = 0
    ///商品高度
    var dish_H: CGFloat = 0
    
    
    
///以上点餐列表页面使用
    
    

    ///已售数量
    var sales: String = ""
    ///过敏原
    var allergen: String = ""

    ///菜品规格信息 菜品详情用
    var specification: [SpecificationModel] = []
    ///购物车选择的规格菜品
    var cart: [CartDishModel] = []
    
    
    ///详情图片
    var detailImgArr: [String] = []
    
    
    
    
    ///模型下标
    var modelIdx: Int = 0

    
    
    func updateModel(json: JSON) {
        
                
        self.dishID = json["dishesId"].stringValue
        self.name_C = PJCUtil.dealHtmlZhuanYiString(contentStr: json["dishesName"].stringValue)
        self.name_E = PJCUtil.dealHtmlZhuanYiString(contentStr: json["dishesName"].stringValue)
        self.des = PJCUtil.dealHtmlZhuanYiString(contentStr: json["remark"].stringValue)
        self.price = json["price"].doubleValue
        self.sales = json["sales"].stringValue
        self.allergen = PJCUtil.dealHtmlZhuanYiString(contentStr: json["allergen"].stringValue)
        self.listImg = json["imageUrl"].stringValue
        self.isSelect = json["haveSpec"].stringValue == "1" ? true : false
        self.isOn = json["statusId"].stringValue
        self.unAlbleMsg = json["statusMsg"].stringValue
        self.belongClassiftyID = json["classifyId"].stringValue
        
        self.discountPrice = json["discountPrice"].doubleValue
        self.discountType = json["discountType"].stringValue
        
        if price - discountPrice > 0 {
            let ts = (price - discountPrice) / price * 100
            self.discountSale = String(Int(floor(ts)))
        }
    
        
        var tArr: [String] = []
        for jsonData in json["imageList"].arrayValue {
            tArr.append(jsonData["url"].stringValue)
        }
        self.detailImgArr = tArr
        
        var tarr1: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tarr1.append(model)
        }
        self.tagList = tarr1
        
    
        let n_h = self.name_C.getTextHeigh(BFONT(17), S_W - 235)
        let d_h: CGFloat = self.des.getTextHeigh(SFONT(11), S_W - 235) > 25 ? 25 : self.des.getTextHeigh(SFONT(11), S_W - 235)
        
        if (S_W - 230) > 140 {
            //非放大模式
            self.dish_H = (n_h + d_h + 90) > 130 ? (n_h + d_h + 90) : 130
        } else {
            self.dish_H = (n_h + d_h + 80 + 30) > 130 ? (n_h + d_h + 80 + 30) : 130
        }
        

//        self.detailImg = json["detailImg"].stringValue
//        var tArr1: [CartDishModel] = []
//
//        if json["cart"].arrayObject == nil {
//            print("-----------aaaaaa--------------")
//            let model = CartDishModel()
//            model.updateModel(json: json["cart"])
//            tArr1 = [model]
//            self.cart = tArr1
//        } else {
//            for jsonData in json["cart"].arrayValue {
//                let model = CartDishModel()
//                model.updateModel(json: jsonData)
//                tArr1.append(model)
//            }
//            self.cart = tArr1
//        }
//
        var tArr2: [SpecificationModel] = []
        for jsonData in json["specList"].arrayValue {
            let model = SpecificationModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.specification = tArr2
    }
}

//MARK: - 分类模型
class ClassiftyModel: NSObject {
    
    var flName_C: String = ""
    var flName_E: String = ""
    var flID: String = ""
    ///状态 1启用 2禁用
    var isOn: Bool = true
    
    var dishArr: [DishModel] = []

    func updateModel(json: JSON) {
        self.flName_C = json["classifyName"].stringValue
        self.flName_E = json["classifyName"].stringValue
        self.flID = json["classify"].stringValue
        self.isOn = json["statusId"].stringValue == "1" ? true : false
        
        var tArr: [DishModel] = []
        for jsondata in json["dish"].arrayValue {
            let model = DishModel()
            model.belongClassiftyID = flID
            model.updateModel(json: jsondata)
            tArr.append(model)
        }
        self.dishArr = tArr
    }
}




///规格选项
class DishOptionModel: NSObject {
    
    ///价格
    var fee: Double = 0
    ///名字英文
    var name_E: String = ""
    ///名字中文
    var name_C: String = ""
    ///ID
    var optionID: String = ""
    ///所属规格ID
    var belongID: String = ""
    ///1 启用 2禁用
    var isOn: Bool = true
    
    
    func updateModel(json: JSON) {
        self.fee = json["price"].doubleValue
        self.name_E = json["optionName"].stringValue
        self.name_C = json["optionName"].stringValue
        self.optionID = json["optionId"].stringValue
        self.belongID = json["specId"].stringValue
        
        self.isOn = json["statusId"].stringValue == "1" ? true : false
        
    }
    
}

///规格Model
class SpecificationModel: NSObject {
    
    var name_C: String = ""
    var name_E: String = ""
    
    
    ///是否为必选  1否。2 是
    var isRequired: Bool = false
    
    ///是否可以多选  1否。2 是
    var isMultiple: Bool = false
    
    ///规格ID
    var specificationID: String = ""
    ///是否被禁用
    var isOn: Bool = true
    
    ///规格选项
    var optionArr: [DishOptionModel] = []
    
    func updateModel(json: JSON) {
        self.name_E = json["specName"].stringValue
        self.name_C = json["specName"].stringValue
        self.isRequired = json["required"].stringValue == "2" ? true : false
        self.isOn = json["statusId"].stringValue == "1" ? true : false
        self.isMultiple = json["multiple"].stringValue == "2" ? true : false
        
        self.specificationID = json["specId"].stringValue
        
        var tArr: [DishOptionModel] = []
        for jsonData in json["optionList"].arrayValue {
            let model = DishOptionModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        self.optionArr = tArr
        
    }
    
}


//MARK: - 购物车中的菜品模型
class CartDishModel: NSObject {
    
    ///菜品ID
    var dishID: String = ""
    
    ///购物车菜品ID
    var cartDishID: String = ""
    ///数量
    var cartCount: Int = 0
    ///菜的原价
    var fee: Double = 0
    ///购物车选择的规格选项
    var cartOptionArr: [DishOptionModel] = []
    ///拼接好的规格名
    var selectOptionStr: String = ""
    ///购物车ID
    var cartID: String = ""

    
    ///菜品图片
    var dishImg: String = ""
    ///菜品名
    var dishName: String = ""
    
    ///启用 禁用状态 1启用 2禁用 3超库存
    var isOn: String = ""
    
    ///规格是否有禁用的。已选中规格菜品中含有禁用的规格则菜品将不可购买
    var isOn_Opt: Bool = true
    
    ///菜品标签
    var tagList: [DishTagsModel] = []
    
    var dish_H: CGFloat = 0
    
    ///菜的优惠价格
    var discountPrice: Double = 0
    ///菜品是否有优惠 1无优惠 2有优惠
    var discountType: String = ""
    ///优惠百分比
    var discountSale: String = ""
    ///菜品类型 1正常购买，2优惠券赠菜
    var dishesType: String = ""
    
    
    
    
    
    ///点餐页面的购物车
    func updateModel(json: JSON) {
        self.cartDishID = json["dishesId"].stringValue
        self.cartCount = json["buyNum"].intValue
        self.fee = json["price"].doubleValue
        self.cartID = json["carId"].stringValue
        self.dishName = json["dishesName"].stringValue
        self.dishImg = json["imageUrl"].stringValue
        
        
        self.isOn = json["statusId"].stringValue
        
        
        

        var tArr: [DishOptionModel] = []

        var tStr: String = ""

        for (idx, jsonData) in json["dishesSpecOptionList"].arrayValue.enumerated() {
            let model = DishOptionModel()
            model.updateModel(json: jsonData)
            
            //判断是否有禁用的规格选项
            if !model.isOn {
                self.isOn_Opt = false
            }
            
            tArr.append(model)
            if idx == 0 {
                tStr = model.name_E
            } else {
                tStr = tStr + "/" + model.name_E
            }
        }
        self.cartOptionArr = tArr
        self.selectOptionStr = tStr
        
        var tArr2: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.tagList = tArr2
        
        
        ///菜品显示的高度
        let n_h = self.dishName.getTextHeigh(BFONT(17), S_W - 160)
        let d_h = self.selectOptionStr.getTextHeigh(SFONT(11), S_W - 160)
        let h = (n_h + d_h + 90) > 130 ? (n_h + d_h + 90) : 130
        self.dish_H = h
                
    }
    
    
    
    
    
    func updateConfirmModel(json: JSON) {
        
        
        self.dishID = json["dishesId"].stringValue
        self.cartCount = json["buyNum"].intValue
        self.fee = json["price"].doubleValue
        self.dishName = PJCUtil.dealHtmlZhuanYiString(contentStr: json["dishesName"].stringValue)
        self.dishImg = json["imageUrl"].stringValue
        self.cartID = json["carId"].stringValue
        
        self.discountPrice = json["discountPrice"].doubleValue
        self.discountType = json["discountType"].stringValue
        self.dishesType = json["dishesType"].stringValue
        
        if fee - discountPrice > 0 {
            let ts = (fee - discountPrice) / fee * 100
            self.discountSale = String(Int(floor(ts)))

        }
        
        
        var tArr1: [DishOptionModel] = []
        var tStr: String = ""
        
        for (idx, jsonData) in json["optionNameList"].arrayValue.enumerated() {
            let model = DishOptionModel()
            model.updateModel(json: jsonData)
            tArr1.append(model)
            
            if idx == 0 {
                tStr = model.name_E
            } else {
                tStr = tStr + "/" + model.name_E
            }
            
        }
        self.cartOptionArr = tArr1
        self.selectOptionStr = tStr
    
        var tArr2: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.tagList = tArr2
    }
    
}







