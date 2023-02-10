//
//  MenuOrderManager.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/20.
//

import UIKit
import SwiftyJSON
import HandyJSON
import CoreMedia

class MenuOrderManager: NSObject {

    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    ///所有菜的数据
//    func initAllDishModel(dataArr: [ClassiftyModel]) -> [DishModel] {
//        var tArr: [DishModel] = []
//        for model in dataArr {
//            tArr += model.dishArr
//        }
//        return tArr
//    }
    
    
    ///计算菜品选择规格后的价格
    func selectedSizeDishMoney(dishModel: DishModel, selectIdxArr: [[Int]], count: Int) -> String {
        
        
        
        var orPrice: Double = dishModel.discountType == "2" ? Double(dishModel.discountPrice) : Double(dishModel.price)
        
        for (idx, model) in dishModel.specification.enumerated() {
            
            var optionPrice: Double = 0
            
            ///选项下标数组
            let idxArr_Option = selectIdxArr[idx]
            
            for count in idxArr_Option {
                optionPrice += model.optionArr[count - 1].fee
            }
            
            orPrice += optionPrice
        }
        
        let allPrice = orPrice * Double(count)
        
        return String(format: "%.2f", allPrice)
    }
    
    
    
    
    ///判断菜品规格是否选择齐全
    func dishSizeIsSelected(dishModel: DishModel, selectIdxArr: [[Int]]) -> Bool {
        
        for (idx, model) in dishModel.specification.enumerated() {
            let arr = selectIdxArr[idx]
            if model.isRequired && model.isOn {
                if arr.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    
    
    ///生成已选择的菜品规格字典
    func getSizeDicbySelected(selectIdxArr: [[Int]], dishModel: DishModel) -> [[String: String]] {
        
        var returnArr: [[String: String]] = []
        for (idx, idxArr) in selectIdxArr.enumerated() {
            
            for count in idxArr {
                let dic = ["optionId": dishModel.specification[idx].optionArr[count - 1].optionID,
                           "specId": dishModel.specification[idx].specificationID]
                returnArr.append(dic)
            }
            
//            if count != 1000 {
//                let dic = ["optionId": dishModel.specification[idx].optionArr[count - 1].optionID,
//                           "specId": dishModel.specification[idx].specificationID]
//                returnArr.append(dic)
//            }
        }
        return returnArr
    }
    
    
    ///更新购物车商品数组
    func updateCartDishArr(json: JSON) -> [CartDishModel] {
        var tArr: [CartDishModel] = []
        for jsonData in json["data"]["dishesList"].arrayValue {
            let model = CartDishModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        return tArr
    }

    
    
//    //比对拼接选择规格后的菜品列表
//    func getDishesListByCart(cartJson: JSON, curDishArr: [DishModel]) {
//
//        for jsonData in cartJson["data"]["dishesList"].arrayValue {
//            let model = CartDishModel()
//            model.updateModel(json: jsonData)
//
//            for dishModel in curDishArr {
//                //菜品被禁用。菜品规格选项被禁用 无法购买
//                if model.isOn && model.isOn_Opt && model.cartDishID == dishModel.dishID {
//                    dishModel.cart.append(model)
//                }
//            }
//        }
//    }
    
    
    
    ///通过分类 菜品 和购物车的数据生成点餐页面的赋值数据
    func getMenuDishesData(c_arr: [ClassiftyModel], d_arr: [DishModel], cart_arr: [CartDishModel]) -> [ClassiftyModel] {


        for model in c_arr {
            model.dishArr.removeAll()
        }

        for model in d_arr {
            model.sel_Num = 0
            model.cart.removeAll()
        }
        
        
        ///首先 用购物车的菜品对所有菜品的已选择数量进行赋值
        for cart_model in cart_arr {
            
            for d_model in d_arr {
                if cart_model.cartDishID == d_model.dishID {
                    d_model.cart.append(cart_model)
                    d_model.sel_Num += cart_model.cartCount
                }
            }
        }
        
        ///再将菜品插入分类中
        for d_model in d_arr {
            
            for c_model in c_arr {
                if d_model.belongClassiftyID == c_model.flID {
                    c_model.dishArr.append(d_model)
                }
            }
        }
                
        return c_arr
    }
    
    
    ///获取购物车添加的菜品数量
    func getCartAddedNum(cart_arr: [CartDishModel]) -> Int {
        
        var tNum = 0
        for model in cart_arr {
            tNum += model.cartCount
        }
        return tNum
    }
    
}
