//
//  ApiManager.swift
//  SheepStoreMer
//
//  Created by 岁变 on 10/25/19.
//  Copyright © 2019 岁变. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

enum ApiManager {
    
    //MARK: ------------------ 登录 ---------------------
    ///检查App版本
    case checkAppVer
    ///登录
    case loginAction(user: String, pw: String)
    ///登出
    case logOutAction
    ///获取首页数据 yyyy-MM-dd
    case getLiveReportingData(date: String, end: String)
    ///获取繁忙时间
    case getBusyTimeList
    ///获取配送时间
    case getTheTimeRange
    ///设置时间范围
    case setRangeTime(type: String, maxTime: String, minTime: String)
    ///设置繁忙时间
    case setBusyTime(busyID: String)
    ///获取店铺的营业状态
    case getStoreOnlineStatus
    ///上传语言
    case uploadLanguage
    ///获取菜品
    case getDishesList
    ///获取菜品的规格
    case getDishesOptionList(id: String)
    ///设置菜品规格上下架
    case setSpecOnOffStatus(id: String)
    ///设置菜品规格选项上下架
    case setOptionItemOnoffStatus(id: String)
    ///获取菜品统计
    case getDishesReportingData(type: String, day: String, endDay: String)
    ///上传推送Token
    case updateCloubMessageToken(token: String)
    ///店铺营业状态
    case getStoreOpeningHours
    ///设置营业时间
    case setStoreOpeningHours(starTime: String, endTime: String, type: String, timeID: String)
    ///设置店铺每天的营业状态
    case setStoreOpenStatusByDay(timeID: String, coStatus: String, deStatus: String)
    ///设置店铺总的营业状态
    case setStoreOpenStatus(coStatus: String, deStatus: String)
    //设置菜品上下架
    case setDishesOnOffStatus(dishes: [[String: String]])
    ///获取店铺阶梯配送费
    case getDeliveryFeeList
    ///添加店铺阶梯配送费
    case addDeliveryFeeList(list: [[String: Any]])
    ///删除配送费
    case deleteDeliveryFee(id: String)
    ///获取菜品分类列表
    case getMenuClassifyList
    ///添加菜品分类
    case addMenuClassify(name_E: String, name_C: String, name_H: String)
    ///编辑菜品分类
    case editeMenuClassify(id: String, name_E: String, name_C: String, name_H: String)
    ///删除菜品分类
    case deleteMenuClassify(id: String)
    ///获取菜品分类详情
    case getMenuClassifyDetail(id: String)
    ///获取附加分类列表
    case getAttachClassifyList
    ///添加附加分类
    case addAttachClassify(name_E: String, name_C: String, name_H: String)
    ///获取附加分类详情
    case getAttachClassifyDetail(id: String)
    ///删除附加分类
    case deleteAttachClassify(id: String)
    ///编辑附加分类
    case editeAttachClassify(id: String, name_E: String, name_C: String, name_H: String)
    
    ///获取赠品分类列表
    case getGiftClassifyList
    ///添加赠品分类
    case addGiftClassify(name_E: String, name_C: String, name_H: String)
    ///获取赠品分类详情
    case getGiftClassifyDetail(id: String)
    ///删除附加分类
    case deleteGiftClassify(id: String)
    ///编辑附加分类
    case editeGiftClassify(id: String, name_E: String, name_C: String, name_H: String)
    
    ///获取分类下的菜品列表
    case getClassifyDishesList(id: String)
    ///获取附加分类下的菜品列表
    case getClassifyAttachList(id: String)
    ///获取赠品分类下的菜品列表
    case getClassifyGiftList(id: String)
    ///获取菜品详情
    case getDishesDetail(id: String)
    ///获取菜品的标签
    case getDishTags
    ///编辑菜品
    case editeDish(model: DishDetailModel)
    ///添加菜品
    case addDish(model: DishDetailModel)
    ///删除菜品
    case deleteDish(id: String)
    ///获取菜品规格详情
    case getDishSpecDetail(id: String)
    ///编辑规格
    case editeSpec(model: DishDetailSpecModel)
    ///添加规格
    case addSpec(model: DishDetailSpecModel)
    ///删除规格
    case deleteSpec(id: String)
    ///编辑规格选项
    case editeSpecOption(model: DishDetailOptionModel)
    ///添加规格选项
    case addSpecOption(model: DishDetailOptionModel)
    ///删除规格选项
    case deleteSpecOption(id: String)
    ///获取附加菜品的详情
    case getAdditionalDetail(id: String)
    ///编辑附加菜品
    case editeAdditional(model: AdditionalDetailModel)
    ///添加附加菜品
    case addAdditional(model: AdditionalDetailModel)
    ///删除附加菜品
    case deleteAdditional(id: String)

    ///获取赠品的详情
    case getGiftDetail(id: String)
    ///编辑赠品
    case editeGift(model: GiftDetailModel)
    ///添加赠品
    case addGift(model: GiftDetailModel)
    ///删除赠品
    case deleteGift(id: String)
    ///获取店铺支付方式
    case getPaymentMethod
    ///设置店铺支付方式
    case setPaymentMethod(card: String, cash: String)
    ///设置菜品限购
    case setDishLimitBuy(dishId: String, limitType: String, limitNum: String)
    ///获取实时订单数量
    case getOrderNum
    ///菜品的周销量
    case getDishSales_Week(dishID: String, startDate: String, endDate: String, type: String)
    ///菜品的月销量
    case getDishSales_Month(dishID: String, date: String, type: String)
    ///设置菜品优惠
    case setDishedDiscount(id: String, type: String, price: String)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///获取订单列表
    case getOrderList(page: String, tag: String, type: String)
    
    ///获取订单详情
    case getOrderDetail(orderID: String)
    
    ///已出餐
    case orderChuCanAction(orderID: String)
    
    ///接单
    case orderJieDanAction(orderID: String)
    
    ///拒接
    case orderJuJieAction(orderID: String, customReason: String, reasonID: String)
    
    ///开始配送
    case orderkaiShiPeiSongAction(orderID: String)
    
    ///收货
    case orderShouHuoAction(orderID: String)
    
    
    ///获取投诉处理方式
    case getDealComplaintWay
    
    ///获取投诉内容
    case loadComplainContent(orderID: String)
    
    
    ///处理投诉
    case dealComplain(orderID: String, code: String)
    
    ///获取营业金额信息
    case getTodayAndlastWeekSales
    
    ///获取店铺支付方式
    case getStorePayWay
    
    ///更新收款方式
    case changePayWay(card: String, cash: String)
    
    
    ///上传用户位置信息
    case uploadUserLocation(lat: String, lng: String)
    
    ///获取首页Tag数据
    case getOrderStatusTag
    
    ///获取拒接原因
    case getJujieReason
    
    ///查询营业统计
    case queryStoreBussiness(type: String, date: String)
    
    ///获取骑手列表
    case getRiderList
    
    ///获取骑手派送中的订单列表
    case getRiderDeliveryOrderList(id: String)
    
    ///获取骑手历史配送订单
    case getRiderDeliveryHistoryOderList(id: String, page: String)
    
    ///获取骑手位置
    case getRiderLocal(id: String)
    

    
    
    

    
    
    
    
    

        
}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string: BASEURL)!
    }
    
    
    var path: String {
        switch self {
        
        case .checkAppVer:
            return "api/boss/version/checkVersion"
        case .loginAction(user: _, pw: _):
            return "api/boss/login"
        case .logOutAction:
            return "api/boss/logout"
        case .getLiveReportingData(date: _, end: _):
            return "api/boss/report/getHomeReport"
        case .getBusyTimeList:
            return "api/boss/store/getStoreBusyTimeList"
        case .getTheTimeRange:
            return "api/boss/store/getDeliveryTimeList"
        case .setRangeTime(type: _, maxTime: _, minTime: _):
            return "api/boss/store/doDeliveryTime"
        case .setBusyTime(busyID: _):
            return "api/boss/store/doBusyTime"
        case .getStoreOnlineStatus:
            return "api/boss/store/getStoreStatus"
        case .uploadLanguage:
            return "api/boss/lang/doSetUpLang"
        case .getDishesList:
            return "api/boss/dishes/getClassifyAndDishesList"
        case .getDishesOptionList(id: _):
            return "api/boss/dishes/spec/getSpecAndOptionList"
        case .getDishesReportingData(type: _, day: _, endDay: _):
            return "api/boss/report/getDishesSales"
        case .updateCloubMessageToken(token: _):
            return "api/boss/user/doPushToken"
        case .getStoreOpeningHours:
            return "api/boss/store/getStoreOpenTimeList"
        case .setStoreOpeningHours(starTime: _, endTime: _, type: _, timeID: _):
            return "api/boss/store/updateDayOpenTime"
        case .setStoreOpenStatusByDay(timeID: _, coStatus: _, deStatus: _):
            return "api/boss/store/updateDayOpenStatus"
        case .setStoreOpenStatus(coStatus: _, deStatus: _):
            return "api/boss/store/updateAllOpenStatus"
        case .setDishesOnOffStatus(dishes: _):
            return "api/boss/dishes/doStatus"
        case .getDeliveryFeeList:
            return "api/boss/store/getDeliveryFee"
        case .addDeliveryFeeList(list: _):
            return "api/boss/store/doSaveDeliveryFee"
        case .deleteDeliveryFee(id: _):
            return "api/boss/store/doDeleteDeliveryFee"
        case .setSpecOnOffStatus(id: _):
            return "api/boss/dishes/spec/doSpecStatus"
        case .setOptionItemOnoffStatus(id: _):
            return "api/boss/dishes/spec/option/doOptionStatus"
        case .getMenuClassifyList:
            return "api/boss/dishes/classify/getClassifyList"
        case .addMenuClassify(name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/classify/doSave"
        case .editeMenuClassify(id: _, name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/classify/doUpdate"
        case .deleteMenuClassify(id: _):
            return "api/boss/dishes/classify/doDelete"
        case .getMenuClassifyDetail(id: _):
            return "api/boss/dishes/classify/getDetail"
        case .getAttachClassifyList:
            return "api/boss/dishes/attach/classify/getClassifyList"
        case .addAttachClassify(name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/attach/classify/doSave"
        case .getAttachClassifyDetail(id: _):
            return "api/boss/dishes/attach/classify/getDetail"
        case .editeAttachClassify(id: _, name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/attach/classify/doUpdate"
        case .deleteAttachClassify(id: _):
            return "api/boss/dishes/attach/classify/doDelete"
            
        case .getGiftClassifyList:
            return "api/boss/dishes/gift/classify/getClassifyList"
        case .addGiftClassify(name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/gift/classify/doSave"
        case .getGiftClassifyDetail(id: _):
            return "api/boss/dishes/gift/classify/getDetail"
        case .editeGiftClassify(id: _, name_E: _, name_C: _, name_H: _):
            return "api/boss/dishes/gift/classify/doUpdate"
        case .deleteGiftClassify(id: _):
            return "api/boss/dishes/gift/classify/doDelete"
            
        case .getClassifyDishesList(id: _):
            return "api/boss/dishes/getDishesList"
        case .getClassifyAttachList(id: _):
            return "api/boss/dishes/attach/getAttachList"
        case .getClassifyGiftList(id: _):
            return "api/boss/dishes/gift/getGiftList"
        case .getDishesDetail(id: _):
            return "api/boss/dishes/getDetail"
        case .getDishTags:
            return "api/boss/dishes/getTagList"
        case .addDish(model: _):
            return "api/boss/dishes/doAdd"
        case .editeDish(model: _):
            return "api/boss/dishes/doUpdate"
        case .deleteDish(id: _):
            return "api/boss/dishes/doDelete"
        case .getDishSpecDetail(id: _):
            return "api/boss/dishes/spec/getDetail"
        case .editeSpec(model: _):
            return "api/boss/dishes/spec/doUpdate"
        case .addSpec(model: _):
            return "api/boss/dishes/spec/doAdd"
        case .deleteSpec(id: _):
            return "api/boss/dishes/spec/doDelete"
        case .editeSpecOption(model: _):
            return "api/boss/dishes/spec/option/doUpdate"
        case .addSpecOption(model: _):
            return "api/boss/dishes/spec/option/doAdd"
        case .deleteSpecOption(id: _):
            return "api/boss/dishes/spec/option/doDelete"
        case .getAdditionalDetail(id: _):
            return "api/boss/dishes/attach/getDetail"
        case .editeAdditional(model: _):
            return "api/boss/dishes/attach/doUpdate"
        case .addAdditional(model: _):
            return "api/boss/dishes/attach/doAdd"
        case .deleteAdditional(id: _):
            return "api/boss/dishes/attach/doDelete"
          
        case .getGiftDetail(id: _):
            return "api/boss/dishes/gift/getDetail"
        case .editeGift(model: _):
            return "api/boss/dishes/gift/doUpdate"
        case .addGift(model: _):
            return "api/boss/dishes/gift/doAdd"
        case .deleteGift(id: _):
            return "api/boss/dishes/gift/doDelete"
        case .getPaymentMethod:
            return "api/boss/store/getStorePayType"
        case .setPaymentMethod(card: _, cash: _):
            return "api/boss/store/doStorePayType"
        case .setDishLimitBuy(dishId: _, limitType: _, limitNum: _):
            return "api/boss/dishes/doLimitBuy"
        case .getOrderNum:
            return "api/boss/order/getOrderStatusNum"
        case .getDishSales_Week(dishID: _, startDate: _, endDate: _, type: _):
            return "api/boss/report/getDishesWeekSales"
        case .getDishSales_Month(dishID: _, date: _, type: _):
            return "api/boss/report/getDishesMonthSales"
        case .setDishedDiscount(id: _, type: _, price: _):
            return "api/boss/dishes/doDiscount"
          
            
            
    
            
            


            
            
            
            
            
            

            
            
            
            
            
        case .getOrderStatusTag:
            return "api/boss/order/getTabList"
            
            
        case .getOrderList(page: _, tag: _, type: _):
            return "api/boss/order/getOrderList"
        case .orderChuCanAction(orderID: _):
            return "api/business/order/cook/doCookOrder"
        case .getOrderDetail(orderID: _):
            return "api/boss/order/getOrderDetail"
            
        case .orderJieDanAction(orderID: _):
            return "api/business/order/take/doTakeOrder"
        case .orderkaiShiPeiSongAction(orderID: _):
            return "api/business/rider/doDeliveryOrder"
            
        case .orderJuJieAction(orderID: _, customReason: _, reasonID: _):
            return "api/business/order/refuse/doRefuseOrder"
        case .orderShouHuoAction(orderID: _):
            return "api/business/order/receive/doReceiveOrder"
            
        case .getDealComplaintWay:
            return "api/boss/plaint/getPlaintTypeList"
            
        case .loadComplainContent(orderID: _):
            return "api/boss/plaint/viewPlaint"
            
        case .dealComplain(orderID: _, code: _):
            return "api/boss/plaint/doPlaintOrder"
            
        case .getTodayAndlastWeekSales:
            return "api/boss/sales/getStoreCurDayAndLastWeekSales"
        case .getStorePayWay:
            return "api/boss/store/getStorePayType"
        case .changePayWay(card: _, cash: _):
            return "api/boss/store/doStorePayType"
            
            
        case .uploadUserLocation(lat: _, lng: _):
            return "api/business/rider/doRiderPosition"
            

        case .getJujieReason:
            return "api/business/order/refuse/getRefuseTypeList"
            
        case .queryStoreBussiness(type: _, date: _):
            return "api/boss/sales/getStoreOfDateSales"
        case .getRiderList:
            return "api/boss/rider/getRiderList"
        case .getRiderDeliveryOrderList(id: _):
            return "api/boss/rider/getDeliveryOrderList"
        case .getRiderDeliveryHistoryOderList(id: _, page: _):
            return "api/boss/rider/getHistoryOrderList"
        case .getRiderLocal(id: _):
            return "api/boss/rider/getRiderPosition"
            
            
            

            
            
            
        }
    }
    
    var method: Moya.Method {
        
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        
        var dic: [String: Any] = [:]
        switch self {

        case .checkAppVer:
            dic = ["sysType": "2", "verId": UserDefaults.standard.verID!]
        case .loginAction(let user, let pw):
            dic = ["password": pw, "account": user]
        case .logOutAction:
            dic = [:]
        case .getLiveReportingData(let date,  let end):
            dic = ["date": date, "end": end]
        case .getBusyTimeList:
            dic = [:]
        case .getTheTimeRange:
            dic = [:]
        case .setRangeTime(let type, let maxTime, let minTime):
            dic = ["deliveryType": type, "maxTime": maxTime, "minTime": minTime]
        case .setBusyTime(let busyID):
            dic = ["busyId": busyID]
        case .getStoreOnlineStatus:
            dic = [:]
        case .uploadLanguage:
            var style = ""
            if PJCUtil.getCurrentLanguage() == "en_GB" {
                style = "3"
            }
            if PJCUtil.getCurrentLanguage() == "zh_CN" {
                style = "1"
            }
            if PJCUtil.getCurrentLanguage() == "zh_HK" {
                style = "2"
            }
            dic = ["lang": style]
            
        case .getDishesReportingData(let type, let day, let endDay):
            dic = ["day": day, "end": endDay, "searchType": type]
        case .updateCloubMessageToken(let token):
            dic = ["token": token]
            
        case .getStoreOpeningHours:
            dic = [:]
            
        case .setStoreOpeningHours(let starTime, let endTime, let type, let timeID):
            dic = ["startTime": starTime, "endTime": endTime, "deliveryType": type, "openId": timeID]
            
        case .setStoreOpenStatusByDay(let timeID, let coStatus, let deStatus):
            dic = ["openId": timeID, "collectionStatus": coStatus, "deliveryStatus": deStatus]
            
        case .setStoreOpenStatus(let coStatus, let deStatus):
            dic = ["collectionStatus": coStatus, "deliveryStatus": deStatus]
        case .getDishesList:
            dic = [:]
        case .getDishesOptionList(let id):
            dic = ["dishesId": id]
        case .setDishesOnOffStatus(let dishes):
            dic = ["dishesList" : dishes]
        case .getDeliveryFeeList:
            dic = [:]
        case .addDeliveryFeeList(let list):
            dic = ["list": list]
        case .deleteDeliveryFee(let id):
            dic = ["feeId": id]
        case .setSpecOnOffStatus(let id):
            dic = ["specId": id]
        case .setOptionItemOnoffStatus(let id):
            dic = ["optionId": id]
        case .getMenuClassifyList:
            dic = [:]
        case .addMenuClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .editeMenuClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .deleteMenuClassify(let id):
            dic = ["classifyId": id]
        case .getMenuClassifyDetail(let id):
            dic = ["classifyId": id]
        case .getAttachClassifyList:
            dic = [:]
        case .addAttachClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .getAttachClassifyDetail(let id):
            dic = ["classifyId": id]
        case .editeAttachClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .deleteAttachClassify(let id):
            dic = ["classifyId": id]
        case .getGiftClassifyList:
            dic = [:]
        case .addGiftClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .getGiftClassifyDetail(let id):
            dic = ["classifyId": id]
        case .editeGiftClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H]
        case .deleteGiftClassify(let id):
            dic = ["classifyId": id]
            
        case .getClassifyDishesList(let id):
            dic = ["classifyId": id]
        case .getClassifyAttachList(let id):
            dic = ["classifyId": id]
        case .getClassifyGiftList(let id):
            dic = ["classifyId": id]
        case .getDishesDetail(let id):
            dic = ["dishesId": id]
        case .getDishTags:
            dic = [:]
        case .addDish(let model):
            dic = model.toJSON() ?? [:]
        case .editeDish(let model):
            dic = model.toJSON() ?? [:]
        case .deleteDish(let id):
            dic = ["dishesId": id]
        case .getDishSpecDetail(let id):
            dic = ["specId": id]
        case .editeSpec(let model):
            dic = model.toJSON() ?? [:]
        case .addSpec(let model):
            dic = model.toJSON() ?? [:]
        case .deleteSpec(let id):
            dic = ["specId": id]
        case .editeSpecOption(let model):
            dic = model.toJSON() ?? [:]
        case .addSpecOption(let model):
            dic = model.toJSON() ?? [:]
        case .deleteSpecOption(let id):
            dic = ["optionId": id]
        case .getAdditionalDetail(let id):
            dic = ["attachId": id]
        case .editeAdditional(let model):
            dic = model.toJSON() ?? [:]
        case .addAdditional(let model):
            dic = model.toJSON() ?? [:]
        case .deleteAdditional(let id):
            dic = ["attachId": id]
        case .getGiftDetail(let id):
            dic = ["giftId": id]
        case .editeGift(let model):
            dic = model.toJSON() ?? [:]
        case .addGift(let model):
            dic = model.toJSON() ?? [:]
        case .deleteGift(let id):
            dic = ["giftId": id]
        case .getPaymentMethod:
            dic = [:]
        case .setPaymentMethod(let card, let cash):
            dic = ["card": card, "cash": cash]
        case .setDishLimitBuy(let dishId, let limitType, let limitNum):
            dic = ["dishesId": dishId, "limitBuy": limitType, "limitNum": limitNum]
        case .getOrderNum:
            dic = [:]
        case .getDishSales_Week(let dishID, let startDate, let endDate, let type):
            dic = ["dishesId": dishID, "start": startDate, "end": endDate, "type": type]
        case .getDishSales_Month(let dishID, let date, let type):
            dic = ["dishesId": dishID, "date": date, "type": type]
        case .setDishedDiscount(let id, let type, let price):
            dic = ["dishesId": id, "discountType": type, "discountPrice": price]
            
            

            
            
            
            
            
            
            
        
            
            
            
            
            
            
        case .getOrderList(let page, let tag, let type):
            dic = ["pageIndex": page, "deliveryType": type, "tagId": tag]
            
        case .getOrderDetail(let orderID):
            dic = ["orderId": orderID]
            
            
        case .orderChuCanAction(let orderID):
            dic = ["orderId": orderID]
            
        case .orderJieDanAction(let orderID):
            dic = ["orderId": orderID]
            
        case .orderkaiShiPeiSongAction(let orderID):
            dic = ["orderId": orderID]
            
            
        case .orderJuJieAction(let orderID, let customReason, let id):
            dic = ["orderId": orderID, "reason": customReason, "refuseTypeId": id]
            
        case .orderShouHuoAction(let orderID):
            dic = ["orderId": orderID]
            
 
            
        case .getDealComplaintWay:
            dic = [:]
            
        case .loadComplainContent(let orderID):
            dic = ["orderId": orderID]
            
        case .dealComplain(let orderID, let code):
            dic = ["orderId": orderID, "plaintId": code]
            
        case .getTodayAndlastWeekSales:
            dic = [:]
            
        case .getStorePayWay:
            dic = [:]
            
        case .changePayWay(let card, let cash):
            dic = ["card": card, "cash": cash]
            
            
        case .uploadUserLocation(let lat, let lng):
            dic = ["lat": lat, "lng": lng]
            
        case .getOrderStatusTag:
            dic = [:]
            
        case .getJujieReason:
            dic = [:]
            
        case .queryStoreBussiness(let type, let date):
            dic = ["dateType": type, "date": date]
            
        case .getRiderList:
            dic = [:]
            
        case .getRiderDeliveryOrderList(let id):
            dic = ["id": id]
            
        case .getRiderDeliveryHistoryOderList(let id, let page):
            dic  = ["id": id, "pageIndex": page]
            
        case .getRiderLocal(let id):
            dic = ["id": id]
            
        }
        print("参数：\(dic)")
        return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        
    }

    
    //请求参数类型
    var parameterEncoding: ParameterEncoding {
        return  JSONEncoding.default
    }

    var headers: [String : String]? {
        
        let token = UserDefaults.standard.token ?? ""
        print("token: +++++++++++++" + token)
        
        //系统类型
        let systemtype = UIDevice.current.modelName
        
        //系统版本
        let systemVer = UIDevice.current.systemVersion
        print(systemVer)
        
        //当前语言
        let curLanguage = PJCUtil.getCurrentLanguage()
        print(curLanguage)
        
        //当前App版本
        let curAppVer = PJCUtil.getCurentVersion()
        print(curAppVer)
        
        //设备ID
        let deviceID = MYVendorToll.getIDFV() ?? ""
        print(deviceID)
        
        let baseDic = ["Accept": "application/json",
                       "token": token,
                       "verId": UserDefaults.standard.verID ?? "0",
                       "verCode": "v\(curAppVer)",
                       "sysType": systemtype,
                       "sysVer": systemVer,
                       "lang": curLanguage,
                       "deviceId": deviceID
                        ]
        
        return baseDic
    }
    
}

final class NetWorkPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        let req = request.request?.description ?? "无效的请求连接"
        print("+++++++++++++++++++++++\n\(req)\n++++++++++++++++++++++++")
    }
}


var ERROR_Message = ""

enum NetworkError: Error {
    case unkonw
    case serverError
    case netError
    case dataError
    
    case voiceError
    case videoError
    case imageError
    case medicalError
} 

class ErrorTool {
    
    static func errorMessage(_ m_error: Error) -> String {
        switch m_error as! NetworkError {
        case .unkonw:
            return ERROR_Message
        case .serverError:
            return "Server connection error"
        case .netError:
            return "The network connection failed"
        case .dataError:
            return "Data format error"
        default:
            return ""
        }
    }
}

