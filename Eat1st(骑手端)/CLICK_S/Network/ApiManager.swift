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
    
    ///登录
    case loginAction(user: String, pw: String)
    ///获取首页Tag数据
    case getOrderStatusTag
    ///获取订单列表
    case getOrderList(page: String, tag: String)
    ///获取工作状态
    case getRiderWorkStatus
    ///设置工作状态
    case setRiderWorkStatus
    ///骑手接单
    case riderJieDan
    ///开始订单
    case orderStart(orderID: String)
    ///订单退回
    case orderBack(orderID: String, reasonID: String, otherReason: String, imageList: [[String: String]])
    ///骑手确认收货
    case riderDoReceive(orderID: String)
    
    ///上传语言
    case uploadLanguage
    ///获取退回原因
    case getUnSuccessfulReason
    
    ///批量取消
    case riderCancelOrder
    ///获取当天现金及配送费总金额
    case getCurDayCashAndDeFee
    ///登出
    case logOut
    ///检查App版本
    case CheckAppVer
    ///获取外部订单列表  1全部，2未派送和派送中，3已完成）
    case getOtherPTOrders(status: String)
    ///外部订单开始派送
    case otherPTOdersStart(orderID: String)
    ///外部订单派送完成
    case otherPTOrderComplete(orderID: String)
    
    

    
    
    
    
    

    
    
    
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
    
    ///店铺营业状态
    case getStoreOpeningHours
    
    ///设置营业时间
    case setStoreOpeningHours(starTime: String, endTime: String, type: String, timeID: String)
    
    ///设置店铺每天的营业状态
    case setStoreOpenStatusByDay(timeID: String, coStatus: String, deStatus: String)
    
    ///设置店铺总的营业状态
    case setStoreOpenStatus(coStatus: String, deStatus: String)
    
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
    
    ///上传推送Token
    case updateCloubMessageToken(token: String)
    
    ///上传用户位置信息
    case uploadUserLocation(lat: String, lng: String)
    

    
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
    
    ///获取繁忙时间
    case getBusyTimeList

    ///获取配送时间
    case getTheTimeRange
    
    ///设置繁忙时间
    case setBusyTime(busyID: String)
    
    ///设置时间范围
    case setRangeTime(type: String, maxTime: String, minTime: String)
        
}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string: BASEURL)!
    }
    
    
    var path: String {
        switch self {
        
        case .loginAction(user: _, pw: _):
            return "api/rider/login"
        case .getOrderStatusTag:
            return "api/rider/order/getTabList"
        case .getOrderList(page: _, tag: _):
            return "api/rider/order/getOrderList"
        case .getRiderWorkStatus:
            return "api/rider/user/getWorkStatus"
        case .setRiderWorkStatus:
            return "api/rider/user/doWorkStatus"
        case .riderJieDan:
            return "api/rider/take/doTakeOrder"
        case .orderStart(orderID: _):
            return "api/rider/start/doStartOrder"
        case .orderBack(orderID: _, reasonID: _, otherReason: _, imageList: _):
            return "api/rider/back/doBackOrder"
        case .riderDoReceive(orderID: _):
            return "api/rider/receive/doReceiveOrder"
        case .getOrderDetail(orderID: _):
            return "api/rider/order/getOrderDetail"
        case .uploadLanguage:
            return "api/rider/lang/doSetUpLang"
        case .getUnSuccessfulReason:
            return "api/rider/back/getBackReasonList"
        case .riderCancelOrder:
            return "api/rider/back/doBatchBackOrder"
        case .getCurDayCashAndDeFee:
            return "api/rider/order/getCashAndDeliveryAmount"
        case .logOut:
            return "api/rider/logout"
        case .CheckAppVer:
            return "api/rider/version/checkVersion"
        case .getOtherPTOrders(status: _):
            return "api/rider/outer/order/getOrderList"
        case .otherPTOdersStart(orderID: _):
            return "api/rider/outer/order/doStart"
        case .otherPTOrderComplete(orderID: _):
            return "api/rider/outer/order/doComplete"
                        
            
         

            
            
            
    
            
            
        case .orderChuCanAction(orderID: _):
            return "api/business/order/cook/doCookOrder"

            
        case .orderJieDanAction(orderID: _):
            return "api/business/order/take/doTakeOrder"
        case .orderkaiShiPeiSongAction(orderID: _):
            return "api/business/rider/doDeliveryOrder"
            
        case .orderJuJieAction(orderID: _, customReason: _, reasonID: _):
            return "api/business/order/refuse/doRefuseOrder"
        case .orderShouHuoAction(orderID: _):
            return "api/business/order/receive/doReceiveOrder"
        case .getStoreOpeningHours:
            return "api/business/store/getStoreOpenTimeList"
        case .setStoreOpeningHours(starTime: _, endTime: _, type: _, timeID: _):
            return "api/business/store/updateDayOpenTime"
        case .setStoreOpenStatusByDay(timeID: _, coStatus: _, deStatus: _):
            return "api/business/store/updateDayOpenStatus"
        case .setStoreOpenStatus(coStatus: _, deStatus: _):
            return "api/business/store/updateAllOpenStatus"
            
        case .getDealComplaintWay:
            return "api/business/order/plaint/getPlaintTypeList"
            
        case .loadComplainContent(orderID: _):
            return "api/business/order/plaint/viewPlaint"
            
        case .dealComplain(orderID: _, code: _):
            return "api/business/order/plaint/doPlaintOrder"
            
        case .getTodayAndlastWeekSales:
            return "api/business/sales/getStoreCurDayAndLastWeekSales"
        case .getStorePayWay:
            return "api/business/store/getStorePayType"
        case .changePayWay(card: _, cash: _):
            return "api/business/store/doStorePayType"
            
        case .updateCloubMessageToken(token: _):
            return "api/rider/user/doPushToken"
            
        case .uploadUserLocation(lat: _, lng: _):
            return "api/rider/user/doRiderPosition"
            
        case .getJujieReason:
            return "api/business/order/refuse/getRefuseTypeList"
            
        case .queryStoreBussiness(type: _, date: _):
            return "api/business/sales/getStoreOfDateSales"
        case .getRiderList:
            return "api/business/rider/getRiderList"
        case .getRiderDeliveryOrderList(id: _):
            return "api/business/rider/getDeliveryOrderList"
        case .getRiderDeliveryHistoryOderList(id: _, page: _):
            return "api/business/rider/getHistoryOrderList"
        case .getRiderLocal(id: _):
            return "api/business/rider/getRiderPosition"
            
        case .getBusyTimeList:
            return "api/business/store/getBusyTimeList"
        case .getTheTimeRange:
            return "api/business/store/getDeliveryTimeList"
        case .setBusyTime(busyID: _):
            return "api/business/store/doBusyTime"
        case .setRangeTime(type: _, maxTime: _, minTime: _):
            return "api/business/store/doDeliveryTime"
            
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

        case .loginAction(let user, let pw):
            dic = ["password": pw, "account": user]
            
        case .getOrderStatusTag:
            dic = [:]
            
        case .getOrderList(let page, let tag):
            dic = ["pageIndex": page, "tagId": tag]
            
        case .getRiderWorkStatus:
            dic = [:]
            
        case .setRiderWorkStatus:
            dic = [:]
            
        case .riderJieDan:
            dic = [:]
            
        case .orderStart(let orderID):
            dic = ["orderId": orderID]
            
        case .orderBack(let orderID, let reasonID, let otherReason, let imageList):
            dic = ["orderId": orderID, "reasonId": reasonID, "reasonOther": otherReason, "imageList": imageList]
            
        case .riderDoReceive(let orderID):
            dic = ["orderId": orderID]
            
            
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
            
        case .getStoreOpeningHours:
            dic = [:]
            
        case .setStoreOpeningHours(let starTime, let endTime, let type, let timeID):
            dic = ["startTime": starTime, "endTime": endTime, "deliveryType": type, "openId": timeID]
            
        case .setStoreOpenStatusByDay(let timeID, let coStatus, let deStatus):
            dic = ["openId": timeID, "collectionStatus": coStatus, "deliveryStatus": deStatus]
            
        case .setStoreOpenStatus(let coStatus, let deStatus):
            dic = ["collectionStatus": coStatus, "deliveryStatus": deStatus]
            
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
            
        case .updateCloubMessageToken(let token):
            dic = ["token": token]
            
        case .uploadUserLocation(let lat, let lng):
            dic = ["lat": lat, "lng": lng]
            
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

            
        case .getUnSuccessfulReason:
            dic = [:]
            
        case .riderCancelOrder:
            dic = [:]
        case .getCurDayCashAndDeFee:
            dic = [:]
            
        case .logOut:
            dic = [:]
        case .CheckAppVer:
            dic = ["sysType": "2", "verId": UserDefaults.standard.verID!]
        case .getOtherPTOrders(let status):
            dic = ["orderStatus": status]
        case .otherPTOdersStart(let orderID):
            dic = ["orderId": orderID]
        case .otherPTOrderComplete(let orderID):
            dic = ["orderId": orderID]
            
            
            
            
            
            
            
            
            
            
            

        
            
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
            
        case .getBusyTimeList:
            dic = [:]
            
        case .getTheTimeRange:
            dic = [:]
            
        case .setBusyTime(let busyID):
            dic = ["busyId": busyID]
        case .setRangeTime(let type, let maxTime, let minTime):
            dic = ["deliveryType": type, "maxTime": maxTime, "minTime": minTime]
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
        
        
        ///sysType：系统类型（01用户安卓，02用户苹果，03骑手安卓，04骑手苹果，05老板安卓，06老板苹果，07店家安卓）
        let baseDic = ["Accept": "application/json",
                       "token-rider": token,
                       "token": token,
                       "verId": UserDefaults.standard.verID ?? "0",
                       "verCode": "v\(curAppVer)",
                       "sysType": "04",
                       "sysModel": systemtype,
                       "sysVer": systemVer,
                       "lang": curLanguage,
                       "deviceId": deviceID,
                       "deviceType": "apple",
                       "sysLang": Locale.preferredLanguages.first ?? ""
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

