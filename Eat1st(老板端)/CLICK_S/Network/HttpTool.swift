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
                        var json = JSON(response.data)
                        
                        if api.path != "api/user/help/getHelpDetail" {
                            //获取数据字典
                            guard let dic = json.dictionaryObject else {
                                return
                            }
                            //字典转json字符串
                            var jsonStr = PJCUtil.convertDictionaryToString(dict: dic)
                            //统一处理转义符号
                            jsonStr = PJCUtil.dealHtmlZhuanYiString(contentStr: jsonStr)

                            //根据处理转义符号后的jsonString生成JSON
                            guard let data = jsonStr.data(using: .utf8) else {
                                return
                            }

                            json = JSON(data)

                        }
                        print(json)
                        
                        if json["code"].stringValue == "1"  {
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
    
    //MARK: - 检查更新
    func checkAppVer() -> Observable<JSON> {
        let response = rxApiManager(api: .checkAppVer)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 登录
    func userLogIn(user: String, pw: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginAction(user: user, pw: pw))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 登出
    func userLogOut() -> Observable<JSON> {
        let response = rxApiManager(api: .logOutAction)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺订单信息
    func getLiveReportingData(date: String, end: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getLiveReportingData(date: date, end: end))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 国际化
    func setLanguage() -> Observable<JSON> {
        let response = rxApiManager(api: .uploadLanguage)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取繁忙时间
    func getBusyTimeList() -> Observable<JSON> {
        let response = rxApiManager(api: .getBusyTimeList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取店铺的营业状态
    func getStoreOnlineStatus() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreOnlineStatus)
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

    
    //MARK: - 营业信息
    func getStoreOpeningHours() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreOpeningHours)
        return Observable<JSON>.create(response)
    }

    //MARK: - 上传推送token
    func updateTSToken(token: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateCloubMessageToken(token: token))
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

    
    //MARK: - 菜品销量统计
    func getDishesReportingData(type: String, day: String, endDay: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishesReportingData(type: type, day: day, endDay: endDay))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取分类和菜品
    func getDishList() -> Observable<JSON> {
        let response = rxApiManager(api: .getDishesList)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取菜品的规格
    func getDishesOptionList(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishesOptionList(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置菜品上下架
    func setDishesOnOff(dishes: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .setDishesOnOffStatus(dishes: dishes))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置菜品规格上下架
    func setSpecOnOffStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setSpecOnOffStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置菜品规格选项上下架
    func setOptionItemOnOffStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setOptionItemOnoffStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取阶梯配送费
    func getDeliveryFeeListAndType() -> Observable<JSON> {
        let response = rxApiManager(api: .getDeliveryFeeListAndType)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加阶梯配送费
    func addDelivaryFee(amount: String, distance: String, postcode: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addDeliveryFee(amount: amount, distance: distance, postCode: postcode, type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑阶梯配送费
    func editeDelivaryFee(amount: String, distance: String, postcode: String, id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editeDeliveryFee(amount: amount, distance: distance, postCode: postcode, id: id))
        return Observable<JSON>.create(response)
    }
    
    
    
    //MARK: - 删除配送费
    func deleteDeliveryFee(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteDeliveryFee(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置配送方式
    func setDeliveryType(type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setDeliveryType(type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品分类
    func getMenuDishClassifyList() -> Observable<JSON> {
        let response = rxApiManager(api: .getMenuClassifyList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加菜品分类
    func addMenuDishClassify(name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addMenuClassify(name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除菜品分类
    func deleteMenuDishClassify(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteMenuClassify(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑菜品分类
    func editeMenuDishClassify(id: String, name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editeMenuClassify(id: id, name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品分类详情
    func getMenuDishClassifyDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getMenuClassifyDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取附加分类
    func getMenuAttachClassifyList() -> Observable<JSON> {
        let response = rxApiManager(api: .getAttachClassifyList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加附加分类
    func addMenuAttachClassify(name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addAttachClassify(name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除菜品附加分类
    func deleteAttachDishClassify(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteAttachClassify(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑菜品附加分类
    func editeAttachDishClassify(id: String, name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editeAttachClassify(id: id, name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品附加分类详情
    func getAttachDishClassifyDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getAttachClassifyDetail(id: id))
        return Observable<JSON>.create(response)
    }

    
    
    //MARK: - 获取赠品分类
    func getMenuGiftClassifyList() -> Observable<JSON> {
        let response = rxApiManager(api: .getGiftClassifyList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加赠品分类
    func addMenuGiftClassify(name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addGiftClassify(name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除赠品分类
    func deleteGiftDishClassify(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteGiftClassify(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑赠品分类
    func editeGiftDishClassify(id: String, name_E: String, name_C: String, name_H: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editeGiftClassify(id: id, name_E: name_E, name_C: name_C, name_H: name_H))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取赠品分类详情
    func getGiftDishClassifyDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getGiftClassifyDetail(id: id))
        return Observable<JSON>.create(response)
    }

    
    //MARK: - 获取分类下的菜品
    func getClassifyDishesList(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getClassifyDishesList(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取分类下附加的菜品
    func getClassifyAttachList(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getClassifyAttachList(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取分类下赠品的菜品
    func getClassifyGiftList(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getClassifyGiftList(id: id))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取菜品详情
    func getDishesDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishesDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品标签
    func getDishTags() -> Observable<JSON> {
        let response = rxApiManager(api: .getDishTags)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑菜品
    func editeDish(model: DishDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editeDish(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加菜品
    func addDish(model: DishDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addDish(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除菜品
    func deleteDish(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteDish(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品规格详情
    func getDishSpecDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishSpecDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑规格
    func editeSpec(model: DishDetailSpecModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editeSpec(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加规格
    func addSpec(model: DishDetailSpecModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addSpec(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除规格
    func deleteSpec(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteSpec(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑规格选项
    func editeSpecOption(model: DishDetailOptionModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editeSpecOption(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加规格选项
    func addSpecOption(model: DishDetailOptionModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addSpecOption(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除规格选项
    func deleteSpecOption(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteSpecOption(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取附加详情
    func getAdditionalDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getAdditionalDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加菜品附加
    func addAdditional(model: AdditionalDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addAdditional(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除菜品附加
    func deleteAdditional(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteAdditional(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑菜品附加
    func editeAdditional(model: AdditionalDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editeAdditional(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取赠品详情
    func getGiftDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getGiftDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加赠品
    func addGift(model: GiftDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addGift(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除赠品
    func deleteGift(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteGift(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑赠品
    func editeGift(model: GiftDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editeGift(model: model))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取店铺的支付方式
    func getPaymentMethod() -> Observable<JSON> {
        let response = rxApiManager(api: .getPaymentMethod)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置店铺的支付方式
    func setPaymentMethod(card: String, cash: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setPaymentMethod(card: card, cash: cash))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置菜品库存
    func setDishLimitBuy(dishID: String, type: String, num: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setDishLimitBuy(dishId: dishID, limitType: type, limitNum: num))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取订单数量
    func getOrderNumber() -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderNum)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品周销量数据
    func getDishSales_Month(dishID: String, date: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishSales_Month(dishID: dishID, date: date, type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品的月销量数据
    func getDishSales_Week(dishID: String, startDate: String, endDate: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishSales_Week(dishID: dishID, startDate: startDate, endDate: endDate, type: type))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置菜品优惠
    func setDishesDiscount(dishId: String, discountType: String, discountPrice: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setDishedDiscount(id: dishId, type: discountType, price: discountPrice))
        return Observable<JSON>.create(response)
    }
    
    
    
    
    
    
    
    
    
    

    

    
    
    
    
    

    
    
    //MARK: - 订单列表
    func getOrderList(page: Int, tag: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderList(page: String(page), tag: tag, type: type))
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
    
    
    //MARK: - 上传菜品图片
    func uploadDishImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = BASEURL + "api/boss/upload/dishes"
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

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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
    
    
    //MARK: - 上传赠品图片
    func uploadGiftImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = BASEURL + "api/boss/upload/gift"
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

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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
    

    
    
    
    
    //MARK: - 上传图片
    func uploadImage(image: UIImage, success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->())  {

        let url = BASEURL + "/index/index/upload"
        let params = ["Authorization": UserDefaults.standard.token ?? ""]
        AF.upload(multipartFormData: { (multipartFormData) in
            // 压缩
            let data = image.jpegData(compressionQuality: 0.1)
            let fileName = String.init(describing: NSDate()) + ".png"
            // withName:：是根据文档决定传入的字符串
            multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")

            // 遍历添加参数
            for (key, value) in params{
                // string 转 data
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

        }, to: url, method: .post, headers: HTTPHeaders([:])).responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let json):
                let jsonData = JSON(json)
                ERROR_Message = jsonData["msg"].stringValue
                print(jsonData)
                if jsonData["code"].stringValue == "0" || jsonData["code"].stringValue == "200" {
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



