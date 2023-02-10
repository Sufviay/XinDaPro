//
//  StoreInfoModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/18.
//

import UIKit
import SwiftyJSON



class JTFeeModel: NSObject {
    
    var fee: Float = 0
    var grade: Float = 0
    
    func updateModel(json: JSON) {
        self.fee = json["deliveryPrice"].floatValue
        self.grade = json["deliveryDistance"].floatValue
    }
}





class DaySetTimeModel: NSObject {

    var weekDay: String  = ""
    var takeBegin: String = ""
    var takeEnd: String = ""
    
    var deliveryBegin: String = ""
    var deliveryEnd: String = ""
    
    //1开启，2关闭
    var deStatus: String = ""
    var coStatus: String = ""
    
    var id: String = ""
    
    func updateModel(json: JSON) {
        //self.id = json["id"].stringValue
        self.weekDay = json["week"].stringValue
        self.takeBegin = json["collectionStartTime"].stringValue
        self.takeEnd = json["collectionEndTime"].stringValue
        self.deliveryBegin = json["deliveryStartTime"].stringValue
        self.deliveryEnd = json["deliveryEndTime"].stringValue
        
        self.deStatus = json["deliveryStatus"].stringValue
        self.coStatus = json["collectionStatus"].stringValue
        
    }

}


class StoreInfoModel: NSObject {
    
    
    ///名字
    var name: String = ""
    ///封面图片
    var coverImg: String = ""
    ///评分
    var star: Double = 0
    /// 配送费字符串
    var deliveryInit: String = ""
    ///最高配送费
    var maxDelivery: Double = 0
    ///最低配送费
    var minDelivery: Double = 0
    ///最少配送时间
    var minTime: String = ""
    
    ///起送金额
    var minCharge: String = ""
    ///起送金额
    var minOrder: Double = 0
    
    ///距离
    var distance: String = ""
    ///标签
    var tags: String = ""
    
    
    
    ///logo
    var logoImg: String = ""
    ///评价数量
    var evaluateNum: String = ""
    ///描述
    var des: String = ""
    ///经度
    var lat: String = ""
    ///纬度
    var lng: String = ""
    ///电话
    var phone: String = ""
    ///店铺地址
    var storeAddress: String = ""
    ///店铺ID
    var storeID: String = ""
    ///阶梯配送费列表
    var feeList: [JTFeeModel] = []
    ///配送状态 1开启 2关闭
    var deStatus: String = ""
    ///自取状态 1开启 2关闭
    var coStatus: String = ""
    ///营业时间
    var timeArr: [DaySetTimeModel] = []
    ///自取时间
    var coMin: String = ""
    var coMax: String = ""
    ///配送时间
    var deMin: String = ""
    var deMax: String = ""
    

    ///折扣说明
    var discountMsg: String = ""
    ///是否有折扣
    var isDiscount: Bool = false
    ///折扣图片
    var discountImgUrl: String = ""
    
    var leftImgUrl: String = ""
    
    ///是否有首单优惠
    var isFirstDiscount: Bool?
    ///店铺首单是否开启
    var firstDiscountIsOpen: Bool = false
    ///店铺首单的优惠额度
    var firstDiscountScale: String = ""
    
    
    ///是否开启积分兑换
    var isOpenJiFen: Bool = false
    
    ///是否显示折扣栏
    var isHaveDiscountBar: Bool = false

    
    
//    ///店铺状态 0闭店 1只配送  2只自取  3都可以
//    var status: String = ""
//    ///店铺是否可配送
//    var isDelivery: Bool = false
//    ///店铺是否可自取
//    var isTake: Bool = false
//    ///支付方式   1：在线支付  2：现金支付、3：均可
//    var payWay: String = ""
//    
//    ///店铺标签
//    var storeTags: String = ""
    
    
    

    func updateModel(json: JSON) {
        self.name = json["storeName"].stringValue
        self.tags = json["tags"].stringValue
        self.coverImg = json["imageUrl"].stringValue
        self.star = json["evaluateScore"].doubleValue
        
        let dis = json["relativeDistance"].doubleValue
        let time = json["deliveryMinTime"].intValue
        
        self.distance = "\(D_1_STR(dis))miles"
        self.minTime = "\(time)mins"
        
        self.storeID = json["storeId"].stringValue
                
        self.minDelivery = json["minDeliveryPrice"].doubleValue
        self.maxDelivery = json["maxDeliveryPrice"].doubleValue
        
        if minDelivery == 0 && maxDelivery == 0 {
            self.deliveryInit = "No delivery fee"
        }
        if minDelivery != 0 && maxDelivery == 0 {
            self.deliveryInit = "Delivery £\(D_2_STR(minDelivery))"
        }
        if maxDelivery != 0 {
            self.deliveryInit = "Delivery from £\(D_2_STR(minDelivery))"
        }
        
        self.minOrder = json["minOrderPrice"].doubleValue
        
        if json["minOrderPrice"].doubleValue == 0 {
            self.minCharge = "No min. order"
        } else {
            self.minCharge = "Minimum order £\(D_2_STR(minOrder))"
        }
        
        self.logoImg = json["logoUrl"].stringValue
        self.evaluateNum = json["evaluateNum"].stringValue
        self.des = json["remark"].stringValue
        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
        self.phone = json["phone"].stringValue
        self.storeAddress = json["address"].stringValue
        
        
        var tArr: [JTFeeModel] = []
        for jsonData in json["deliveryFeeList"].arrayValue {
            let model = JTFeeModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        
        self.feeList = tArr
        
        self.deStatus = json["openTypeResult"]["deliveryStatus"].stringValue
        self.coStatus = json["openTypeResult"]["collectionStatus"].stringValue
        
        var tArr2: [DaySetTimeModel] = []
        for jsondata in json["openTimeList"].arrayValue {
            let model = DaySetTimeModel()
            model.updateModel(json: jsondata)
            tArr2.append(model)
        }
        self.timeArr = tArr2
        
        
        self.coMin = json["collectionMin"].stringValue
        self.coMax = json["collectionMax"].stringValue
        self.deMin = json["deliveryMin"].stringValue
        self.deMax = json["deliveryMax"].stringValue
        self.discountMsg = json["discountMsg"].stringValue
        self.discountImgUrl = json["discountImageUrl"].stringValue
        self.isDiscount = json["discountType"].stringValue == "1" ? true : false
        self.leftImgUrl = json["leftImageUrl"].stringValue
        
        self.firstDiscountIsOpen = json["haveFirstDiscount"].stringValue == "2" ? true : false
        self.firstDiscountScale = json["firstDiscountScale"].stringValue
        self.isOpenJiFen = json["pointsStatus"].stringValue == "2" ? true : false
        
        
        
        if self.isDiscount {
            self.isHaveDiscountBar = true
        } else {
            if self.firstDiscountIsOpen {

                if self.isFirstDiscount == nil {
                    if self.isOpenJiFen {
                        self.isHaveDiscountBar = true
                    } else {
                        self.isHaveDiscountBar = false
                    }
                } else {
                    if self.isFirstDiscount! {
                        self.isHaveDiscountBar = true
                    } else {
                        if self.isOpenJiFen {
                            self.isHaveDiscountBar = true
                        } else {
                            self.isHaveDiscountBar = false
                        }
                    }
                }
            } else {
                if self.isOpenJiFen {
                    self.isHaveDiscountBar = true
                } else {
                    self.isHaveDiscountBar = false
                }
            }
        }
        
    
//        self.status = json["status"].stringValue
//        self.isDelivery = json["delivery"].boolValue
//        self.isTake = json["selfTake"].boolValue
//        self.payWay = json["paymentSupport"].stringValue

//        self.storeTags = json["tags"].stringValue
        

        
        
//        if feeList.count == 0 {
//            self.deliveryInit = "delivery fee £\(json["deliveryInit"])"
//        } else {
//            self.deliveryInit = "delivery fee £\(feeList.first!.fee)-£\(feeList.last!.fee)"
//        }
        
        

//
        
    }
    
    
    
    

}
