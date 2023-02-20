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
    
    
    ///计算套餐菜品选择后的价格
    func selectedComboDishMoney(dishModel: DishModel, count: Int) -> String {
        
        var orPrice: Double = dishModel.discountType == "2" ? Double(dishModel.discountPrice) : Double(dishModel.price)
        
        let price = orPrice * Double(count)
        
        return String(format: "%.2f", price)

    }
    
    
    ///生成已选择菜品的参数组合，添加购物车时用
    func getComboDicBySelected(selectIdxArr: [Int], dishModel: DishModel) -> [[String: String]] {
        
        var returnArr: [[String: String]] = []
        for (idx, count) in selectIdxArr.enumerated() {
            let dic = ["optionId": dishModel.comboList[idx].comboDishesList[count].dishesComboRelId,
                       "specId": dishModel.comboList[idx].comboSpecID]
            returnArr.append(dic)
        }
        return returnArr
        
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
    
    
    ///挑选出套餐，并将菜品插入分类中
    func dealWithMenuDishesBy(classify_Arr: [ClassiftyModel], dishes_Arr: [DishModel]) -> MenuModel {
        
        ///筛选套餐菜品
        let lunch_D: [DishModel] = dishes_Arr.filter { $0.dishesType == "2" }
        ///筛选单品
        let dinner_D: [DishModel] = dishes_Arr.filter { $0.dishesType != "2" }
        
        
        ///再将菜品插入分类中
        for d_model in dinner_D {
            
            for c_model in classify_Arr {
                if d_model.belongClassiftyID == c_model.flID {
                    c_model.dishArr.append(d_model)
                }
            }
        }
        
        let menuData = MenuModel()
        menuData.dinnerDataArr = classify_Arr.filter{ $0.dishArr.count != 0 }
        menuData.lunchDataArr = lunch_D
        return menuData
    }

    
    
    func dealWithMenuDishesByCartData(cart_arr: [CartDishModel], menuModel: MenuModel) {
        
        //清空操作
        for d_model in menuModel.lunchDataArr {
            d_model.sel_Num = 0
            d_model.cart.removeAll()
        }
        
        for c_model in menuModel.dinnerDataArr {
            for d_model in c_model.dishArr {
                d_model.sel_Num = 0
                d_model.cart.removeAll()
            }
        }
        
        
        //遍历购物车中的菜品
        for cart_model in cart_arr {
            if cart_model.dishesType == "2" {
                //套餐
                //将购物车插入到菜品中
                for d_model in menuModel.lunchDataArr {
                    if cart_model.dishID == d_model.dishID {
                        d_model.cart.append(cart_model)
                        d_model.sel_Num += cart_model.cartCount
                    }
                }
                
            } else {
                //单品
                for c_model in menuModel.dinnerDataArr {
                    for d_model in c_model.dishArr {
                        if cart_model.dishID == d_model.dishID {
                            d_model.cart.append(cart_model)
                            d_model.sel_Num += cart_model.cartCount
                        }
                    }
                    
                }
            }
        }
        //return menuModel
    }
    
    
    
    
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
