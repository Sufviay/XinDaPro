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

    
    //MARK: - 营业时间列表
    func getStoreOpeningHours() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreOpeningHours)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 添加营业时间
    func addOpeningHours(model: AddTimeSubmitModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addOpeningHours(submitModel: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取营业时间菜品
    func getTimeBindingDishes(timeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getTimeBindingDishes(timeID: timeID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 保存营业时间菜品
    func saveTimeBindingDishes(timeID: String, dishes: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .saveTimeBindingDishes(timeID: timeID, dishes: dishes))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑时间段
    func editOpeningHours(model: AddTimeSubmitModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editOpeningHours(submitModel: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除时间段
    func deleteOpeningHours(timeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteOpeningHours(timeID: timeID))
        return Observable<JSON>.create(response)
    }

    //MARK: - 营业时间禁用和启用
    func openingHoursCanUse(timeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .OpeningHoursCanUse(timeID: timeID))
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
    func setDishesDiscount(dishId: String, discountType: String, discountPrice: String, startTime: String, endTime: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setDishedDiscount(id: dishId, type: discountType, price: discountPrice, startTime: startTime, endTime: endTime))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 新增或修改规格
    func specDoAddOrUpdate(model: DishDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .specDoAddOrUpdate(model: model))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 新增或修改套餐
    func comboDoAddOrUpdate(model: DishDetailModel) -> Observable<JSON> {
        let response = rxApiManager(api: .comboDoAddOrUpdate(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取消息
    func getMsgList(page: Int, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getMsgList(page: String(page), type: type))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取合并订单的详情
    func getMergeDetail(mergeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getMergeDetail(mergeID: mergeID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 评论列表
    func getReviewsList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getReviewsList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 投诉列表
    func getComplatinsList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getComplainsList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 投诉详情
    func getComplatinsDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getComplainsDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取投诉处理内容
    func getComplaintDealContent() -> Observable<JSON> {
        let response = rxApiManager(api: .getDealComplaintWay)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 处理投诉
    func doComplaints(plaintId: String, handleType: String, refundMode: String, amount: String, refundFlow: String, plaintDishesList: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .doComplains(plaintId: plaintId, handleType: handleType, refundMode: refundMode, amount: amount, refundFlow: refundFlow, plaintDishesList: plaintDishesList))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 回复评价
    func doEvaluateReply(id: String, content: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doEvaluateReply(id: id, content: content))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取餐桌列表
    func getDeskList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getDeskList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除餐桌
    func deleteDesk(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteDesk(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 餐桌启用禁用
    func setDeskStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setDeskStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加餐桌
    func addDesk(name: String, remark: String, num: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addDesk(name: name, remark: remark, num: num))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑餐桌
    func editDesk(id: String, name: String, remark: String, num: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editDesk(id: id, name: name, remark: remark, num: num))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 更新菜品价格
    func updateDishesPrice(id: String, sellType: String, buffetType: String, dePrice: String, dinePrice: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateDishesPrice(id: id, sellType: sellType, buffetType: buffetType, dePrice: dePrice, dinePrice: dinePrice))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取打印机列表
    func getPrinterList() -> Observable<JSON> {
        let response = rxApiManager(api: .getPrinterList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加打印机
    func addPrinter(model: PrinterModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addPrinter(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 编辑打印机
    func editPrinter(model: PrinterModel) -> Observable<JSON> {
        let response = rxApiManager(api: .editePrinter(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 启用禁用打印机
    func doPrinterStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .printerDoStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除打印机
    func deletePrinter(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deletePrinter(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 添加买一赠一
    func doGiveOne(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doGiveOne(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置套餐菜品
    func doBaleType(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doBaleType(id: id))
        return Observable<JSON>.create(response)
                        
    }
    
    
    //MARK: - 获取店铺收入
    func getStoreInCost(dateType: String, start: String, end: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreInCost(dateType: dateType, start: start, end: end))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取店铺支出
    func getStoreOutCost() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreOutCost)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 设置是否为主打印
    func doMainPrinter(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doMainPrinter(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取用户预约列表
    func getUserBookingList(page: Int, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getUserBookingList(page: String(page), type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加预约
    func addBooking(model: AddBookingModel) -> Observable<JSON> {
        let response = rxApiManager(api: .addBooking(model: model))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取店铺预约时间
    func getStoreBookingTime(date: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreBookingTime(date: date))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 确认预约      预定结果（2拒绝预定，4预定成功
    func doConfirmBooking(id: String, type: String, deskID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doConfirmBooking(id: id, type: type, deskID: deskID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 取消预约
    func doCancelBooking(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doCancelBooking(id: id))
        return Observable<JSON>.create(response)
    }

    //MARK: - 表格页面预约数据
    func getBookingDataInCharts(date: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getBookingDataInCharts(date: date))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取店铺是否可预定
    func getStoreBookingStatus() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreBookingStatus)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 恢复拒绝或者取消的预定
    func doReconfimBooking(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doReconfirm(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 预约进店
    
    func doCheckinBooking(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doBookingCheckin(id: id))
        return Observable<JSON>.create(response)
    }


    //MARK: - 获取汇总打印信息
    func getPrintSummary(type: String, start: String, end: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getPrintSummary(dateType: type, start: start, end: end))
        return Observable<JSON>.create(response)
    }


    //MARK: - 获取店铺营业额统计     配送类型（1外卖，2堂食，不传查询全部）    统计类型（1今日，2本周，3本月，不传默认今日）
    func getStoreSales(queryType: String, deliveryType: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreSales(deliveryType: deliveryType, queryType: queryType))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取统计菜品的分类
    func getStaticClassifyList() -> Observable<JSON> {
        let response = rxApiManager(api: .getStatisClassifyList)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取分类下菜品销量
    func getStaticClassifyDishesSales(id: String, type: String, start: String, end: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStatisClassifyDishesList(id: id, type: type, start: start, end: end))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取打印机关联菜品
    func getPrinterLinkDishes(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getPrinterDishesList(printerID: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 打印机关联菜品
    func setPrinterDishes(id: String, dishes: [Int64]) -> Observable<JSON> {
        let response = rxApiManager(api: .setPrinterLinkDishes(printerID: id, dishesArr: dishes))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 订单详情
    func getOrderDetail(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderDetail(orderID: orderID))
        return Observable<JSON>.create(response)
    }

    
    //MARK: - 设置菜品附加的启用禁用状态
    func setAttachStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setAttachStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置菜品VIP价格
    func doDishVIP(id: String, typeStr: String, price: String, status: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doDishVipPrice(id: id, typeStr: typeStr, price: price, status: status))
        return Observable<JSON>.create(response)
    }



    

    
    
//    //MARK: - 订单列表
//    func getOrderList(page: Int, tag: String, type: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .getOrderList(page: String(page), tag: tag, type: type))
//        return Observable<JSON>.create(response)
//    }
//    
//
//    
//    //MARK: 出餐
//    func chuCanAciton(orderID: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .orderChuCanAction(orderID: orderID))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 接单
//    func jiedanAction(orderID: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .orderJieDanAction(orderID: orderID))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 拒接
//    func jujieAciton(orderID: String, customReason: String, reasonID: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .orderJuJieAction(orderID: orderID, customReason: customReason, reasonID: reasonID))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 开始配送
//    func kaiShiPeiSongAction(orderID: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .orderkaiShiPeiSongAction(orderID: orderID))
//        return Observable<JSON>.create(response)
//    }
//    
//    
//    //MARK: - 确认收货
//    func shouHuoAction(orderID: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .orderShouHuoAction(orderID: orderID))
//        return Observable<JSON>.create(response)
//    }
//    
//
//
//    
//    
//    //MARK: - 获取投诉内容
//    func loadComplainContent(orderId: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .loadComplainContent(orderID: orderId))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 处理投诉
//    func dealComplaintAction(orderID: String, code: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .dealComplain(orderID: orderID, code: code))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 获取营业金额
//    func getBusinessSale() -> Observable<JSON> {
//        let response = rxApiManager(api: .getTodayAndlastWeekSales)
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 获取支付方式
//    func getPayWay() -> Observable<JSON> {
//        let response = rxApiManager(api: .getStorePayWay)
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 改变支付方式
//    func changePayWay(card: String, cash: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .changePayWay(card: card, cash: cash))
//        return Observable<JSON>.create(response)
//    }
//    
//    
//    
//    //MARK: - 上传用户经纬度
//    func uploadUserLocation(lat: String, lng: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .uploadUserLocation(lat: lat, lng: lng))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 获取订单状态Tag
//    func getOrderStatusTag() -> Observable<JSON> {
//        let response = rxApiManager(api: .getOrderStatusTag)
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 获取拒接原因
//    func getJuJieReason() -> Observable<JSON> {
//        let response = rxApiManager(api: .getJujieReason)
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 查询营业统计
//    func queryStoreBussiness(type: String, date: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .queryStoreBussiness(type: type, date: date))
//        return Observable<JSON>.create(response)
//    }
//    
//
//    //MARK: - 获取骑手列表
//    func getRiderList() -> Observable<JSON> {
//        let response = rxApiManager(api: .getRiderList)
//        return Observable<JSON>.create(response)
//    }
//    
//    
//    //MARK: - 骑手配送中的
//    func getRiderPSZOrderList(id: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .getRiderDeliveryOrderList(id: id))
//        return Observable<JSON>.create(response)
//    }
//    
//    //MARK: - 获取历史配送
//    func getRiderPSHistoryList(id: String, page: Int) -> Observable<JSON> {
//        let response = rxApiManager(api: .getRiderDeliveryHistoryOderList(id: id, page: String(page)))
//        return Observable<JSON>.create(response)
//    }
//
//    //MARK: - 获取骑手位置
//    func getRiderLocal(id: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .getRiderLocal(id: id))
//        return Observable<JSON>.create(response)
//    }
    
    
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

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? "", "token-boss": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? "", "token-boss": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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
    

    
    
    
    
//    //MARK: - 上传图片
//    func uploadImage(image: UIImage, success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->())  {
//
//        let url = BASEURL + "/index/index/upload"
//        let params = ["Authorization": UserDefaults.standard.token ?? ""]
//        AF.upload(multipartFormData: { (multipartFormData) in
//            // 压缩
//            let data = image.jpegData(compressionQuality: 0.1)
//            let fileName = String.init(describing: NSDate()) + ".png"
//            // withName:：是根据文档决定传入的字符串
//            multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
//
//            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, to: url, method: .post, headers: HTTPHeaders([:])).responseJSON { (dataResponse) in
//            switch dataResponse.result {
//            case .success(let json):
//                let jsonData = JSON(json)
//                ERROR_Message = jsonData["msg"].stringValue
//                print(jsonData)
//                if jsonData["code"].stringValue == "0" || jsonData["code"].stringValue == "200" {
//                    success(jsonData)
//                } else {
//                    failure(NetworkError.unkonw)
//                }
//            case .failure(let error):
//                ERROR_Message = error.localizedDescription
//                failure(NetworkError.unkonw)
//            }
//        }
//    }

}



