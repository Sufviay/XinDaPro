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
    case setDishesOnOffStatus(dishes: [[String: String]], status: String)
    ///获取店铺阶梯配送费列表和配送方式
    case getDeliveryFeeListAndType
    ///添加店铺阶梯配送费
    case addDeliveryFee(amount: String, distance: String, postCode: String, type: String)
    ///编辑店铺的配送费
    case editeDeliveryFee(amount: String, distance: String, postCode: String, id: String)
    ///设置配送方式
    case setDeliveryType(type: String)
    
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
    case setDishedDiscount(id: String, type: String, price: String, startTime: String, endTime: String)
    ///添加时间段
    case addOpeningHours(submitModel: AddTimeSubmitModel)
    ///请求时间段关联菜品
    case getTimeBindingDishes(timeID: String)
    ///保存时间段关联菜品
    case saveTimeBindingDishes(timeID: String, dishes: [[String: String]])
    ///编辑时间段
    case editOpeningHours(submitModel: AddTimeSubmitModel)
    ///删除时间段
    case deleteOpeningHours(timeID: String)
    ///店铺营业时间禁用 启用
    case OpeningHoursCanUse(timeID: String)
    ///增加或修改菜品的规格
    case specDoAddOrUpdate(model: DishDetailModel)
    ///增加或修改套餐信息
    case comboDoAddOrUpdate(model: DishDetailModel)
    ///获取消息列表
    case getMsgList(page: String, typeList: [String])
    ///获取合并订单的订单列表
    case getMergeDetail(mergeID: String)
    ///获取投诉列表
    case getComplainsList(page: String)
    ///获取评论列表
    case getReviewsList(page: String)
    ///获取投诉详情
    case getComplainsDetail(id: String)
    ///处理投诉
    case doComplains(plaintId: String, handleType: String, refundMode: String, amount: String, refundFlow: String, plaintDishesList: [[String: String]])
    ///回复评论
    case doEvaluateReply(id: String, content: String)
    ///获取餐桌列表
    case getDeskList(page: String)
    ///餐桌的启用禁用
    case setDeskStatus(id: String)
    ///删除餐桌
    case deleteDesk(id: String)
    ///添加餐桌
    case addDesk(name: String, remark: String, num: String)
    ///编辑餐桌
    case editDesk(id: String, name: String, remark: String, num: String)
    ///更新菜品价格
    case updateDishesPrice(id: String, sellType: String, buffetType: String, dePrice: String, dinePrice: String)
    ///打印机列表
    case getPrinterList
    ///新增打印机
    case addPrinter(model: PrinterModel)
    ///编辑打印机
    case editePrinter(model: PrinterModel)
    ///启用禁用打印机
    case printerDoStatus(id: String)
    ///删除打印机
    case deletePrinter(id: String)
    ///菜品添加买一赠一
    case doGiveOne(id: String)
    ///设置菜品是否为点心套餐菜品
    case doBaleType(id: String)
    ///获取店铺收入
    case getStoreInCost(dateType: String, start: String, end: String)
    ///获取店铺支出
    case getStoreOutCost
    ///设置是否为主打印机
    case doMainPrinter(id: String)
    ///获取用户已预定列表
    case getUserBookingList(page: String, type: String)
    ///添加预约
    case addBooking(model: AddBookingModel)
    ///获取店铺预约时间
    case getStoreBookingTime(date: String)
    ///取消预约
    case doCancelBooking(id: String)
    ///处理预约
    case doConfirmBooking(id: String, type: String, deskID: String)
    ///表格页面的预约数据
    case getBookingDataInCharts(date: String)
    ///店铺是否可以预约 1否2是
    case getStoreBookingStatus
    ///恢复取消或者拒绝的预定
    case doReconfirm(id: String)
    ///用户预约进店
    case doBookingCheckin(id: String)
    ///获取汇总打印信息
    case getPrintSummary(dateType: String, start: String, end: String)
    ///获取营业额统计
    case getStoreSales(deliveryType: String, queryType: String)
    ///获取分类统计列表
    case getStatisClassifyList
    ///获取分类统计下菜的排名
    case getStatisClassifyDishesList(id: String, type: String, start: String, end: String)
    
    ///获取打印机关联菜品
    case getPrinterDishesList(printerID: String)
    ///设置打印机菜品
    case setPrinterLinkDishes(printerID: String, dishesArr: [Int64])
    ///获取投诉处理方式
    case getDealComplaintWay
    ///获取订单详情
    case getOrderDetail(orderID: String)
    ///启用禁用菜品附加
    case setAttachStatus(id: String)
    ///设置菜品VIP
    case doDishVipPrice(id: String, typeStr: String, price: String, status: String)
    ///查询Uber的销售信息
    case getUberSummary(dateType: String, start: String, end: String)
    ///获取节假日列表
    case getHolidayList
    ///添加节假日
    case addHoliday(model: HolidayModel)
    ///删除节假日
    case deleteHoliday(id: String)
    ///编辑节假日
    case editHoliday(model: HolidayModel)
    ///获取订单列表
    case getAllOrderList(startDate: String, endDate: String, source: String, userID: String, payType: String, status: String, timePeriod: String, page: String)
    ///修改密碼
    case changePassword(new: String, old: String, reNew: String)
    ///获取其他平台的菜品销量
    case getOtherDishesSummary(page: Int, searchType: String, start: String, end: String, ptType: String)
    ///获取其他平台订单数据
    case getOtherOrderSummary(searchType: String, start: String, end: String, ptType: String)
    ///获取店铺信息
    case getStoreInfo
    ///设置店铺起送金额
    case setStoreMineOrderPrice(price: String)
    ///設置數據查詢範圍
    case doStoreSalesScope(id: String)
    ///获取客户列表
    case getCustomerList(page: Int, start: String, end: String, sortAsc: String, sortBy: String)
    ///優惠列表
    case getCouponRuleList(isHistory: Bool, status: String, page: Int)
    ///添加优惠券
    case addCoupon(model: CouponModel)
    ///获取优惠券关联菜品
    case getCouponCanSelectDishesList
    ///編輯優惠狀態
    case editCouponStatus(id: String, status: String)
    ///獲取優惠詳情
    case getCouponDetail(id: String)
    ///餐桌排序
    case deskDoSort(sortList: [[String: String]])
    ///获取用户标签列表
    case getCustomerTagList
    ///新增用户标签
    case addCustomerTag(status: String, nameEn: String, nameCn: String, nameHk: String)
    ///编辑用户标签
    case editCustomerTag(id: String, status: String, nameEn: String, nameCn: String, nameHk: String)
    ///删除用户标签
    case deleteCustomerTag(id: String)
    ///用戶綁定標籤
    case userLinkTags(userID: String, tagList: [String])
    

        
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
            return "api/boss/store/opentime/getStoreOpenTimeStatus"
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
            return "api/boss/store/opentime/getStoreOpenTimeList"
        case .setStoreOpeningHours(starTime: _, endTime: _, type: _, timeID: _):
            return "api/boss/store/updateDayOpenTime"
        case .setStoreOpenStatusByDay(timeID: _, coStatus: _, deStatus: _):
            return "api/boss/store/updateDayOpenStatus"
        case .setStoreOpenStatus(coStatus: _, deStatus: _):
            return "api/boss/store/updateAllOpenStatus"
        case .setDishesOnOffStatus(dishes: _,  status: _):
            return "api/boss/dishes/doStatus"
        case .getDeliveryFeeListAndType:
            return "api/boss/store/delivery/fee/getDeliveryTypeAndFeeList"
        case .addDeliveryFee(amount: _, distance: _, postCode: _, type: _):
            return "api/boss/store/delivery/fee/doSaveDeliveryFee"
        case .editeDeliveryFee(amount: _, distance: _, postCode: _, id: _):
            return "api/boss/store/delivery/fee/doUpdateDeliveryFee"
        case .deleteDeliveryFee(id: _):
            return "api/boss/store/delivery/fee/doDelDeliveryFee"
        case .setDeliveryType(type: _):
            return "api/boss/store/delivery/fee/doDeliveryType"
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
        case .setDishedDiscount(id: _, type: _, price: _, startTime: _ , endTime: _):
            return "api/boss/dishes/doDiscount"
        case .addOpeningHours(submitModel: _):
            return "api/boss/store/opentime/doAddStoreOpenTime"
        case .getTimeBindingDishes(timeID: _):
            return "api/boss/store/opentime/getStoreOpenTimeDishesList"
        case .saveTimeBindingDishes(timeID: _, dishes: _):
            return "api/boss/store/opentime/doSaveOpenTimeDishes"
        case .editOpeningHours(submitModel: _):
            return "api/boss/store/opentime/doUpdateStoreOpenTime"
        case .deleteOpeningHours(timeID: _):
            return "api/boss/store/opentime/doDelOpenTime"
        case .OpeningHoursCanUse(timeID: _):
            return "api/boss/store/opentime/doStatusOpenTime"
        case .specDoAddOrUpdate(model: _):
            return "api/boss/dishes/spec/doAddOrUpdate"
        case .comboDoAddOrUpdate(model: _):
            return "api/boss/dishes/combo/doAddOrUpdate"
        case .getMsgList(page: _, typeList: _):
            return "api/boss/operate/log/getLogList"
        case .getMergeDetail(mergeID: _):
            return "api/boss/merge/getMergeDetail"
        case .getComplainsList(page: _):
            return "api/boss/plaint/getBossPlaintList"
        case .getReviewsList(page: _):
            return "api/boss/evaluate/getEvaluateList"
        case .getComplainsDetail(id: _):
            return "api/boss/plaint/getPlaintDetail"
        case .doComplains(plaintId: _, handleType: _, refundMode: _, amount: _, refundFlow: _, plaintDishesList: _):
            return "api/boss/plaint/doBossPlaint"
        case .doEvaluateReply(id: _, content: _):
            return "api/boss/evaluate/doReply"
        case .getDeskList(page: _):
            return "api/boss/desk/getDeskList"
        case .setDeskStatus(id: _):
            return "api/boss/desk/doStatus"
        case .deleteDesk(id: _):
            return "api/boss/desk/doDelete"
        case .editDesk(id: _, name: _, remark: _, num: _):
            return "api/boss/desk/doUpdate"
        case .addDesk(name: _, remark: _, num: _):
            return "api/boss/desk/doAdd"
        case .updateDishesPrice(id: _, sellType: _, buffetType: _, dePrice: _, dinePrice: _):
            return "api/boss/dishes/doUpdatePrice"
        case .getPrinterList:
            return "api/boss/printer/getPrinterList"
        case .addPrinter(model: _):
            return "api/boss/printer/doAdd"
        case .editePrinter(model: _):
            return "api/boss/printer/doUpdate"
        case .printerDoStatus(id: _):
            return "api/boss/printer/doStatus"
        case .deletePrinter(id: _):
            return "api/boss/printer/doDelete"
        case .doGiveOne(id: _):
            return "api/boss/dishes/doGiveOne"
        case .doBaleType(id: _):
            return "api/boss/dishes/doBaleType"
        case .getStoreInCost(dateType: _, start: _, end: _):
            return "api/boss/store/cost/getStoreInCost"
        case .getStoreOutCost:
            return "api/boss/store/cost/getStoreOutCost"
        case .doMainPrinter(id: _):
            return "api/boss/printer/doPrintMain"
        case .getUserBookingList(page: _, type: _):
            return "api/boss/desk/reserve/getUserReserveList"
        case .addBooking(model: _):
            return "api/boss/desk/reserve/doAddReserve"
        case .getStoreBookingTime(date: _):
            return "api/boss/desk/reserve/getStoreReserveList"
        case .doCancelBooking(id: _):
            return "api/boss/desk/reserve/doCancelReserve"
        case .doConfirmBooking(id: _, type: _, deskID: _):
            return "api/boss/desk/reserve/doReserveConfirm"
        case .getBookingDataInCharts(date: _):
            return "api/boss/desk/reserve/getUserReserveCalList"
        case .getStoreBookingStatus:
            return "api/boss/desk/reserve/getReserveStatus"
        case .doReconfirm(id: _):
            return "api/boss/desk/reserve/doRestore"
        case .doBookingCheckin(id: _):
            return "api/boss/desk/reserve/doUserInStore"
        case .getPrintSummary(dateType: _, start: _, end: _):
            return "api/boss/store/cost/getSummary"
        case .getStoreSales(deliveryType: _, queryType: _):
            return "api/boss/report/getSales"
        case .getStatisClassifyList:
            return "api/boss/dishes/classify/statis/getClassifyList"
        case .getStatisClassifyDishesList(id: _, type: _, start: _, end: _):
            return "api/boss/dishes/classify/statis/getDishesSalesList"
        case .setPrinterLinkDishes(printerID: _, dishesArr: _):
            return "api/boss/printer/dishes/doLink"
        case .getPrinterDishesList(printerID: _):
            return "api/boss/printer/dishes/getDishesList"
        case .getDealComplaintWay:
            return "api/boss/plaint/getPlaintTypeList"
        case .getOrderDetail(orderID: _):
            return "api/boss/order/getOrderDetail"
        case .setAttachStatus(id: _):
            return "api/boss/dishes/attach/doStatus"
        case .doDishVipPrice(id: _, typeStr: _, price: _, status: _):
            return "api/boss/dishes/doVipPrice"
        case .getUberSummary(dateType: _, start: _, end: _):
            return "api/boss/report/getUberSummary"
        case .getHolidayList:
            return "api/boss/store/holiday/getList"
        case .addHoliday(model: _):
            return "api/boss/store/holiday/addHoliday"
        case .deleteHoliday(id: _):
            return "api/boss/store/holiday/deleteHoliday"
        case .editHoliday(model: _):
            return "api/boss/store/holiday/editHoliday"
        case .getAllOrderList(startDate: _, endDate: _, source: _, userID: _, payType: _, status: _, timePeriod: _, page: _):
            return "api/boss/order/getAllOrderList"
        case .changePassword(new: _, old: _, reNew: _):
            return "api/boss/changePassword"
        case .getOtherDishesSummary(page: _, searchType: _, start: _, end: _, ptType: _):
            return "api/boss/report/getOtherDishesSummary"
        case .getOtherOrderSummary(searchType: _, start: _, end: _, ptType: _):
            return "api/boss/report/getOtherOrderSummary"
        case .getStoreInfo:
            return "api/boss/store/getStoreInfo"
        case .setStoreMineOrderPrice(price: _):
            return "api/boss/store/doStoreMinOrderPrice"
        case .doStoreSalesScope(id: _):
            return "api/boss/store/doStoreSalesScope"
        case .getCustomerList(page: _, start: _, end: _, sortAsc: _, sortBy: _):
            return "api/boss/user/getUserList"
        case .getCouponRuleList(isHistory: _, status: _, page: _):
            return "api/boss/coupon/rule/getList"
        case .addCoupon(model: _):
            return "api/boss/coupon/rule/doAdd"
        case .getCouponCanSelectDishesList:
            return "api/boss/coupon/rule/getSelDishesList"
        case .editCouponStatus(id: _, status: _):
            return "api/boss/coupon/rule/doStatus"
        case .getCouponDetail(id: _):
            return "api/boss/coupon/rule/getInfo"
        case .deskDoSort(sortList: _):
            return "api/boss/desk/doSort"
        case .getCustomerTagList:
            return "api/boss/user/tag/getList"
        case .addCustomerTag(status: _, nameEn: _, nameCn: _, nameHk: _):
            return "api/boss/user/tag/doAdd"
        case .editCustomerTag(id: _, status: _, nameEn: _, nameCn: _, nameHk: _):
            return "api/boss/user/tag/doUpdate"
        case .deleteCustomerTag(id: _):
            return "api/boss/user/tag/doDelete"
        case .userLinkTags(userID: _, tagList: _):
            return "api/boss/user/tag/doUserTag"
            
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
        case .setDishesOnOffStatus(let dishes, let status):
            dic = ["dishesList" : dishes, "status": status]
        case .getDeliveryFeeListAndType:
            dic = [:]
        case .addDeliveryFee(let amount, let distance, let postCode, let type):
            dic = ["amount": amount, "distance": distance, "postCode": postCode, "feeType": type]
        case .editeDeliveryFee(let amount, let distance, let postCode, let id):
            dic = ["amount": amount, "distance": distance, "postCode": postCode, "feeId": id]
        case .deleteDeliveryFee(let id):
            dic = ["feeId": id]
        case .setDeliveryType(let type):
            dic = ["feeType": type]
            
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
        case .setDishedDiscount(let id, let type, let price, let start, let end):
            dic = ["dishesId": id, "discountType": type, "discountPrice": price, "endTime": end, "startTime": start]
        case .addOpeningHours(let submitModel):
            dic = submitModel.toJSON() ?? [:]
        case .getTimeBindingDishes(let timeID):
            dic = ["storeTimeId": timeID]
        case .saveTimeBindingDishes(let timeID, let dishes):
            dic = ["storeTimeId": timeID, "dishesList": dishes]
        case .editOpeningHours(let submitModel):
            dic = submitModel.toJSON() ?? [:]
        case .deleteOpeningHours(let timeID):
            dic = ["storeTimeId": timeID]
        case .OpeningHoursCanUse(let timeID):
            dic = ["storeTimeId": timeID]
        case .specDoAddOrUpdate(let model):
            dic = model.toJSON() ?? [:]
        case .comboDoAddOrUpdate(let model):
            dic = model.toJSON() ?? [:]
        case .getMsgList(let page, let typeList):
            dic = ["pageIndex": page, "operateTypeList": typeList]
        case .getMergeDetail(let mergeID):
            dic = ["mergeId": mergeID]
        case .getReviewsList(let page):
            dic = ["pageIndex": page]
        case .getComplainsList(let page):
            dic = ["pageIndex": page]
        case .getComplainsDetail(let id):
            dic = ["plaintId": id]
        case .doComplains(let plaintId, let handleType, let refundMode, let amount, let refundFlow, let plaintDishesList):
            dic = ["plaintId": plaintId, "handleType": handleType, "refundMode": refundMode, "amount": amount, "refundFlow": refundFlow, "plaintDishesList": plaintDishesList]
        case .doEvaluateReply(let id, let content):
            dic = ["evaluateId": id, "replyContent": content]
        case .getDeskList(let page):
            dic = ["pageIndex": page]
        case .setDeskStatus(let id):
            dic = ["deskId": id]
        case .deleteDesk(let id):
            dic = ["deskId": id]
        case .editDesk(let id, let name, let remark, let num):
            dic = ["deskId": id, "deskName": name, "remark": remark, "dinersNum": num]
        case .addDesk(let name, let remark, let num):
            dic = ["deskName": name, "remark": remark, "dinersNum": num]
        case .updateDishesPrice(let id, let sellType, let buffetType, let dePrice, let dinePrice):
            dic = ["dishesId": id, "sellType": sellType, "buffetType": buffetType, "deliPrice": dePrice, "dinePrice": dinePrice]
        case .getPrinterList:
            dic = [:]
        case .addPrinter(let model):
            dic = model.toJSON() ?? [:]
        case .editePrinter(let model):
            dic = model.toJSON() ?? [:]
        case .printerDoStatus(let id):
            dic = ["printerId": id]
        case .deletePrinter(let id):
            dic = ["printerId": id]
        case .doGiveOne(let id):
            dic = ["dishesId": id]
            
        case .doBaleType(let id):
            dic = ["dishesId": id]
        case .getStoreInCost(let dateType, let start, let end):
            dic = ["type": dateType, "start": start, "end": end]
        case .getStoreOutCost:
            dic = [:]
        case .doMainPrinter(let id):
            dic = ["printerId": id]
        case .getUserBookingList(let page, let type):
            dic = ["pageIndex": page, "reserveStatus": type]
        case .addBooking(let model):
            dic = model.toJSON() ?? [:]
        case .getStoreBookingTime(let date):
            dic = ["date": date]
        case .doCancelBooking(let id):
            dic = ["userReserveId": id]
        case .doConfirmBooking(let id, let type, let deskID):
            dic = ["userReserveId": id, "reserveType": type, "deskId": deskID]
        case .getBookingDataInCharts(let date):
            dic = ["date": date]
        case .getStoreBookingStatus:
            dic = [:]
        case .doReconfirm(let id):
            dic = ["userReserveId": id]
        case .doBookingCheckin(let id):
            dic = ["userReserveId": id]
        case .getPrintSummary(let dateType, let start, let end):
            dic = ["type": dateType, "start": start, "end": end]
        case .getStoreSales(let deliveryType, let queryType):
            dic = ["deliveryType": deliveryType, "queryType": queryType]
        case .getStatisClassifyList:
            dic = [:]
        case .getStatisClassifyDishesList(let id, let type, let start, let end):
            dic = ["classifyId": id, "searchType": type, "day": start, "end": end]
        case .setPrinterLinkDishes(let printerID, let dishesArr):
            dic = ["printerId": printerID, "dishesList": dishesArr]
        case .getPrinterDishesList(let printerID):
            dic = ["printerId": printerID]
        case .getDealComplaintWay:
            dic = [:]
        case .getOrderDetail(let orderID):
            dic = ["orderId": orderID]
        case .setAttachStatus(let id):
            dic = ["attachId": id]
        case .doDishVipPrice(let id, let typeStr, let price, let status):
            dic = ["dishesId": id, "vipDeliveryStr": typeStr, "vipPrice": price, "vipType": status]
        case .getUberSummary(let dateType, let start, let end):
            dic = ["queryType": dateType, "start": start, "end": end]
        case .getHolidayList:
            dic = [:]
        case .addHoliday(let model):
            dic = model.toJSON() ?? [:]
        case .deleteHoliday(let id):
            dic = ["id": id]
        case .editHoliday(let model):
            dic = model.toJSON() ?? [:]
        case .getAllOrderList(let start, let end, let source, let userID,  let payType, let status, let timePeriod, let page):
            dic = ["startDate": start, "endDate": end, "source": source, "userId": userID, "pageIndex": page, "payType": payType, "timePeriod": timePeriod, "status": status]
        case .changePassword(let new, let old, let reNew):
            dic = ["newPassword": new, "oldPassword": old, "verifyPassword": reNew]
        case .getOtherDishesSummary(let page, let searchType, let start, let end, let ptType):
            dic = ["pageIndex": page, "searchSource": ptType, "searchType": searchType, "day": start, "end": end]
        case .getOtherOrderSummary(let searchType, let start, let end, let ptType):
            dic = ["searchSource": ptType, "searchType": searchType, "day": start, "end": end]
        case .getStoreInfo:
            dic = [:]
        case .setStoreMineOrderPrice(let price):
            dic = ["minOrderPrice": price]
        case .doStoreSalesScope(let id):
            dic = ["id": id]
        case .getCustomerList(let page, let start, let end, let sortAsc, let sortBy):
            dic = ["pageIndex": page, "startDate": start, "endDate": end, "sortAsc": sortAsc, "sortBy": sortBy]
        case .getCouponRuleList(let isHistory, let status, let page):
            dic = ["history": isHistory, "status": status, "pageIndex": page]
        case .addCoupon(let model):
            dic = model.toJSON() ?? [:]
        case .getCouponCanSelectDishesList:
            dic = [:]
        case .editCouponStatus(let id, let status):
            dic = ["id": id, "status": status]
        case .getCouponDetail(let id):
            dic = ["id": id]
        case .deskDoSort(let sortList):
            dic = ["deskSortList": sortList]
        case .addCustomerTag(let status, let nameEn, let nameCn, let nameHk):
            dic = ["status": status, "nameCn": nameCn, "nameEn": nameEn, "nameHk": nameHk]
        case .getCustomerTagList:
            dic = [:]
        case .editCustomerTag(let id, let status, let nameEn, let nameCn, let nameHk):
            dic = ["status": status, "nameCn": nameCn, "nameEn": nameEn, "nameHk": nameHk, "tagId": id]
        case .deleteCustomerTag(let id):
            dic = ["tagId": id]
        case .userLinkTags(let userID, let tagList):
            dic = ["userId": userID, "tagIdList": tagList]
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
                       "token": token,
                       "token-boss": token,
                       "verId": UserDefaults.standard.verID ?? "0",
                       "verCode": "v\(curAppVer)",
                       "sysType": "06",
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

