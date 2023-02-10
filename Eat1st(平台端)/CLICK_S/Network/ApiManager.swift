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
    
    
    ///上传语言
    case uploadLanguage
    ///登录
    case loginAction(user: String, pw: String)
    ///请求平台所有店铺的销售数据
    case getAllStoreSalesData(date: String)
    ///获取分类
    case getStoreDishesClassify(id: String)
    ///获取菜品销量
    case getStoreDishesSalesData(cId: String, sId: String, date: String, page: String)
    ///检查App版本
    case checkAppVer
    ///登出
    case logOutAction

        
}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string: BASEURL)!
    }
    
    
    var path: String {
        switch self {
        
        case .uploadLanguage:
            return "api/plat/lang/doSetUpLang"
        case .loginAction(user: _, pw: _):
            return "api/plat/login"
        case .getAllStoreSalesData(date: _):
            return "api/plat/sales/getStoreSalesForPlat"
        case .checkAppVer:
            return "api/boss/version/checkVersion"
        case .logOutAction:
            return "api/plat/logout"
        case .getStoreDishesClassify(id: _):
            return "api/plat/dishes/classify/getClassifyList"
        case .getStoreDishesSalesData(cId: _, sId: _, date: _, page: _):
            return "api/plat/sales/getDishesSalesForPlat"
            
            
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
        case .getAllStoreSalesData(let date):
            dic = ["date": date]
        case .loginAction(let user, let pw):
            dic = ["password": pw, "account": user]
        case .checkAppVer:
            dic = ["sysType": "2", "verId": UserDefaults.standard.verID!]
        case .logOutAction:
            dic = [:]
        case .getStoreDishesClassify(let id):
            dic = ["storeId": id]
        case .getStoreDishesSalesData(let cId, let sId, let date, let page):
            dic = ["classifyId": cId, "storeId": sId, "date": date, "pageIndex": page]
            
            
    
            
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

