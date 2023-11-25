//
//  CouponModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/22.
//

import UIKit
import SwiftyJSON


class CouponModel: NSObject {
    
    ///优惠券金额
    var couponAmount: Double = 0
    ///优惠券类型（1折扣，2满减，3赠菜）
    var couponType: String = ""
    ///id
    var couponId: String = ""
    ///优惠券使用规则
    var couponRule: String = ""
    ///折扣比例（couponType=1时有值)
    var couponScale: Double = 0
    ///发放时间
    var createTime: String = ""
    ///菜品ID
    var dishesId: String = ""
    ///使用结束时间
    var endDate: String = ""
    ///使用开始时间
    var startDate: String = ""
    ///最低金额
    var orderPrice: Double = 0
    ///是否限制订单金额（1不限制，2限制） ,
    var orderPriceLimit: String = ""

    /// 是否可使用（1可使用，2不可用）
    var status: String = ""
    ///是否限制店铺（1不限制，2限制）
    var storeLimit: String = ""
    ///店铺名称（storeLimit=2时有值）
    var storeName: String = ""
    ///折扣上限金额 只有折扣有
    var couponLimitPrice: Double = 0
    
    
    ///优惠券的菜品列表
    var dishesList: [CartDishModel] = []

    
    
    ///选择的菜品名称
    var selDishesName: String = ""
    ///选择的优惠券菜品ID
    var selCouponUserDishesId: String = ""
    
    
    ///优惠券的名称
    var couponName: String = ""
    ///可用店铺
    var canUseStore: String = ""
    ///限制金额
    var limitPriceStr: String = ""
    
    
    
    
    ///Cell的高度
    var cell_H: CGFloat = 0
    
    ///优惠券内容高度
    var content_H: CGFloat = 0
    
    ///菜品的高度
    var dishesContent_H: CGFloat = 0
    
    ///是否需要展开规则
    var ruleNeedOpen: Bool = false
    
    
    
    
    ///规则是否展开
    var ruleIsOpen: Bool = false {
        didSet {
            
            let name_H = couponName.getTextHeigh(BFONT(11), S_W - 40)
            let store_H = canUseStore == "" ? 0 : canUseStore.getTextHeigh(BFONT(13), S_W - 155)
            let rule_H = couponRule.getTextHeigh(SFONT(10), S_W - 155)
            
            if ruleIsOpen {
                //展开 改变高度
                self.content_H = 80 + 15 + name_H + store_H + rule_H
                            
            } else {
                //关闭 改变高度
                self.content_H = 80 + 25  + name_H + store_H
            }
            
            cell_H = content_H + dishesContent_H + 15
        }
    }
    
    
    ///菜品是否展开
    var dishIsOpen: Bool = false {
        didSet {
            //菜品的总高度
            var t_H: CGFloat = 0
            for model in dishesList  {
                t_H += model.giftDish_H
            }


            if dishIsOpen {
                dishesContent_H = t_H + 35
            } else {
                dishesContent_H = 35
            }
            
            cell_H = content_H + dishesContent_H + 15
        }
    }

    
    
    
    
    
    
    func updateModel(json: JSON) {
        self.couponAmount = json["couponAmount"].doubleValue
        self.couponType = json["couponType"].stringValue
        self.couponId = json["couponId"].stringValue
        self.couponRule = json["couponRule"].stringValue
        self.couponScale = json["couponScale"].doubleValue
        self.createTime = json["createTime"].stringValue
        self.dishesId = json["dishesId"].stringValue
        self.endDate = json["endDate"].stringValue
        self.startDate = json["startDate"].stringValue
        self.orderPrice = json["orderPrice"].doubleValue
        self.orderPriceLimit = json["orderPriceLimit"].stringValue
        self.status = json["status"].stringValue
        self.storeLimit = json["storeLimit"].stringValue
        self.storeName = json["storeName"].stringValue
        self.couponLimitPrice = json["couponLimitPrice"].doubleValue
        
        
        
        
        if couponType == "1" {
            ///折扣
            self.couponName = "COUPON-Discount"
            
        }
        if couponType == "2" {
            ///满减
            self.couponName = "COUPON-Pound"
        }
        if couponType == "3" {
            ///赠送菜品
            self.couponName = "COUPON-Dishes"
        }
        
        if storeLimit == "1" {
            self.canUseStore = ""
        } else {
            self.canUseStore = "\(self.storeName)"
        }
        
        if orderPriceLimit == "1" {
            //不限制
            self.limitPriceStr = "All order available"
        } else {
            self.limitPriceStr = "For order above £\(D_2_STR(orderPrice))"
        }
        
        
        
        //判断使用规格的行数
        let ruleLine = couponRule.getStringLine(font: SFONT(10), strWidth: S_W - 155)
        if ruleLine > 1 {
            //超过一行
            self.ruleNeedOpen = true
        } else {
            self.ruleNeedOpen = false
        }
        
        
        
        var tArr: [CartDishModel] = []
        var t_H: CGFloat = 0
        for jsondata in json["dishesList"].arrayValue  {
            let model = CartDishModel()
            model.updateCouponModel(json: jsondata)
            tArr.append(model)
            t_H += model.giftDish_H
        }
        dishesList = tArr
        
        if dishesList.count == 0 {
            dishesContent_H = 0
        } else {
            dishesContent_H = 35
        }
        
        //初始高度 都是折叠的
        let name_H = couponName.getTextHeigh(BFONT(11), S_W - 40)
        let store_H = canUseStore == "" ? 0 : canUseStore.getTextHeigh(BFONT(13), S_W - 155)
        //15 + 15 + 35 + 40
        content_H = 105 + name_H + store_H
        
        self.cell_H = content_H + 15 + dishesContent_H
        
    }
    
    
    
}
