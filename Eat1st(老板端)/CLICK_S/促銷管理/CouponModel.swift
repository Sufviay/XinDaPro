//
//  CouponModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/19.
//

import UIKit
import HandyJSON
import SwiftyJSON


class CouponModel: HandyJSON {
    
    /// 使用限制（菜品最低金额，0不限制）[...]
    var dishesMinPrice: String = ""
    ///满减金额（coupon_type=2时有值）[...]
    var couponAmount: String = ""
    ///折扣上限金额（coupon_type=1时有值）[...]
    var couponLimitPrice: String = ""
    ///优惠券名称[...]
    var couponName: String = ""
    ///折扣比例（coupon_type=1时有值）[...]
    var couponScale: String = ""
    ///优惠券类型（1折扣，2满减，3赠菜）[...]
    var couponType: String = ""
    ///规则停止执行日期[...]
    var deadline: String = ""
    ///菜品IDcouponType=3 时传值[...]
    var dishesIdList: [Int64] = []
    ///有效天数[...]
    var effectiveDay: String = ""
    ///[...]
    var endDate: String = ""
    ///开始时间[...]
    var startDate: String = ""
    ///规则日（周几/几号）[...]
    var ruleDay: String = ""
    ///发放规则（1每周 2每两周 3每四周 4每月 5立即）[...]
    var ruleType: String = ""
    ///标签id
    var tagId: String = ""
    
    
    ///状态 0 进行中 1 结束 2停止
    var status: String = ""
    var id: String = ""
    var dishesArr: [String] = []
    var issueDateArr: [String] = []
    
    
    var couponContentStr: String = ""
    var ruleStr: String = ""
    var tagStr: String = ""
    
    var listCell_H: CGFloat = 0
    
    required init() {}
    
    
    
    func updateModel(json: JSON) {
        
        couponName = json["couponName"].stringValue
        couponType = json["couponType"]["id"].stringValue
        status = json["status"]["id"].stringValue
        couponScale = json["couponScale"].stringValue
        couponAmount = D_2_STR(json["couponAmount"].doubleValue)
        ruleType = json["ruleType"]["id"].stringValue
        deadline = json["deadline"].stringValue
        dishesMinPrice = D_2_STR(json["dishesMinPrice"].doubleValue)
        ruleDay = json["ruleDay"].stringValue
        id = json["id"].stringValue
        effectiveDay = json["effectiveDay"].stringValue
        startDate = json["startDate"].stringValue
        endDate = json["endDate"].stringValue
        couponLimitPrice = D_2_STR(json["couponLimitPrice"].doubleValue)
        
        
        
        
        let minprice = Double(dishesMinPrice) ?? 0
        //1折扣，2满减，3赠菜
        if couponType == "1" {
            if MyLanguageManager.shared.language == .Chinese {
                if minprice > 0 {
                    couponContentStr = "滿£\(dishesMinPrice)即可享受\(couponScale)%的折扣"
                } else {
                    couponContentStr = "任意金額即可享受\(couponScale)%的折扣"
                }
            } else {
                if minprice > 0 {
                    couponContentStr = "Get \(couponScale)% discount for up £\(dishesMinPrice)"
                } else {
                    couponContentStr = "Get \(couponScale)% discount for any amount"
                }
            }
        }
        
        if couponType == "2" {
            if MyLanguageManager.shared.language == .Chinese {
                if minprice > 0 {
                    couponContentStr = "滿£\(dishesMinPrice)即可享受£\(couponAmount)的折扣"
                } else {
                    couponContentStr = "任意金額即可享受£\(couponAmount)的折扣"
                }
            } else {
                if minprice > 0 {
                    couponContentStr = "Get £\(couponAmount) discount for up £\(dishesMinPrice)"
                } else {
                    couponContentStr = "Get £\(couponAmount) discount for any amount"
                }
            }
        }
        
        if couponType == "3" {
            if MyLanguageManager.shared.language == .Chinese {
                if minprice > 0 {
                    couponContentStr = "滿£\(dishesMinPrice)即可贈送菜品"
                } else {
                    couponContentStr = "任意金額即可贈送菜品"
                }

            } else {
                if minprice > 0 {
                    couponContentStr = "Get free dishes for up £\(dishesMinPrice)"
                } else {
                    couponContentStr = "Get free dishes for any amount"
                }

            }
        }
        
        
        
        //1每周 2每两周 3每四周 4每月）
        if ruleType == "1" {
            ruleStr = "Every week on ".local + getWeekStr(type: ruleDay)
        }
        if ruleType == "2" {
            ruleStr = "Every two weeks on ".local + getWeekStr(type: ruleDay)
        }
        if ruleType == "3" {
            ruleStr = "Every four weeks on ".local + getWeekStr(type: ruleDay)
        }
        if ruleType == "4" {
            if MyLanguageManager.shared.language == .Chinese {
                ruleStr = "每月\(ruleDay)號"
            } else {
                ruleStr = "The \(ruleDay)th of each month"
            }
        }
        if ruleType == "5" {
            ruleStr = "Immediately".local
        }
        
        let h1 = couponName.getTextHeigh(TIT_4, S_W - 100) + 25
        let h2 = couponContentStr.getTextHeigh(TIT_3, S_W - 40) + 35
        let h3 = ruleStr.getTextHeigh(TIT_3, S_W - 40) + 35
        listCell_H = 80 + h1 + h2 + h3 + 15
        
        
        
        if couponType == "3" {
            var nameArr: [String] = []
            for jsondata in json["dishesResultList"].arrayValue {
                if MyLanguageManager.shared.language == .Chinese {
                    nameArr.append(jsondata["nameHk"].stringValue)
                } else {
                    nameArr.append(jsondata["nameEn"].stringValue)
                }
                
            }
            dishesArr = nameArr
        }
        
        var issueArr: [String] = []
        for jsondata in json["issueResultList"].arrayValue {
            issueArr.append(jsondata["issueDate"].stringValue)
        }
        issueDateArr = issueArr
        
        
        if MyLanguageManager.shared.language == .Chinese {
            tagStr = json["tagResult"]["nameHk"].stringValue
            if tagStr == "" {
                tagStr = "全部"
            }
            
        } else {
            tagStr = json["tagResult"]["nameEn"].stringValue
            if tagStr == "" {
                tagStr = "All"
            }
        }
        
    }
    
    
    private func getWeekStr(type: String) -> String {
        
        var msg = ""
        
        if type == "1" {
            msg = "Monday".local
        }
        if type == "2" {
            msg = "Tuesday".local
        }
        if type == "3" {
            msg = "Wednesday".local
        }
        if type == "4" {
            msg = "Thursday".local
        }
        if type == "5" {
            msg = "Friday".local
        }
        if type == "6" {
            msg = "Saturday".local
        }
        if type == "7" {
            msg = "Sunday".local
        }

        return msg
        
    }
    

}
