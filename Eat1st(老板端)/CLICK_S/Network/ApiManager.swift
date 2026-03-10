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
    ///1检查App版本
    case checkAppVer
    ///2登录
    case loginAction(user: String, pw: String)
    ///3登出
    case logOutAction
    ///4获取首页数据 yyyy-MM-dd
    case getLiveReportingData(date: String, end: String)
    ///5获取繁忙时间
    case getBusyTimeList
    ///6获取配送时间
    case getTheTimeRange
    ///7设置时间范围
    case setRangeTime(type: String, maxTime: String, minTime: String)
    ///8设置繁忙时间
    case setBusyTime(busyID: String)
    ///9获取店铺的营业状态
    case getStoreOnlineStatus
    ///10上传语言
    case uploadLanguage
    ///11获取菜品
    case getDishesList
    ///12获取菜品的规格
    case getDishesOptionList(id: String)
    ///13设置菜品规格上下架
    case setSpecOnOffStatus(id: String)
    ///14设置菜品规格选项上下架
    case setOptionItemOnoffStatus(id: String)
    ///15获取菜品统计
    case getDishesReportingData(type: String, day: String, endDay: String)
    ///16上传推送Token
    case updateCloubMessageToken(token: String)
    ///17店铺营业状态
    case getStoreOpeningHours
    ///18设置营业时间
    case setStoreOpeningHours(starTime: String, endTime: String, type: String, timeID: String)
    ///19设置店铺每天的营业状态
    case setStoreOpenStatusByDay(timeID: String, coStatus: String, deStatus: String)
    ///20设置店铺总的营业状态
    case setStoreOpenStatus(coStatus: String, deStatus: String)
    ///21设置菜品上下架
    case setDishesOnOffStatus(dishes: [[String: String]], status: String)
    ///22获取店铺阶梯配送费列表和配送方式
    case getDeliveryFeeListAndType
    ///23添加店铺阶梯配送费
    case addDeliveryFee(amount: String, distance: String, postCode: String, type: String)
    ///24编辑店铺的配送费
    case editeDeliveryFee(amount: String, distance: String, postCode: String, id: String)
    ///25设置配送方式
    case setDeliveryType(type: String)
    ///26删除配送费
    case deleteDeliveryFee(id: String)
    ///27获取菜品分类列表
    case getMenuClassifyList
    ///28添加菜品分类
    case addMenuClassify(name_E: String, name_C: String, name_H: String)
    ///29编辑菜品分类
    case editeMenuClassify(id: String, name_E: String, name_C: String, name_H: String)
    ///30删除菜品分类
    case deleteMenuClassify(id: String)
    ///31获取菜品分类详情
    case getMenuClassifyDetail(id: String)
    ///32获取附加分类列表
    case getAttachClassifyList
    ///33添加附加分类
    case addAttachClassify(name_E: String, name_C: String, name_H: String)
    ///34获取附加分类详情
    case getAttachClassifyDetail(id: String)
    ///35删除附加分类
    case deleteAttachClassify(id: String)
    ///36编辑附加分类
    case editeAttachClassify(id: String, name_E: String, name_C: String, name_H: String)
    ///37获取赠品分类列表
    case getGiftClassifyList
    ///38添加赠品分类
    case addGiftClassify(name_E: String, name_C: String, name_H: String)
    ///39获取赠品分类详情
    case getGiftClassifyDetail(id: String)
    ///40删除附加分类
    case deleteGiftClassify(id: String)
    ///41编辑附加分类
    case editeGiftClassify(id: String, name_E: String, name_C: String, name_H: String)
    ///42获取分类下的菜品列表
    case getClassifyDishesList(id: String)
    ///43获取附加分类下的菜品列表
    case getClassifyAttachList(id: String)
    ///44获取赠品分类下的菜品列表
    case getClassifyGiftList(id: String)
    ///45获取菜品详情
    case getDishesDetail(id: String)
    ///46获取菜品的标签
    case getDishTags
    ///47编辑菜品
    case editeDish(model: DishDetailModel)
    ///48添加菜品
    case addDish(model: DishDetailModel)
    ///49删除菜品
    case deleteDish(id: String)
    ///50获取菜品规格详情
    case getDishSpecDetail(id: String)
    ///51编辑规格
    case editeSpec(model: DishDetailSpecModel)
    ///52添加规格
    case addSpec(model: DishDetailSpecModel)
    ///53删除规格
    case deleteSpec(id: String)
    ///54编辑规格选项
    case editeSpecOption(model: DishDetailOptionModel)
    ///55添加规格选项
    case addSpecOption(model: DishDetailOptionModel)
    ///56删除规格选项
    case deleteSpecOption(id: String)
    ///57获取附加菜品的详情
    case getAdditionalDetail(id: String)
    ///58编辑附加菜品
    case editeAdditional(model: AdditionalDetailModel)
    ///59添加附加菜品
    case addAdditional(model: AdditionalDetailModel)
    ///60删除附加菜品
    case deleteAdditional(id: String)
    ///61获取赠品的详情
    case getGiftDetail(id: String)
    ///62编辑赠品
    case editeGift(model: GiftDetailModel)
    ///63添加赠品
    case addGift(model: GiftDetailModel)
    ///64删除赠品
    case deleteGift(id: String)
    ///65获取店铺支付方式
    case getPaymentMethod
    ///66设置店铺支付方式
    case setPaymentMethod(card: String, cash: String)
    ///67设置菜品限购
    case setDishLimitBuy(dishId: String, limitType: String, limitNum: String)
    ///68获取实时订单数量
    case getOrderNum
    ///69菜品的周销量
    case getDishSales_Week(dishID: String, startDate: String, endDate: String, type: String)
    ///70菜品的月销量
    case getDishSales_Month(dishID: String, date: String, type: String)
    ///71设置菜品优惠
    case setDishedDiscount(id: String, type: String, price: String, startTime: String, endTime: String)
    ///72添加时间段
    case addOpeningHours(submitModel: AddTimeSubmitModel)
    ///73请求时间段关联菜品
    case getTimeBindingDishes(timeID: String)
    ///74保存时间段关联菜品
    case saveTimeBindingDishes(timeID: String, dishes: [[String: String]])
    ///75编辑时间段
    case editOpeningHours(submitModel: AddTimeSubmitModel)
    ///76删除时间段
    case deleteOpeningHours(timeID: String)
    ///77店铺营业时间禁用 启用
    case OpeningHoursCanUse(timeID: String)
    ///78增加或修改菜品的规格
    case specDoAddOrUpdate(model: DishDetailModel)
    ///79增加或修改套餐信息
    case comboDoAddOrUpdate(model: DishDetailModel)
    ///80获取消息列表
    case getMsgList(page: String, typeList: [String])
    ///81获取合并订单的订单列表
    case getMergeDetail(mergeID: String)
    ///82获取投诉列表
    case getComplainsList(page: String)
    ///83获取评论列表
    case getReviewsList(page: String)
    ///84获取投诉详情
    case getComplainsDetail(id: String)
    ///85处理投诉
    case doComplains(plaintId: String, handleType: String, refundMode: String, amount: String, refundFlow: String, plaintDishesList: [[String: String]])
    ///86回复评论
    case doEvaluateReply(id: String, content: String)
    ///87获取餐桌列表
    case getDeskList(page: String)
    ///88餐桌的启用禁用
    case setDeskStatus(id: String)
    ///89删除餐桌
    case deleteDesk(id: String)
    ///90添加餐桌
    case addDesk(name: String, remark: String, num: String)
    ///91编辑餐桌
    case editDesk(id: String, name: String, remark: String, num: String)
    ///92更新菜品价格
    case updateDishesPrice(id: String, sellType: String, buffetType: String, dePrice: String, dinePrice: String)
    ///93打印机列表
    case getPrinterList
    ///94新增打印机
    case addPrinter(model: PrinterModel)
    ///95编辑打印机
    case editePrinter(model: PrinterModel)
    ///96启用禁用打印机
    case printerDoStatus(id: String)
    ///97删除打印机
    case deletePrinter(id: String)
    ///98菜品添加买一赠一
    case doGiveOne(id: String)
    ///99设置菜品是否为点心套餐菜品
    case doBaleType(id: String)
    ///100获取店铺收入
    case getStoreInCost(dateType: String, start: String, end: String)
    ///101获取店铺支出
    case getStoreOutCost
    ///102设置是否为主打印机
    case doMainPrinter(id: String)
    ///103获取用户已预定列表
    case getUserBookingList(page: String, type: String)
    ///104添加预约
    case addBooking(model: AddBookingModel)
    ///105获取店铺预约时间
    case getStoreBookingTime(date: String)
    ///106取消预约
    case doCancelBooking(id: String)
    ///107处理预约
    case doConfirmBooking(id: String, type: String, deskID: String)
    ///108表格页面的预约数据
    case getBookingDataInCharts(date: String)
    ///109店铺是否可以预约 1否2是
    case getStoreBookingStatus
    ///110恢复取消或者拒绝的预定
    case doReconfirm(id: String)
    ///111用户预约进店
    case doBookingCheckin(id: String)
    ///112获取汇总打印信息
    case getPrintSummary(dateType: String, start: String, end: String)
    ///113获取营业额统计
    case getStoreSales(deliveryType: String, queryType: String)
    ///114获取分类统计列表
    case getStatisClassifyList
    ///115获取分类统计下菜的排名
    case getStatisClassifyDishesList(id: String, type: String, timePeriod: String, start: String, end: String)
    ///116获取打印机关联菜品
    case getPrinterDishesList(printerID: String)
    ///117设置打印机菜品
    case setPrinterLinkDishes(printerID: String, dishesArr: [Int64])
    ///118获取投诉处理方式
    case getDealComplaintWay
    ///119获取订单详情
    case getOrderDetail(orderID: String)
    ///120启用禁用菜品附加
    case setAttachStatus(id: String)
    ///121设置菜品VIP
    case doDishVipPrice(id: String, typeStr: String, price: String, status: String)
    ///122查询Uber的销售信息
    case getUberSummary(dateType: String, start: String, end: String)
    ///123获取节假日列表
    case getHolidayList
    ///124添加节假日
    case addHoliday(model: HolidayModel)
    ///125删除节假日
    case deleteHoliday(id: String)
    ///126编辑节假日
    case editHoliday(model: HolidayModel)
    ///127获取订单列表
    case getAllOrderList(startDate: String, endDate: String, source: String, userID: String, payType: String, status: String, timePeriod: String, page: String)
    ///128修改密碼
    case changePassword(new: String, old: String, reNew: String)
    ///129获取其他平台的菜品销量
    case getOtherDishesSummary(page: Int, searchType: String, start: String, end: String, ptType: String, timePeriod: String)
    ///130获取其他平台订单数据
    case getOtherOrderSummary(searchType: String, start: String, end: String, ptType: String, timePeriod: String)
    ///131获取店铺信息
    case getStoreInfo
    ///132设置店铺起送金额
    case setStoreMineOrderPrice(price: String)
    ///133設置數據查詢範圍
    case doStoreSalesScope(id: String)
    ///134获取客户列表
    case getCustomerList(page: Int, start: String, end: String, sortAsc: String, sortBy: String)
    ///135優惠列表
    case getCouponRuleList(isHistory: Bool, status: String, page: Int)
    ///136添加优惠券
    case addCoupon(model: CouponModel)
    ///137获取优惠券关联菜品
    case getCouponCanSelectDishesList
    ///138編輯優惠狀態
    case editCouponStatus(id: String, status: String)
    ///139獲取優惠詳情
    case getCouponDetail(id: String)
    ///140餐桌排序
    case deskDoSort(sortList: [[String: String]])
    ///141获取用户标签列表
    case getCustomerTagList
    ///142新增用户标签
    case addCustomerTag(status: String, nameEn: String, nameCn: String, nameHk: String)
    ///143编辑用户标签
    case editCustomerTag(id: String, status: String, nameEn: String, nameCn: String, nameHk: String)
    ///144删除用户标签
    case deleteCustomerTag(id: String)
    ///145用戶綁定標籤
    case userLinkTags(userID: String, tagList: [String])
    ///146獲取滿增列表 1启用，2禁用
    case getFullGiftList(name: String, price: String, status: String, page: String)
    ///147改變滿增狀態
    case changeFullGiftStatus(id: String, status: String)
    ///148刪除滿增
    case deleteFullGift(id: String)
    ///149添加滿增
    case addFullGift(name: String, price: String, dishList: [Int64], status: String)
    ///150編輯滿增
    case editFullGift(id: String, name: String, price: String, dishList: [Int64], status: String)
    ///151获取登录信息
    case getLogInInfo
    ///152获取销售端首页数据
    case salesGetHomePageTotal
    ///153獲取結算匯總列表 storeId不傳查所有
    case salesGetCommissionList(storeID: String, storeName: String, page: Int)
    ///154 获取结算详情列表
    case salesGetCommissionRecordListByStore(storeId: String, page: Int)
    ///155获取总结算列表
    case salesGetCommissionRecordSumList(page: Int)
    ///156获取结算汇总详情
    case salesGetCommissionSumDetail(bTime: String, eTime: String)
    ///157获取下级提成佣金
    case salesGetSubCommissionList(page: Int)
    
    
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
        case .getStatisClassifyDishesList(id: _, type: _, timePeriod: _, start: _, end: _):
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
        case .getOtherDishesSummary(page: _, searchType: _, start: _, end: _, ptType: _, timePeriod: _):
            return "api/boss/report/getOtherDishesSummary"
        case .getOtherOrderSummary(searchType: _, start: _, end: _, ptType: _, timePeriod: _):
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
        case .getFullGiftList(name: _, price: _, status: _, page: _):
            return "api/boss/orderFullGift/getList"
        case .changeFullGiftStatus(id: _, status: _):
            return "api/boss/orderFullGift/doStatus"
        case .deleteFullGift(id: _):
            return "api/boss/orderFullGift/doDelete"
        case .addFullGift(name: _, price: _, dishList: _, status: _):
            return "api/boss/orderFullGift/doAdd"
        case .editFullGift(id: _, name: _, price: _, dishList: _, status: _):
            return "api/boss/orderFullGift/doUpdate"
        case .getLogInInfo:
            return "api/boss/loginInfo"
        case .salesGetHomePageTotal:
            return "api/sales/commission/getHomePageTotal"
        case .salesGetCommissionList(storeID: _, storeName: _, page: _):
            return "api/sales/commission/storeCommissionList"
        case .salesGetCommissionRecordListByStore(storeId: _, page: _):
            return "api/sales/commission/storeCommissionRecordList"
        case .salesGetCommissionRecordSumList(page: _):
            return "api/sales/commission/commissionSumList"
        case .salesGetCommissionSumDetail(bTime: _, eTime: _):
            return "api/sales/commission/commissionSumDetail"
        case .salesGetSubCommissionList(page: _):
            return "api/sales/commission/subCommissionList"
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
            dic = ["date": date, "end": end, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getBusyTimeList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getTheTimeRange:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setRangeTime(let type, let maxTime, let minTime):
            dic = ["deliveryType": type, "maxTime": maxTime, "minTime": minTime, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setBusyTime(let busyID):
            dic = ["busyId": busyID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreOnlineStatus:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
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
            dic = ["day": day, "end": endDay, "searchType": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .updateCloubMessageToken(let token):
            dic = ["token": token]
            
        case .getStoreOpeningHours:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setStoreOpeningHours(let starTime, let endTime, let type, let timeID):
            dic = ["startTime": starTime, "endTime": endTime, "deliveryType": type, "openId": timeID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setStoreOpenStatusByDay(let timeID, let coStatus, let deStatus):
            dic = ["openId": timeID, "collectionStatus": coStatus, "deliveryStatus": deStatus, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setStoreOpenStatus(let coStatus, let deStatus):
            dic = ["collectionStatus": coStatus, "deliveryStatus": deStatus, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishesList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishesOptionList(let id):
            dic = ["dishesId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setDishesOnOffStatus(let dishes, let status):
            dic = ["dishesList" : dishes, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDeliveryFeeListAndType:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addDeliveryFee(let amount, let distance, let postCode, let type):
            dic = ["amount": amount, "distance": distance, "postCode": postCode, "feeType": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeDeliveryFee(let amount, let distance, let postCode, let id):
            dic = ["amount": amount, "distance": distance, "postCode": postCode, "feeId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteDeliveryFee(let id):
            dic = ["feeId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setDeliveryType(let type):
            dic = ["feeType": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setSpecOnOffStatus(let id):
            dic = ["specId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setOptionItemOnoffStatus(let id):
            dic = ["optionId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getMenuClassifyList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addMenuClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeMenuClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteMenuClassify(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getMenuClassifyDetail(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getAttachClassifyList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addAttachClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getAttachClassifyDetail(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeAttachClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteAttachClassify(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getGiftClassifyList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addGiftClassify(let name_E, let name_C, let name_H):
            dic = ["nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getGiftClassifyDetail(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeGiftClassify(let id, let name_E, let name_C, let name_H):
            dic = ["classifyId": id, "nameCn": name_C, "nameEn": name_E, "nameHk": name_H, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteGiftClassify(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getClassifyDishesList(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getClassifyAttachList(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getClassifyGiftList(let id):
            dic = ["classifyId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishesDetail(let id):
            dic = ["dishesId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishTags:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addDish(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .editeDish(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteDish(let id):
            dic = ["dishesId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishSpecDetail(let id):
            dic = ["specId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeSpec(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .addSpec(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteSpec(let id):
            dic = ["specId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeSpecOption(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .addSpecOption(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteSpecOption(let id):
            dic = ["optionId": id, "storeId": UserDefaults.standard.storeID ?? ""]
        case .getAdditionalDetail(let id):
            dic = ["attachId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeAdditional(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .addAdditional(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteAdditional(let id):
            dic = ["attachId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getGiftDetail(let id):
            dic = ["giftId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editeGift(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .addGift(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteGift(let id):
            dic = ["giftId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getPaymentMethod:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setPaymentMethod(let card, let cash):
            dic = ["card": card, "cash": cash, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setDishLimitBuy(let dishId, let limitType, let limitNum):
            dic = ["dishesId": dishId, "limitBuy": limitType, "limitNum": limitNum, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getOrderNum:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishSales_Week(let dishID, let startDate, let endDate, let type):
            dic = ["dishesId": dishID, "start": startDate, "end": endDate, "type": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDishSales_Month(let dishID, let date, let type):
            dic = ["dishesId": dishID, "date": date, "type": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setDishedDiscount(let id, let type, let price, let start, let end):
            dic = ["dishesId": id, "discountType": type, "discountPrice": price, "endTime": end, "startTime": start, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addOpeningHours(let submitModel):
            dic = submitModel.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .getTimeBindingDishes(let timeID):
            dic = ["storeTimeId": timeID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .saveTimeBindingDishes(let timeID, let dishes):
            dic = ["storeTimeId": timeID, "dishesList": dishes, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editOpeningHours(let submitModel):
            dic = submitModel.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteOpeningHours(let timeID):
            dic = ["storeTimeId": timeID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .OpeningHoursCanUse(let timeID):
            dic = ["storeTimeId": timeID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .specDoAddOrUpdate(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .comboDoAddOrUpdate(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .getMsgList(let page, let typeList):
            dic = ["pageIndex": page, "operateTypeList": typeList, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getMergeDetail(let mergeID):
            dic = ["mergeId": mergeID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getReviewsList(let page):
            dic = ["pageIndex": page, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getComplainsList(let page):
            dic = ["pageIndex": page, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getComplainsDetail(let id):
            dic = ["plaintId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doComplains(let plaintId, let handleType, let refundMode, let amount, let refundFlow, let plaintDishesList):
            dic = ["plaintId": plaintId, "handleType": handleType, "refundMode": refundMode, "amount": amount, "refundFlow": refundFlow, "plaintDishesList": plaintDishesList, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doEvaluateReply(let id, let content):
            dic = ["evaluateId": id, "replyContent": content, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDeskList(let page):
            dic = ["pageIndex": page, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setDeskStatus(let id):
            dic = ["deskId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteDesk(let id):
            dic = ["deskId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editDesk(let id, let name, let remark, let num):
            dic = ["deskId": id, "deskName": name, "remark": remark, "dinersNum": num, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addDesk(let name, let remark, let num):
            dic = ["deskName": name, "remark": remark, "dinersNum": num, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .updateDishesPrice(let id, let sellType, let buffetType, let dePrice, let dinePrice):
            dic = ["dishesId": id, "sellType": sellType, "buffetType": buffetType, "deliPrice": dePrice, "dinePrice": dinePrice, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getPrinterList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addPrinter(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .editePrinter(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .printerDoStatus(let id):
            dic = ["printerId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deletePrinter(let id):
            dic = ["printerId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doGiveOne(let id):
            dic = ["dishesId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doBaleType(let id):
            dic = ["dishesId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreInCost(let dateType, let start, let end):
            dic = ["type": dateType, "start": start, "end": end, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreOutCost:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doMainPrinter(let id):
            dic = ["printerId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getUserBookingList(let page, let type):
            dic = ["pageIndex": page, "reserveStatus": type, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addBooking(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .getStoreBookingTime(let date):
            dic = ["date": date, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doCancelBooking(let id):
            dic = ["userReserveId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doConfirmBooking(let id, let type, let deskID):
            dic = ["userReserveId": id, "reserveType": type, "deskId": deskID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getBookingDataInCharts(let date):
            dic = ["date": date, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreBookingStatus:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doReconfirm(let id):
            dic = ["userReserveId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doBookingCheckin(let id):
            dic = ["userReserveId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getPrintSummary(let dateType, let start, let end):
            dic = ["type": dateType, "start": start, "end": end, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreSales(let deliveryType, let queryType):
            dic = ["deliveryType": deliveryType, "queryType": queryType, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStatisClassifyList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStatisClassifyDishesList(let id, let type, let timePeriod, let start, let end):
            dic = ["classifyId": id, "searchType": type, "timePeriod": timePeriod, "day": start, "end": end, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setPrinterLinkDishes(let printerID, let dishesArr):
            dic = ["printerId": printerID, "dishesList": dishesArr, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getPrinterDishesList(let printerID):
            dic = ["printerId": printerID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getDealComplaintWay:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getOrderDetail(let orderID):
            dic = ["orderId": orderID, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setAttachStatus(let id):
            dic = ["attachId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doDishVipPrice(let id, let typeStr, let price, let status):
            dic = ["dishesId": id, "vipDeliveryStr": typeStr, "vipPrice": price, "vipType": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getUberSummary(let dateType, let start, let end):
            dic = ["queryType": dateType, "start": start, "end": end, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getHolidayList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addHoliday(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .deleteHoliday(let id):
            dic = ["id": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editHoliday(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .getAllOrderList(let start, let end, let source, let userID,  let payType, let status, let timePeriod, let page):
            dic = ["startDate": start, "endDate": end, "source": source, "userId": userID, "pageIndex": page, "payType": payType, "timePeriod": timePeriod, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .changePassword(let new, let old, let reNew):
            dic = ["newPassword": new, "oldPassword": old, "verifyPassword": reNew]
            
        case .getOtherDishesSummary(let page, let searchType, let start, let end, let ptType, let timePeriod):
            dic = ["pageIndex": page, "searchSource": ptType, "searchType": searchType, "day": start, "end": end, "timePeriod": timePeriod, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getOtherOrderSummary(let searchType, let start, let end, let ptType, let timePeriod):
            dic = ["searchSource": ptType, "searchType": searchType, "day": start, "end": end, "timePeriod": timePeriod, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getStoreInfo:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .setStoreMineOrderPrice(let price):
            dic = ["minOrderPrice": price, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .doStoreSalesScope(let id):
            dic = ["id": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getCustomerList(let page, let start, let end, let sortAsc, let sortBy):
            dic = ["pageIndex": page, "startDate": start, "endDate": end, "sortAsc": sortAsc, "sortBy": sortBy, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getCouponRuleList(let isHistory, let status, let page):
            dic = ["history": isHistory, "status": status, "pageIndex": page, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addCoupon(let model):
            dic = model.toJSON() ?? [:]
            dic["storeId"] = UserDefaults.standard.storeID ?? ""
            
        case .getCouponCanSelectDishesList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editCouponStatus(let id, let status):
            dic = ["id": id, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getCouponDetail(let id):
            dic = ["id": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deskDoSort(let sortList):
            dic = ["deskSortList": sortList, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addCustomerTag(let status, let nameEn, let nameCn, let nameHk):
            dic = ["status": status, "nameCn": nameCn, "nameEn": nameEn, "nameHk": nameHk, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getCustomerTagList:
            dic = ["storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editCustomerTag(let id, let status, let nameEn, let nameCn, let nameHk):
            dic = ["status": status, "nameCn": nameCn, "nameEn": nameEn, "nameHk": nameHk, "tagId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteCustomerTag(let id):
            dic = ["tagId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .userLinkTags(let userID, let tagList):
            dic = ["userId": userID, "tagIdList": tagList, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getFullGiftList(let name, let price, let status, let page):
            dic = ["pageIndex": page, "name": name, "price": price, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .changeFullGiftStatus(let id, let status):
            dic = ["giftId": id, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .deleteFullGift(let id):
            dic = ["giftId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .addFullGift(let name, let price, let dishList, let status):
            dic = ["nameCn": name, "nameEn": name, "nameHk": name, "price": price, "dishesIdList": dishList, "status": status, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .editFullGift(let id, let name, let price , let dishList, let status):
            dic = ["nameCn": name, "nameEn": name, "nameHk": name, "price": price, "dishesIdList": dishList, "status": status, "giftId": id, "storeId": UserDefaults.standard.storeID ?? ""]
            
        case .getLogInInfo:
            dic = [:]
            
        case .salesGetHomePageTotal:
            dic = [:]
            
        case .salesGetCommissionList(let storeID, let storeName, let page):
            dic = ["storeId": storeID, "pageIndex": page, "storeName": storeName]
            
        case .salesGetCommissionRecordListByStore(let storeId, let page):
            dic = ["storeId": storeId, "pageIndex": page]
            
        case .salesGetCommissionRecordSumList(let page):
            dic = ["pageIndex": page]
            
        case .salesGetCommissionSumDetail(let bTime, let eTime):
            dic = ["beginTime": bTime, "endTime": eTime]
            
        case .salesGetSubCommissionList(let page):
            dic = ["pageIndex": page]
            
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

