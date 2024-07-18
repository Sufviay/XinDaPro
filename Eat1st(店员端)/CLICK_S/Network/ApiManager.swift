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
    
    ///登录
    case loginAction(user: String, pw: String)
    ///登出
    case logOutAction
    ///检查App版本
    case checkAppVer
    ///获取餐桌列表
    case getDeskList
    ///获取菜品列表
    case getDishesList(deskID: String)
    ///获取菜品的分类
    case getDishesClassifyList
    ///获取菜品分组列表
    case getDishesGroupList
    ///菜品详情
    case getDishesDetail(dishID: String, deskID: String)
    ///获取附加分类
    case getAttachClassifyList
    ///获取附加列表
    case getAttachList
    
    ///获取附加菜品和附加分类
    case getAttachAndAttachClassify
    
    ///店员下单计算
    case doCalOrder(deskID: String, dishesArr: [CartDishModel])
    ///创建订单
    case doCreateOrder(deskID: String, dishesArr: [CartDishModel], adultNum: Int, childNum: Int)
    ///获取餐桌的订单列表
    case getDeskOrderList(deskID: String)
    ///获取餐桌订单的菜品列表
    case getDeskOrderDishesList(orderID: String)
    
    ///获取店铺列表
    case getStoreList
    ///获取店铺的店员
    case getWaiterList(id: String)
    
    ///获取订单详情
    case getOrderDetail(orderID: String)
    ///删除订单菜品
    case deleteOrderDishes(orderDishesID: String, pwd: String)
    ///获取用户信息及会员信息
    case getUserByToken(token: String)
    
    
    
        
}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string: BASEURL)!
    }
    
    
    var path: String {
        switch self {
            
            
        case .loginAction(user: _, pw: _):
            return "api/waiter/login"
        case .logOutAction:
            return "api/waiter/logout"
        case .checkAppVer:
            return "api/waiter/version/checkVersion"
        case .getDeskList:
            return "api/waiter/desk/getDeskList"
        case .getDishesList(deskID: _):
            return "api/waiter/dishes/getDishesList"
        case .getDishesClassifyList:
            return "api/waiter/dishes/getClassifyList"
        case .getDishesGroupList:
            return "api/waiter/dishes/group/getGroupAndClassifyList"
        case .getDishesDetail(dishID: _, deskID: _):
            return "api/waiter/dishes/getDishesDetail"
        case .getAttachList:
            return "api/waiter/dishes/attach/getAttachList"
        case .getAttachClassifyList:
            return "api/waiter/dishes/attach/getAttachClassifyList"
        case .getAttachAndAttachClassify:
            return "api/waiter/dishes/attach/getAttachAndClassifyList"
        case .doCalOrder(deskID: _, dishesArr: _):
            return "api/waiter/order/calOrder"
        case .doCreateOrder(deskID: _, dishesArr: _, adultNum: _, childNum: _):
            return "api/waiter/order/createOrder"
        case .getDeskOrderList(deskID: _):
            return "api/waiter/desk/getDeskOrderList"
        case .getDeskOrderDishesList(orderID: _):
            return "api/waiter/desk/getDeskOrderDishesList"
        case .getStoreList:
            return "api/waiter/store/getStoreList"
        case .getWaiterList(id: _):
            return "api/waiter/user/getWaiterList"
        case .getOrderDetail(orderID: _):
            return "api/waiter/order/getOrderDetail"
        case .deleteOrderDishes(orderDishesID: _, pwd: _):
            return "api/waiter/order/doDelOrderDishes"
        case .getUserByToken(token: _):
            return "api/waiter/user/getUserByToken"
            

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
        case .getDeskList:
            dic = [:]
        case .getDishesList(let deskID):
            dic = ["deskId": deskID]
        case .getDishesClassifyList:
            dic = [:]
        case .getDishesGroupList:
            dic = [:]
        case .getDishesDetail(let dishID, let deskID):
            dic = ["deskId": deskID, "dishesId": dishID]
        case .getAttachList:
            dic = [:]
        case .getAttachClassifyList:
            dic = [:]
        case .getAttachAndAttachClassify:
            dic = [:]
        case .doCreateOrder(let deskID, let dishesArr, let adultNum, let childNum):
            
            var dicArr: [[String: Any]] = []
            
            for model in dishesArr {
                var itemArr: [[String: Any]] = []
                for item in model.itemList {
                    let dic = ["itemId": item.itemID]
                    itemArr.append(dic)
                }
            
                var attachArr: [[String: Any]] = []
                for attach in model.attachList {
                    let dic: [String: Any] = ["attachId": attach.itemID, "buyNum": 1]
                    attachArr.append(dic)
                }
                
                /**
                 * 根据分隔线情况，给菜品设置分组参数
                 * 如果“叫起”为开始，那么printSort从1（可能是100）开始计数，否则从2（可能是99）开始
                 * 如果“叫起”为结束，那么printSort从99结束，否则正常计数结束
                 * 如果只有一组printSort，开始时有“叫起”，结束时有“叫起”时：printSort = 100
                 * 如果只有一组printSort，开始时没有“叫起”，结束时有“叫起”时 printSort = 99
                 */
                
                var printSort = model.printSort
                
                if dishesArr.first!.printSort == 1 && dishesArr.last!.printSort == 1 && dishesArr.last!.showJiaoqi {
                    printSort = 100
                } else if dishesArr.last!.showJiaoqi {
                    //获取最后一个的 printSort
                    let lastP = dishesArr.last!.printSort
                    
                    //等于最后的那个printSort的都变为99
                    if model.printSort == lastP {
                        printSort = 99
                    }
                }
                
                
                let dishDic: [String: Any] = ["dishesId": model.dishesId, "buyNum": model.buyNum, "printSort": "\(printSort)", "itemList": itemArr, "attachList": attachArr, "dishesPrice": D_2_STR(model.price)]
                dicArr.append(dishDic)
            }
            
            dic = ["deskId": deskID, "dishesList": dicArr, "childNum": childNum, "adultNum": adultNum]
            
        case .doCalOrder(let deskID, let dishesArr):
            
            var dicArr: [[String: Any]] = []
            for model in dishesArr {
                var itemArr: [[String: Any]] = []
                for item in model.itemList {
                    let dic = ["itemId": item.itemID]
                    itemArr.append(dic)
                }
            
                var attachArr: [[String: Any]] = []
                for attach in model.attachList {
                    let dic: [String: Any] = ["attachId": attach.itemID, "buyNum": 1]
                    attachArr.append(dic)
                }
                
                var printSort = model.printSort
                
                if dishesArr.first!.printSort == 1 && dishesArr.last!.printSort == 1 && dishesArr.last!.showJiaoqi {
                    printSort = 100
                } else if dishesArr.last!.showJiaoqi {
                    //获取最后一个的 printSort
                    let lastP = dishesArr.last!.printSort
                    
                    //等于最后的那个printSort的都变为99
                    if model.printSort == lastP {
                        printSort = 99
                    }
                }
                
                let dishDic: [String: Any] = ["dishesId": model.dishesId, "buyNum": model.buyNum, "printSort": "\(printSort)", "itemList": itemArr, "attachList": attachArr, "dishesPrice": D_2_STR(model.price)]
                dicArr.append(dishDic)
            }
            
            dic = ["deskId": deskID, "dishesList": dicArr]

        case .getDeskOrderList(let deskID):
            dic = ["deskId": deskID]
        case .getDeskOrderDishesList(let orderID):
            dic = ["orderId": orderID]
        case .getStoreList:
            dic = [:]
        case .getWaiterList(let id):
            dic = ["storeId": id]
        case .getOrderDetail(let orderID):
            dic = ["orderId": orderID]
        case .deleteOrderDishes(let orderDishesID, let pwd):
            dic = ["orderDishesId": orderDishesID, "pwd": pwd]
        case .getUserByToken(let token):
            dic = ["token": token]
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
                       "token-waiter": token,
                       "verId": UserDefaults.standard.verID ?? "0",
                       "verCode": "v\(curAppVer)",
                       "sysType": "09",
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

