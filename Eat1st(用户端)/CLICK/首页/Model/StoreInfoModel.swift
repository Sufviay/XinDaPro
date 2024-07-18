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



class WeekOpenTimeModel {
    
    var weekName: String = ""
    var weekID: String = ""
    var timeArr: [DayTimeModel] = []
    
}




class DayTimeModel: NSObject {
    
    //1开启，2关闭
    var deStatus: String = ""
    var coStatus: String = ""
    
    var timeId: String = ""
    var timeName: String = ""
    
    var startTime: String = ""
    var endTime: String = ""
    
    func updateModel(json: JSON) {
        //self.id = json["id"].stringValue
        self.timeId = json["storeTimeId"].stringValue
        self.timeName = json["timeName"].stringValue
        self.startTime = json["startTime"].stringValue
        self.endTime = json["endTime"].stringValue
        self.deStatus = json["deliverStatus"].stringValue
        self.coStatus = json["collectStatus"].stringValue
        
    }

}


class StoreInfoModel: NSObject {
    
    
    ///名字
    var name: String = ""
    ///封面图片
    var coverImg: String = ""
    ///评分
    var star: Double = 0
    ///最高配送费
    var maxDelivery: Double = 0
    ///最低配送费
    var minDelivery: Double = 0
    ///最少配送时间
    var minTime: String = ""
    
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
//    ///阶梯配送费列表
//    var feeList: [JTFeeModel] = []
//    ///配送状态 1开启 2关闭
//    var deStatus: String = ""
//    ///自取状态 1开启 2关闭
//    var coStatus: String = ""
    ///营业时间
    //var timeArr: [DaySetTimeModel] = []
    var storeOpenTime: [WeekOpenTimeModel] = []
    
//    ///自取时间
//    var coMin: String = ""
//    var coMax: String = ""
//    ///配送时间
//    var deMin: String = ""
//    var deMax: String = ""
    

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
    var isHaveDiscountBar: Bool = true
    
    ///店铺基本信息栏的高度(包括店铺名称，店铺描述，店铺评分，评价，起送费，配送费)
    var storeInfo_H: CGFloat = 0
    ///店铺所有内容的高度
    var storeContent_H: CGFloat = 100
    
    ///扫码点餐页面店铺信息高度
    var scanStoreInfo_H: CGFloat = 0
    ///扫码点餐页面的店铺内容高度
    var scanContent_H: CGFloat = 100
    
    
    ///外卖的起送金额字符串，用于显示
    var minOrderStr: String = ""

    ///外卖配送费字符串 用户显示
    var deliveryFeeStr: String = ""
    
    ///当前店铺是卖午餐 还是晚餐 （2午餐 3晚餐）
    var storeSellLunchOrDinner: String = ""
    
    
    ///是否是会员用户（1否， 2是）
    var isVip: Bool = false
    
    var vipAmount: String = "0"

    
    

    func updateModel(json: JSON) {
        self.name = json["storeName"].stringValue
        self.tags = json["tags"].stringValue
        self.coverImg = json["imageUrl"].stringValue
        self.star = json["evaluateScore"].doubleValue
        
        let dis = json["relativeDistance"].doubleValue
        let time = json["deliveryMinTime"].intValue
        
        self.distance = "\(D_2_STR(dis))miles"
        self.minTime = "\(time)mins"
        
        self.storeID = json["storeId"].stringValue
                
        self.minDelivery = json["minDeliveryPrice"].doubleValue
        self.maxDelivery = json["maxDeliveryPrice"].doubleValue
        

        self.minOrder = json["minOrderPrice"].doubleValue
        
        
        self.logoImg = json["logoUrl"].stringValue
        self.evaluateNum = json["evaluateNum"].stringValue
        self.des = json["remark"].stringValue
        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
        self.phone = json["phone"].stringValue
        self.storeAddress = json["address"].stringValue
        
        
        
        self.discountMsg = json["discountMsg"].stringValue
        self.discountImgUrl = json["discountImageUrl"].stringValue
        self.isDiscount = json["discountType"].stringValue == "1" ? true : false
        self.leftImgUrl = json["leftImageUrl"].stringValue
        
        self.firstDiscountIsOpen = json["haveFirstDiscount"].stringValue == "2" ? true : false
        self.firstDiscountScale = json["firstDiscountScale"].stringValue
        self.isOpenJiFen = json["pointsStatus"].stringValue == "2" ? true : false
        
        
        if minOrder == 0 {
            self.minOrderStr = "No min. order"
        } else {
            self.minOrderStr = "Minimum order £\(D_2_STR(minOrder)) for delivery"
        }

        
        if minDelivery == 0 && maxDelivery == 0 {
            self.deliveryFeeStr = "No delivery fee"
        }
        if minDelivery != 0 && maxDelivery == 0 {
            self.deliveryFeeStr = "Delivery £\(D_2_STR(minDelivery))"
        }
        if maxDelivery != 0 {
            self.deliveryFeeStr = "Delivery from £\(D_2_STR(minDelivery))"
        }
        
                

        
        
        ///计算基信息栏的高度
        let name_h = name.getTextHeigh(BFONT(18), MENU_STORE_NAME_W)
        let tag_h = tags.getTextHeigh(SFONT(13), MENU_STORE_TAGS_W)
        self.storeInfo_H = name_h + tag_h + 20 + 75
        self.scanStoreInfo_H = (name_h + tag_h + 50) > 80 ? (name_h + tag_h + 50) : 80
        
                    
        ///优惠栏固定显示
        self.storeContent_H = storeInfo_H + 15 + 30 + 50  //95
        //self.scanContent_H = scanStoreInfo_H + 15 + 40   //55
    //
    //        self.storeContent_H = storeInfo_H + 15 + 50  //65
        self.scanContent_H = scanStoreInfo_H + 25  //25
        
        
        
        ///处理营业时间
        
        for idx in 1...7 {
            let model = WeekOpenTimeModel()
            model.weekID = String(idx)
            if idx == 1 {
                model.weekName = "Monday"
            }
            if idx == 2 {
                model.weekName = "Tuesday"
            }
            if idx == 3 {
                model.weekName = "Wednesday"
            }
            if idx == 4 {
                model.weekName = "Thursday"
            }
            if idx == 5 {
                model.weekName = "Friday"
            }
            if idx == 6 {
                model.weekName = "Saturday"
            }
            if idx == 7 {
                model.weekName = "Sunday"
            }
            
            storeOpenTime.append(model)
        }
        
        //获取所有时间段
        var allTime: [DayTimeModel] = []
        for jsonData in json["timeList"].arrayValue {
            let model = DayTimeModel()
            model.updateModel(json: jsonData)
            allTime.append(model)
        }

        //循环星期列表
        for jsonData in json["weekList"].arrayValue {
            //获取timeID
            let timeID = jsonData["storeTimeId"].stringValue
            //找到相对应的TimeModel
            if (allTime.filter { $0.timeId == timeID }).count != 0 {
                let model = allTime.filter { $0.timeId == timeID }[0]
                
                ///获取weekID
                let weekId = jsonData["weekId"].stringValue
                ///根据weekID将timeModel插入指定位置
                storeOpenTime[(Int(weekId) ?? 0) - 1].timeArr.append(model)
            }
        }
    }
    
    
    func updateStoreInfo_H() {
        
        
//        if self.isDiscount {
//            self.isHaveDiscountBar = true
//        } else {
//            if self.firstDiscountIsOpen {
//
//                if self.isFirstDiscount == nil {
//                    if self.isOpenJiFen {
//                        self.isHaveDiscountBar = true
//                    } else {
//                        self.isHaveDiscountBar = false
//                    }
//                } else {
//                    if self.isFirstDiscount! {
//                        self.isHaveDiscountBar = true
//                    } else {
//                        if self.isOpenJiFen {
//                            self.isHaveDiscountBar = true
//                        } else {
//                            self.isHaveDiscountBar = false
//                        }
//                    }
//                }
//            } else {
//                if self.isOpenJiFen {
//                    self.isHaveDiscountBar = true
//                } else {
//                    self.isHaveDiscountBar = false
//                }
//            }
//        }
        
//        
//        if isHaveDiscountBar {
//            self.storeContent_H = storeInfo_H + 15 + 30 + 50  //95
//            //self.scanContent_H = scanStoreInfo_H + 15 + 40   //55
//        } else {
//            self.storeContent_H = storeInfo_H + 15 + 50  //65
//            //self.scanContent_H = scanStoreInfo_H + 25  //25
//        }
        
        if isVip {
            self.storeContent_H = storeInfo_H + 15 + 30 + 50 + SET_H(50, 345) + 10  //95
            self.scanContent_H = scanStoreInfo_H + 25 + SET_H(50, 345) + 10
            //self.scanContent_H = scanStoreInfo_H + 15 + 40   //55
        } else {
            self.storeContent_H = storeInfo_H + 15 + 30 + 50   //95
            self.scanContent_H = scanStoreInfo_H + 25
        }
        
    }
    
}
