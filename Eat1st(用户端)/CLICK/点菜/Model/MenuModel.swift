//
//  MenuModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/20.
//

import UIKit
import SwiftyJSON


//MARK: - 构建页面的数据Model
class MenuModel: NSObject {
    
    ///总的菜品数据
    var allDataArr:[ClassiftyModel] = []
    
    ///营业时间列表
    var openTimeArr: [OpenTimeModel] = []
        
    ///当前的时间段
    var curentTime = OpenTimeModel()
    
    ///当前时间段的位置下标
    var curTimeIdx: Int = 1000 {
        didSet {
            pageDataArr = openTimeArr[curTimeIdx].dataArr
        }
    }
    
    ///当前选择的菜品分类位置下标
    var classifyIdx: Int = 0
    
    ///是否改变时间段
    var isChangeSelectTime: Bool = false
    
    ///页面展示的菜品数据  根据点击时间段的变化 来改变菜品数据
    var pageDataArr: [ClassiftyModel] = []
    
    ///初始店铺的购买状态 1外卖 2自取 ""为关店状态
    var buyType: String = "1"

    ///根据购物车菜品处理之后的单品数据
    //var dinnerDataArr: [ClassiftyModel] = []
    ///购物车处理之后的套餐商品
    //var lunchDataArr: [DishModel] = []
    
    
    
    func updateModel(json: JSON) {
                
        ///时间段列表数据
        var tArr1: [OpenTimeModel] = []
        for jsonData in json["data"]["openTimeList"].arrayValue {
            let model = OpenTimeModel()
            model.updateModel(json: jsonData)
            
            var c_arr: [ClassiftyModel] = []
            for c_json in json["data"]["classifyList"].arrayValue {
                let model = ClassiftyModel()
                model.updateModel(json: c_json)
                c_arr.append(model)
            }
            model.dataArr = c_arr
            tArr1.append(model)
        }
        self.openTimeArr = tArr1

        ///当前时间所在的时间段
        if (openTimeArr.filter { $0.nowType == "2" }).count != 0 {
            self.curentTime = (openTimeArr.filter { $0.nowType == "2" })[0]
            
            ///设置当前店铺的购买方式 1外卖 2自取 ""为关店状态
            
            if curentTime.deliverStatus == "1" {
                buyType = "1"
            } else {
                if curentTime.collectStatus == "1" {
                    buyType = "2"
                } else {
                    buyType = "1"
                }
            }
        }
        
        
        ///分类列表
        var c_arr: [ClassiftyModel] = []
        for c_json in json["data"]["classifyList"].arrayValue {
            let model = ClassiftyModel()
            model.updateModel(json: c_json)
            c_arr.append(model)
        }

        
        ///菜品列表
        var d_arr: [DishModel] = []
        for d_json in json["data"]["dishesList"].arrayValue {
            let model = DishModel()
            model.updateModel(json: d_json)
            d_arr.append(model)
        }
        
        /**
         将菜品插入该有的分类中去
         */

        for d_model in d_arr {
            
            for c_model in c_arr {
                if d_model.belongClassiftyID == c_model.flID {
                    c_model.dishArr.append(d_model)
                }
            }
        }
        
        ///处理后的菜品总数据
        self.allDataArr = c_arr.filter{ $0.dishArr.count != 0 }
        
        /**
         根据菜品编码和营业时间编码的关系整理菜品
         */
        for jsonData in json["data"]["timeDishesList"].arrayValue {
            //菜品ID
            let dishID = jsonData["dishesId"].stringValue
            ///根据菜品ID找到菜品model
            if (d_arr.filter { $0.dishID == dishID }).count != 0 {
                let d_model = (d_arr.filter { $0.dishID == dishID })[0]
                
                //时间段ID
                let timeID = jsonData["storeTimeId"].stringValue
                //根据时间段ID 找到时间段
                for openModel in openTimeArr {
                    if openModel.storeTimeId == timeID {
                        //将菜品放入相对应的分类下
                        for c_model in openModel.dataArr {
                            if d_model.belongClassiftyID == c_model.flID {
                                c_model.dishArr.append(d_model)
                            }
                        }
                    }
                }
            }
                        
        }
        
        //去除时间列表中无菜品的空分类
        for openModel in openTimeArr {
            openModel.dataArr = openModel.dataArr.filter { $0.dishArr.count != 0 }
        }
        
        ///获取默认显示
        if openTimeArr.count != 0 {
            for (idx, model) in openTimeArr.enumerated() {
                if model.defaultShow == "2" {
                    self.curTimeIdx = idx
                }
            }
        } else {
            self.pageDataArr = allDataArr
        }
    }
    
    
    //根据购物车数据对菜品进行赋值
    func dealWithMenuDishesByCartData(cart_arr: [CartDishModel]) {
        
        //清空以选择的
        for c_model in self.allDataArr {
            for d_model in c_model.dishArr {
                d_model.sel_Num = 0
                d_model.cart.removeAll()
            }
        }
        
        
        
        //遍历购物车中的菜品
        for cart_model in cart_arr {
//            if cart_model.dishesType == "2" {
//                //套餐
//                //将购物车插入到菜品中
//                for d_model in menuModel.lunchDataArr {
//                    if cart_model.dishID == d_model.dishID {
//                        d_model.cart.append(cart_model)
//                        d_model.sel_Num += cart_model.cartCount
//                    }
//                }
//
//            } else {
                //单品
                for c_model in self.allDataArr {
                    for d_model in c_model.dishArr {
                        if cart_model.dishID == d_model.dishID {
                            d_model.cart.append(cart_model)
                            d_model.sel_Num += cart_model.cartCount
                        }
                    }
                    
                }
//            }
        }
        
    }
}


//MARK: - 营业时间段Model
class OpenTimeModel: NSObject {
    
    ///当前时间是否在时间段内 (1否，2是)
    var nowType: String = ""
    ///默认显示 （1否，2是）进入页面tab显示用
    var defaultShow: String = ""
    
    ///自取时间
    var collectMax: String = ""
    var collectMin: String = ""
    ///自取状态(1开启，2关闭)
    var collectStatus: String = ""
    ///外卖时间
    var deliverMax: String = ""
    var deliverMin: String = ""
    ///外卖状态（1开启，2关闭）
    var deliverStatus: String = ""
    
    ///营业时间
    var startTime: String = ""
    var endTime: String = ""
    
    ///时间段名称
    var name: String = ""
    ///时间段ID
    var storeTimeId: String = ""
    
    ///营业时间关联的菜品
    var dataArr: [ClassiftyModel] = []
    
    
    
    func updateModel(json: JSON) {
        self.storeTimeId = json["storeTimeId"].stringValue
        self.name = json["name"].stringValue
//        self.startTime = json["startTime"].stringValue
//        self.endTime = json["endTime"].stringValue
        self.deliverStatus = json["deliverStatus"].stringValue
        self.deliverMax = json["deliverMax"].stringValue
        self.deliverMin = json["deliverMin"].stringValue
        self.collectStatus = json["collectStatus"].stringValue
        self.collectMax = json["collectMax"].stringValue
        self.collectMin = json["collectMin"].stringValue
        self.nowType = json["nowType"].stringValue
        self.defaultShow = json["defaultShow"].stringValue
        
    }
    
    
}




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
    ///菜品的分类 （1单品 2套餐）
    var dishesType: String = ""
    
    
    
///以上点餐列表页面使用
    
    

    ///已售数量
    var sales: String = ""
    ///过敏原
    var allergen: String = ""

    ///菜品规格信息 菜品详情用
    var specification: [SpecificationModel] = []
    ///套餐菜品规格使用 菜品详情
    var comboList: [ComboSpecificationModel] = []
    
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
        self.dishesType = json["dishesType"].stringValue
        
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
        

        //单品
        let n_h = self.name_C.getTextHeigh(BFONT(17), S_W - 235)
        let d_h: CGFloat = self.des.getTextHeigh(SFONT(11), S_W - 235) > 25 ? 25 : self.des.getTextHeigh(SFONT(11), S_W - 235)
        
        if (S_W - 230) > 140 {
            //非放大模式
            self.dish_H = (n_h + d_h + 90) > 130 ? (n_h + d_h + 90) : 130
        } else {
            self.dish_H = (n_h + d_h + 80 + 30) > 130 ? (n_h + d_h + 80 + 30) : 130
        }
        
    
        
        var tArr2: [SpecificationModel] = []
        for jsonData in json["specList"].arrayValue {
            let model = SpecificationModel()
            model.updateModel(json: jsonData)
            tArr2.append(model)
        }
        self.specification = tArr2
        
        var tArr3: [ComboSpecificationModel] = []
        for jsonData in json["comboList"].arrayValue {
            let model = ComboSpecificationModel()
            model.updateModel(json: jsonData)
            tArr3.append(model)
        }
        self.comboList = tArr3
        
    }
}

//MARK: - 分类模型
class ClassiftyModel {
    
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
        //self.isOn = json["statusId"].stringValue == "1" ? true : false
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


//MARK: - 套餐菜品模型
class ComboDishModel: NSObject {
    ///套餐规格菜品编码
    var dishesComboRelId: String = ""
    ///菜品名称
    var dishesName: String = ""
    ///菜品图片
    var imageUrl: String = ""
    ///所属规格ID
    var belongID: String = ""
    ///菜品的Cell高度
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        self.dishesComboRelId = json["dishesComboRelId"].stringValue
        self.dishesName = json["dishesName"].stringValue
        self.imageUrl = json["imageUrl"].stringValue
        self.belongID = json["comboId"].stringValue
        
        let c_w = (S_W - 60) / 3
        let name_h = self.dishesName.getTextHeigh(BFONT(11), c_w - 20)
        self.cell_H = c_w + name_h + 20
        
        
    }
    
}


//MARK: - 套餐规格模型
class ComboSpecificationModel: NSObject {
    
    ///菜品列表
    var comboDishesList: [ComboDishModel] = []
    ///套餐规格编码
    var comboSpecID: String = ""
    ///套餐规格名称
    var comboSpecName: String = ""
    
    
    func updateModel(json: JSON) {
        
        self.comboSpecID = json["dishesComboId"].stringValue
        self.comboSpecName = json["dishesComboName"].stringValue
        
        var t_Arr: [ComboDishModel] = []
        for jsonData in json["comboDishesList"].arrayValue {
            let model = ComboDishModel()
            model.updateModel(json: jsonData)
            t_Arr.append(model)
        }
        self.comboDishesList = t_Arr
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
    
    ///购物车ID
    var cartID: String = ""
    ///菜品图片
    var dishImg: String = ""
    ///菜品名
    var dishName: String = ""
    ///启用 禁用状态 1启用 2禁用 3超库存 4不在营业时间内
    var isOn: String = ""
    ///菜品标签
    var tagList: [DishTagsModel] = []
    
    ///购物车页面的菜品高度
    var cart_dish_H: CGFloat = 0
    ///确认订单页面的菜品高度
    var confirm_cart_dish_H: CGFloat = 0
    
    
    ///菜品类型 1单品。2套餐
    var dishesType: String = ""
    ///拼接好的规格名
    var selectOptionStr: String = ""
    
    ///菜的优惠价格
    var discountPrice: Double = 0
    ///菜品是否有优惠 1无优惠 2有优惠
    var discountType: String = ""
    ///优惠百分比
    var discountSale: String = ""

    
    
    
    ///点餐页面的购物车
    func updateModel(json: JSON) {
        self.dishID = json["dishesId"].stringValue
        self.cartDishID = json["dishesId"].stringValue
        self.cartCount = json["buyNum"].intValue
        self.fee = json["price"].doubleValue
        self.cartID = json["carId"].stringValue
        self.dishName = json["dishesName"].stringValue
        self.dishImg = json["imageUrl"].stringValue
        self.dishesType = json["dishesType"].stringValue
        self.isOn = json["statusId"].stringValue
        
        
        

        var tArr1: [DishOptionModel] = []
        var tStr1: String = ""
        for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
            let model = DishOptionModel()
            model.updateModel(json: jsonData)
                        
            tArr1.append(model)
            if idx == 0 {
                tStr1 = model.name_E
            } else {
                if dishesType == "1" {
                    //单品
                    tStr1 = tStr1 + "/" + model.name_E
                } else {
                    tStr1 = tStr1 + "\n" + model.name_E
                }
            }
        }
        
        self.cartOptionArr = tArr1
        self.selectOptionStr = tStr1

        
        var tArr3: [DishTagsModel] = []
        for jsonData in json["tagList"].arrayValue {
            let model = DishTagsModel()
            model.updateModel(json: jsonData)
            tArr3.append(model)
        }
        self.tagList = tArr3
        
        ///菜品在购物车中显示的高度
        let n_h = self.dishName.getTextHeigh(BFONT(17), S_W - 160)
        let d_h = self.selectOptionStr.getTextHeigh(SFONT(11), S_W - 160)
        let h = (n_h + d_h + 90) > 130 ? (n_h + d_h + 90) : 130
        self.cart_dish_H = h
        
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
        
        
        var tStr: String = ""
        
        if dishesType == "2" {
            //套餐
            for (idx, jsonData) in json["comboNameList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    tStr = jsonData["comboDishesName"].stringValue
                } else {
                    tStr = tStr + "\n" + jsonData["comboDishesName"].stringValue
                }
            }
            self.selectOptionStr = tStr
            
            //计算高度
            let n_h = dishName.getTextHeigh(BFONT(14), S_W - 155)
            let t_h = selectOptionStr.getTextHeigh(SFONT(11), S_W - 195)
            self.confirm_cart_dish_H = n_h + t_h + 40 < 80 ? 80 : n_h + t_h + 40
            
        } else {
            //单品
            for (idx, jsonData) in json["optionNameList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    tStr = jsonData["optionName"].stringValue
                } else {
                    tStr = tStr + "/" + jsonData["optionName"].stringValue
                }
            }
            self.selectOptionStr = tStr

            //计算高度
            let n_h = dishName.getTextHeigh(BFONT(14), S_W - 155)
            let t_h = selectOptionStr.getTextHeigh(SFONT(11), S_W - 195)
            self.confirm_cart_dish_H = n_h + t_h + 40 < 80 ? 80 : n_h + t_h + 40
        }
        
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







