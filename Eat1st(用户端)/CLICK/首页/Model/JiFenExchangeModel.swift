//
//  JiFenExchangeModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/9.
//

import UIKit
import SwiftyJSON



class ExchangeClassModel: NSObject {
    
    var classifyID: String = ""
    var classifyName: String = ""
    
    var couponList: [JiFenExchangeModel] = []
    
    
    func updateModel(json: JSON) {
        self.classifyID = json["classifyId"].stringValue
        self.classifyName = json["classifyName"].stringValue
    }
    
    
}

class JiFenExchangeModel: NSObject {
    
    ///分类ID
    var classifyID: String = ""
    ///折扣上限金额 只有折扣有
    var couponLimitPrice: Double = 0
    ///满减金额
    var couponPrice: Double = 0
    ///折扣比例（couponType=1时有值)
    var couponScale: Double = 0
    ///优惠券类型（1折扣，2满减，3赠菜）
    var couponType: String = ""
    ///使用限制（菜品最低金额，0不限制） ,
    var dishesMinPrice: Double = 0
    ///菜品名称（当coupon_type=3时） ,
    var dishesName: String = ""
    ///有效期（结束）
    var endDate: String = ""
    ///有效期（开始）
    var startDate: String = ""
    ///积分优惠券编码
    var pointsCouponId: String = ""
    ///兑换积分数量
    var pointsNum: Int = 0
    ///使用规则
    var useRule: String = ""

    

    ///优惠券的名称
    var couponName: String = ""
    ///限制金额
    var limitPriceStr: String = ""
    ///可用店铺
    var canUseStore: String = ""
    
    

    
    
    ///Cell的高度
    var cell_H: CGFloat = 0
    ///是否需要展开规则
    var ruleNeedOpen: Bool = false
    
    ///规则是否展开
    var ruleIsOpen: Bool = false {
        didSet {
            
            let name_H = couponName.getTextHeigh(BFONT(11), S_W - 140)
            let store_H = canUseStore == "" ? 0 : canUseStore.getTextHeigh(BFONT(13), S_W - 160)
            let rule_H = useRule.getTextHeigh(SFONT(10), S_W - 195)
            
            if ruleIsOpen {
                //展开 改变高度
                self.cell_H = 48 + 30 + name_H + store_H + rule_H
                
            } else {
                //关闭 改变高度
                self.cell_H = 48 + 40  + name_H + store_H
            }

        }
    }

    
    
    func updateModel(json: JSON) {

        self.classifyID = json["classifyId"].stringValue
        self.couponLimitPrice = json["couponLimitPrice"].doubleValue
        self.couponPrice = json["couponPrice"].doubleValue
        self.couponScale = json["couponScale"].doubleValue
        self.couponType = json["couponType"].stringValue
        self.dishesMinPrice = json["dishesMinPrice"].doubleValue
        self.dishesName = json["dishesName"].stringValue
        self.endDate = json["endDate"].stringValue
        self.pointsCouponId = json["pointsCouponId"].stringValue
        self.pointsNum = json["pointsNum"].intValue
        self.startDate = json["startDate"].stringValue
        self.useRule = json["useRule"].stringValue
        
        
        
        
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
            self.couponName = "COUPON-\(dishesName)"
        }
        
        
        
        if dishesMinPrice == 0 {
            //不限制
            self.limitPriceStr = "All order available"
        } else {
            self.limitPriceStr = "For order above £\(D_2_STR(dishesMinPrice))"
        }
        
        
        //判断使用规格的行数
        let ruleLine = useRule.getStringLine(font: SFONT(10), strWidth: S_W - 195)
        if ruleLine > 1 {
            //超过一行
            self.ruleNeedOpen = true
        } else {
            self.ruleNeedOpen = false
        }
        
        //初始高度 都是折叠的
        let name_H = couponName.getTextHeigh(BFONT(11), S_W - 140)
        let store_H = canUseStore == "" ? 0 : canUseStore.getTextHeigh(BFONT(13), S_W - 160)
        
        //15 + name_H + 8 + store_H + 25 + 40
        self.cell_H = 88  + name_H + store_H
        
    }
    
    
}
