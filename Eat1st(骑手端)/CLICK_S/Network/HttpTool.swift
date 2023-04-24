//
//  HttpTool.swift
//  SheepStoreMer
//
//  Created by 岁变 on 10/25/19.
//  Copyright © 2019 岁变. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Alamofire
import MBProgressHUD
import Moya


let requestTimeOut = { (endpoint: Endpoint, done: @escaping MoyaProvider<ApiManager>.RequestResultClosure) in
    
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 15
        done(.success(request))
    } catch {
        print("超时了")
    }
    
}

class HttpTool {
    
    static let shared = HttpTool()
    private init() {}
    
    private let bag = DisposeBag()
    
    
    private let provider = MoyaProvider<ApiManager>(requestClosure: requestTimeOut, plugins: [NetWorkPlugin()])
    
    typealias apiToObserver = (AnyObserver<JSON>) -> Disposable
    
    func rxApiManager(api: ApiManager) -> apiToObserver {
        return { (observer: AnyObserver<JSON>) -> Disposable in
            return self.provider.rx.request(api).subscribe { event in
                switch event {
                case .success(let response):
                    if response.statusCode == 200 {
                        let json = JSON(response.data)
                        print(json)
                        if json["code"].stringValue == "1" {
                            observer.onNext(json)
                            observer.onCompleted()
                        } else if (json["code"].stringValue == "-1" || json["code"].stringValue == "-3" || json["code"].stringValue == "-4" || json["code"].stringValue == "-5" || json["code"].stringValue == "-6") || json["code"].stringValue == "-2" {
                            observer.onNext(json)
                            observer.onCompleted()
                            HUD_MB.showWarnig("Login is invalid. Please log in again!", onView: PJCUtil.getWindowView())
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                PJCUtil.logOut()
                            }
                        } else {
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.unkonw)
                        }
                    } else {
                        observer.onError(NetworkError.serverError)
                    }
                case .error(let error):
                    print(error.localizedDescription)
                    observer.onError(NetworkError.netError)
                }
            }
        }
    }
    
    
    
    //MARK: - 登录
    func userLogIn(user: String, pw: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginAction(user: user, pw: pw))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 订单列表
    func getOrderList(page: Int, tag: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderList(page: String(page), tag: tag))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取骑手的工作状态
    func getRiderWorkStatus() -> Observable<JSON> {
        let response = rxApiManager(api: .getRiderWorkStatus)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置骑手工作状态
    func setRiderWorkStatus() -> Observable<JSON> {
        let response = rxApiManager(api: .setRiderWorkStatus)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 骑手接单
    func riderJieDan() -> Observable<JSON> {
        let response = rxApiManager(api: .riderJieDan)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单开始
    func orderStart(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderStart(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单退回
    func orderBack(orderID: String, reasonID: String, otherReason: String, imageList: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .orderBack(orderID: orderID, reasonID: reasonID, otherReason: otherReason, imageList: imageList))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单完成
    func riderDoReceiveOrder(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .riderDoReceive(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 订单详情
    func getOrderDetail(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderDetail(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    
    
    
    //MARK: 出餐
    func chuCanAciton(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderChuCanAction(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 接单
    func jiedanAction(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderJieDanAction(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 拒接
    func jujieAciton(orderID: String, customReason: String, reasonID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderJuJieAction(orderID: orderID, customReason: customReason, reasonID: reasonID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 开始配送
    func kaiShiPeiSongAction(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderkaiShiPeiSongAction(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 确认收货
    func shouHuoAction(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderShouHuoAction(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 营业信息
    func getStoreOpeningHours() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreOpeningHours)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置营业时间
    func setOpeningHours(starTime: String, endTime: String, timeID: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setStoreOpeningHours(starTime: starTime, endTime: endTime, type: type, timeID: timeID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置店铺每天的营业状态
    func setStoreOpenStatusByDay(timeID: String, coStatus: String, deStatus: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setStoreOpenStatusByDay(timeID: timeID, coStatus: coStatus, deStatus: deStatus))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置店铺总的营业状态
    func setStoreOpenStatus(coStatuts: String, deStatus: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setStoreOpenStatus(coStatus: coStatuts, deStatus: deStatus))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取投诉处理内容
    func getComplaintDealContent() -> Observable<JSON> {
        let response = rxApiManager(api: .getDealComplaintWay)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取投诉内容
    func loadComplainContent(orderId: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loadComplainContent(orderID: orderId))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 处理投诉
    func dealComplaintAction(orderID: String, code: String) -> Observable<JSON> {
        let response = rxApiManager(api: .dealComplain(orderID: orderID, code: code))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取营业金额
    func getBusinessSale() -> Observable<JSON> {
        let response = rxApiManager(api: .getTodayAndlastWeekSales)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取支付方式
    func getPayWay() -> Observable<JSON> {
        let response = rxApiManager(api: .getStorePayWay)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 改变支付方式
    func changePayWay(card: String, cash: String) -> Observable<JSON> {
        let response = rxApiManager(api: .changePayWay(card: card, cash: cash))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 上传推送token
    func updateTSToken(token: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateCloubMessageToken(token: token))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 上传用户经纬度
    func uploadUserLocation(lat: String, lng: String) -> Observable<JSON> {
        let response = rxApiManager(api: .uploadUserLocation(lat: lat, lng: lng))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取订单状态Tag
    func getOrderStatusTag() -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderStatusTag)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取拒接原因
    func getJuJieReason() -> Observable<JSON> {
        let response = rxApiManager(api: .getJujieReason)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 查询营业统计
    func queryStoreBussiness(type: String, date: String) -> Observable<JSON> {
        let response = rxApiManager(api: .queryStoreBussiness(type: type, date: date))
        return Observable<JSON>.create(response)
    }
    

    //MARK: - 获取骑手列表
    func getRiderList() -> Observable<JSON> {
        let response = rxApiManager(api: .getRiderList)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 骑手配送中的
    func getRiderPSZOrderList(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getRiderDeliveryOrderList(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取历史配送
    func getRiderPSHistoryList(id: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getRiderDeliveryHistoryOderList(id: id, page: String(page)))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取骑手位置
    func getRiderLocal(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getRiderLocal(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取繁忙时间
    func getBusyTimeList() -> Observable<JSON> {
        let response = rxApiManager(api: .getBusyTimeList)
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取配送时间范围
    func getTimeRange() -> Observable<JSON> {
        let response = rxApiManager(api: .getTheTimeRange)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置繁忙时间
    func setBusyTime(busyID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setBusyTime(busyID: busyID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置时间范围
    func setRangeTime(type: String, minTime: String, maxTime: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setRangeTime(type: type, maxTime: maxTime, minTime: minTime))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 国际化
    func setLanguage() -> Observable<JSON> {
        let response = rxApiManager(api: .uploadLanguage)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 无法送达原因
    func getUnsuccessfulReason() -> Observable<JSON> {
        let response = rxApiManager(api: .getUnSuccessfulReason)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单批量退回
    func riderCancelAllOrder() -> Observable<JSON> {
        let response = rxApiManager(api: .riderCancelOrder)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取当天现金及配送费总金额
    func getCurentDayCashAndDeFee() -> Observable<JSON> {
        let response = rxApiManager(api: .getCurDayCashAndDeFee)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 登出
    func logout() -> Observable<JSON> {
        let response = rxApiManager(api: .logOut)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 检查更新
    func CheckAppVer() -> Observable<JSON> {
        let response = rxApiManager(api: .CheckAppVer)
        return Observable<JSON>.create(response)
    }

    
    
    
    //MARK: - 上传多张图片
    func uploadImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = BASEURL + "api/rider/upload/images"
        AF.upload(multipartFormData: { (multipartFormData) in
            // 参数：
            // 压缩
            for image in images {
                let data = image.jpegData(compressionQuality: 0.1)
                let fileName = String.init(describing: NSDate()) + ".png"
                // withName:：是根据文档决定传入的字符串
                multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
            }
            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }

        }, to: url, method: .post, headers: HTTPHeaders(["token-rider": UserDefaults.standard.token ?? "", "token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let json):
                let jsonData = JSON(json)
                ERROR_Message = jsonData["msg"].stringValue
                print(jsonData)
                if jsonData["code"].stringValue == "1" {
                    success(jsonData)
                } else {
                    failure(NetworkError.unkonw)
                }
            case .failure(let error):
                ERROR_Message = error.localizedDescription
                failure(NetworkError.unkonw)
            }
        }
    }
}



