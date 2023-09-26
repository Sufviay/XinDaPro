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
    
    ///测试
    case apiTest
    
    ///登录
    case loginAciton(id: String)
    ///用户首是否绑定过店铺
    case bindingStoreOrNot
    ///绑定店铺
    case bindingStroreAction(storeID: String)
//    ///获取首页绑定的店铺
//    case SY_BindingStoreList(lat: String, lng: String)
//    ///获取首页热门店铺
//    case SY_hotStoreList(lat: String, lng: String)
//    ///获取首页距离最近的店铺
//    case SY_NearByStoreList(lat: String, lng: String)
    ///获取店铺首页数据
    case Store_mainPageData(storeID: String, type: String)
    ///获取店铺标签（用于店铺筛选）
    case getStoreFiltrateTags
    ///店铺菜品分类
    case getDishesClassify(storeID: String)
    ///分类下的菜品
    case getClassifyDishes(classifyID: String, storeID: String, keyword: String)
    ///添加购物车
    case addShoppingCart(dishesID: String, buyNum: String, type: String, optionList: [[String: String]], deskID: String)
    ///修改购物车数量
    case updateCartNum(buyNum: String, cartID: String)
    ///获取已添加购物车的菜品列表
    case getAddedCartDishes(storeID: String, psType: String)
    ///获取菜品详情
    case loadDishedDetail(dishesId: String, deskId: String)
    ///店铺列表——绑定
    case storeList_binding(tag: String, lat: String, lng: String, page: String)
    ///店铺列表——热门
    case storeList_hot(tag: String, lat: String, lng: String, page: String)
    ///店铺列表——距离最近
    case storeList_nearby(tag: String, lat: String, lng: String, page: String, allStore: String)
    ///搜索店铺
    case searchStoreList(keyword: String, lat: String, lng: String, page: String)
    ///确认订单详情
    case loadConfirmOrderDetail(lat: String, lng: String, buyWay: String, storeID: String, couponID: String, postCode: String)
    ///可选择的时间列表 1：外卖    2：自取
    case canChooseTimeList(storeID: String, type: String)
    ///可选择时间列表有预定  1：外卖    2：自取
    case canChooseTimeList_YD(storeID: String, type: String)
    
    
    ///获取地址列表
    case getAddressList(storeID: String, type: String, page: String)
    ///添加 、修改收货地址
    case editeAddress(address: String, lat: String, lng: String, phone: String, postCode: String, receiver: String, id: String, detail: String, defaultOrNot: String)
    ///删除地址
    case deleteAddress(id: String)
    ///创建订单
    case creatOrder(submitModel: CreateOrderModel)
    ///订单支付
    case orderpay(orderID: String, payType: String)
    ///请求订单列表
    case getOrderList(page: String)
    ///订单详情
    case getOrderDetail(orderID: String)
    ///取消订单
    case orderCancel(orderID: String)
    ///获取评论列表
    case getReviewsList(storeID: String, page: String)
    ///确认订单收货
    case orderConfirm(orderID: String)
    ///订单评价
    case orderEvaluate(content: String, orderID: String, psStar: String, cpStar: String, fwStar: String, nickName: String)
    ///订单投诉
    case orderComplaint(content: String, orderID: String, photo: [[String: String]])
    ///查询配送员当前位置
    case getCurrentLocation(orderID: String)
    ///订单支付中
    case orderPaying(orderID: String)
    ///上传推送Token
    case updateCloubMessageToken(token: String)
    ///获取钱包金额
    case getWalletAmout
    ///获取钱包金额明细
    case getWalletDeail(page: String)
    
    ///获取钱包金额并计算订单支付金额
    case getWalletAndOrderAmount(orderID: String)
    ///获取下单页面的预送达时间
    case getCalOrderTime(type: String, storeID: String, time: String)
    ///帮助
    case getHelpList
    ///获取帮助详情
    case getHelpDetail(id: String)
    ///上传语言
    case uploadLanguage
    ///再来一单
    case orderAgain(orderID: String)
    ///获取投诉订单菜品和投诉原因
    case getPlaintOrderDishAndReason(orderID: String)
    ///投诉菜品
    case complaintsDishes(other: String, orderID: String, reasonID: String, imageurl: [[String: String]], dishes: [[String: Any]], hopeID: String)
    ///登出
    case logout
    ///检查App版本
    case CheckAppVer
    ///获取分类及菜品列表
    case getClassifyAndDishesList(storeID: String, deskId: String)
    ///清空购物车
    case emptyCart(storeID: String)
    ///账户删除
    case deleteAccountApply
    ///提建议
    case doSuggest(name: String, phone: String, suggest: String)
    ///建议列表
    case getSuggestList(page: String)
    ///是否有未读消息
    case isHaveMessage
    ///获取消息列表
    case getMessageList(page: String)
    ///消息已读
    case doReadMessage(id: String)
    ///支付取消
    case payCancel(orderID: String)
    ///删除购物车商品
    case deleteCartGoods(id: String)
    ///更新订单状态
    case refreshOrderStatus(id: String)
    ///更新用户信息
    case updateUserInfo(name: String, email: String, birthday: String)
    ///获取用户信息
    case getUserInfo
    ///获取我的优惠券列表
    case getMyCouponList
    ///获取可用优惠券
    case getAvaliableCouponList(dishesPrice: String, storeID: String)
    ///返回奖品的编码
    case getPrizeList
    ///返回中奖的奖品
    case doPrizeDraw(orderID: String)
    ///获取订单是否存在未抽奖
    case isHaveDrawPrize
    
    ///获取店铺列表是否是首单用户
    case getStoreListFirstDiscount
    ///获取店铺详情是否是首单优惠
    case getStoreDetailFirstDiscount(storeID: String)
    ///获取积分明细列表
    case getJiFenDetailList(page: String, type: String)
    ///积分兑换列表
    case getJiFenExchangeList(storeID: String)
    ///积分兑换
    case jiFenExchange(exID: String)
    ///获取积分和过期积分
    case getJiFenCount
    ///验证店铺桌号
    case checkDesk(storeID: String, deskID: String)
    
    
    





    
    
    
    
    
    

    //MARK: ------------------ 首页 -----------------------
    ///首页数据
    case getFirstPageData(lat: String, lng: String)
    ///获取店铺列表
    case getStoreList(keywords: String, type: String, tag: String, lat: String, lng: String, page: String)

    ///店铺分类及菜品
    case getStoreMenu(id: String)
    ///修改菜品或是规格的购买数量
    case editeDishSpectification(cartDishID: String, classiftyID: String, dishID: String, count: String, storeID: String, selectArr: [[String: String]])
    ///查询当前购物车的菜品明细 配送方式(1、外送 2、自取)
    case checkCartData(couponid: String, way: String, storeID: String)
    ///店铺详情
    case storeInfo(storeID: String)
    
    


    
    

    

    

}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        
        return URL(string: V2URL)!

    }
    
    
    var path: String {
        switch self {
            
        case .apiTest:
            return "api/user/test"
        case .loginAciton(id: _):
            return "api/user/login"
        case .bindingStoreOrNot:
            return "api/user/getUserBindStoreId"
        case .bindingStroreAction(storeID: _):
            return "api/user/bindStore"
            
//        case .SY_BindingStoreList(lat: _, lng: _):
//            return "api/user/home/getBindStoreList"
//        case .SY_hotStoreList(lat: _, lng: _):
//            return "api/user/home/getHotStoreList"
//        case .SY_NearByStoreList(lat: _, lng: _):
//            return "api/user/home/getNearStoreList"
        case .Store_mainPageData(storeID: _, type: _):
            return "api/user/store/getStoreDetail"
        case .getStoreFiltrateTags:
            return "api/user/store/getTagList"
        case .getDishesClassify(storeID: _):
            return "api/user/dishes/getClassifyList"
        case .getClassifyDishes(classifyID: _, storeID: _, keyword: _):
            return "api/user/dishes/getDishesList"
        case .getAddedCartDishes(storeID: _, psType: _):
            return "api/user/cart/getAddedCartDishesList"
        case .addShoppingCart(dishesID: _, buyNum: _, type: _, optionList: _, deskID: _):
            return "api/user/cart/addCart"
        case .loadDishedDetail(dishesId: _, deskId: _):
            return "api/user/dishes/getDishesDetail"
        case .storeList_binding(tag: _, lat: _, lng: _, page: _):
            return "api/user/store/getBindStoreList"
        case .storeList_hot(tag: _, lat: _, lng: _, page: _):
            return "api/user/store/getHotStoreList"
        case .storeList_nearby(tag: _, lat: _, lng: _, page: _, allStore: _):
            return "api/user/store/getNearStoreList"
        case .updateCartNum(buyNum: _, cartID: _):
            return "api/user/cart/updateBuyNum"
        case .loadConfirmOrderDetail(lat: _, lng: _, buyWay: _, storeID: _, couponID: _, postCode: _):
            return "api/user/order/calOrder"
        case .searchStoreList(keyword: _, lat: _, lng: _, page: _):
            return "api/user/store/getSearchStoreList"
        case .canChooseTimeList(storeID: _, type: _):
            return "api/user/order/getOrderDeliveryTimeList"
        case .canChooseTimeList_YD(storeID: _, type: _):
            return "api/user/order/getOrderDeliveryTimeListForReserve"
        case .getAddressList(storeID: _, type: _, page: _):
            return "api/user/address/getAddressList"
        case .editeAddress(address: _, lat: _, lng: _, phone: _, postCode: _, receiver: _, id: _, detail: _, defaultOrNot: _):
            return "api/user/address/saveOrUpdateAddress"
        case .deleteAddress(id: _):
            return "api/user/address/deleteAddress"
        case .creatOrder(submitModel: _):
            return "api/user/order/createOrder"
        case .orderpay(orderID: _, payType: _):
            return "api/user/order/pay"
        case .getOrderList(page: _):
            return "api/user/order/getOrderList"
        case .getOrderDetail(orderID: _):
            return "api/user/order/getOrderDetail"
        case .orderCancel(orderID: _):
            return "api/user/order/cancel/doCancelOrder"
        case .getReviewsList(storeID: _, page: _):
            return "api/user/order/evaluate/getEvaluateList"
        case .orderConfirm(orderID: _):
            return "api/user/order/receive/doReceiveOrder"
        case .orderEvaluate(content: _, orderID: _, psStar: _, cpStar: _, fwStar: _, nickName: _):
            return "api/user/order/evaluate/doEvaluateOrder"
        case .orderComplaint(content: _, orderID: _, photo: _):
            return "api/user/order/plaint/doPlanitOrder"
        case .getCurrentLocation(orderID: _):
            return "api/user/rider/getRiderPosition"
        case .orderPaying(orderID: _):
            return "api/user/order/paying"
        case .updateCloubMessageToken(token: _):
            return "api/user/doPushToken"
        case .getWalletAmout:
            return "api/user/getWalletAmount"
        case .getWalletDeail(page: _):
            return "api/user/getWalletDetail"
        case .getWalletAndOrderAmount(orderID: _):
            return "api/user/order/getWalletAndOrderAmount"
        case .getCalOrderTime(type: _, storeID: _, time: _):
            return "api/user/order/getCalOrderTime"
        case .getHelpList:
            return "api/user/help/getHelpList"
        case .getHelpDetail(id: _):
            return "api/user/help/getHelpDetail"
        case .uploadLanguage:
            return "api/user/lang/doSetUpLang"
        case .orderAgain(orderID: _):
            return "api/user/order/createOrderAgain"
        case .getPlaintOrderDishAndReason(orderID: _):
            return "api/user/order/plaint/getOrderDishesAndPlaintReason"
        case .complaintsDishes(other: _, orderID: _, reasonID: _, imageurl: _, dishes: _, hopeID: _):
            return "api/user/order/plaint/doPlanitOrder"
        case .logout:
            return "api/user/logout"
        case .CheckAppVer:
            return "api/user/version/checkVersion"
        case .getClassifyAndDishesList(storeID: _, deskId: _):
            return "api/user/dishes/getDishesClassifyList"
        case .emptyCart(storeID: _):
            return "api/user/cart/doClearCart"
        case .deleteAccountApply:
            return "api/user/cancelApply"
        case .doSuggest(name: _, phone: _, suggest: _):
            return "api/user/suggest/doSuggest"
        case .getSuggestList(page: _):
            return "api/user/suggest/getSuggestList"
        case .isHaveMessage:
            return "api/user/message/getReadStatus"
        case .getMessageList(page: _):
            return "api/user/message/getMessageList"
        case .doReadMessage(id: _):
            return "api/user/message/doRead"
        case .payCancel(orderID: _):
            return "api/user/order/doCancelPay"
        case .deleteCartGoods(id: _):
            return "api/user/cart/delDishes"
        case .refreshOrderStatus(id: _):
            return "api/user/order/getOrderStatus"
        case .updateUserInfo(name: _, email: _, birthday: _):
            return "api/user/update"
        case .getUserInfo:
            return "api/user/getUserInfo"
        case .getMyCouponList:
            return "api/user/coupon/getMyCouponList"
        case .getAvaliableCouponList(dishesPrice: _, storeID: _):
            return "api/user/coupon/getAvailableCouponList"
        case .getPrizeList:
            return "api/user/prize/getPrizeList"
        case .doPrizeDraw(orderID: _):
            return "api/user/prize/doPrizeDraw"
        case .isHaveDrawPrize:
            return "api/user/home/getHaveDrawPrize"
        case .getStoreListFirstDiscount:
            return "api/user/getStoreListUserFirstDiscount"
        case .getStoreDetailFirstDiscount(storeID: _):
            return "api/user/getStoreDetailUserFirstDiscount"
        case .getJiFenDetailList(page: _, type: _):
            return "api/user/points/getUserPointsDetailList"
        case .getJiFenExchangeList(storeID: _):
            return "api/user/points/getPointsExchangeList"
        case .jiFenExchange(exID: _):
            return "api/user/points/doPointsExchange"
        case .getJiFenCount:
            return "api/user/points/getUserPoints"
        case .checkDesk(storeID: _, deskID: _):
            return "api/user/desk/checkDesk"
            
            
            
            
            
            

            
            
            
      
            
            
            
            
            
            
        case .getFirstPageData(lat: _, lng: _):
            return "app/store/mainPage"
        case .getStoreList(keywords: _, type: _, tag: _, lat: _, lng: _, page: _):
            return "app/store/list"
        case .getStoreMenu(id: _):
            return "app/Goods/getStoreGoodsIndex"
        case .editeDishSpectification(cartDishID: _, classiftyID: _, dishID: _, count: _, storeID: _, selectArr: _):
            return "app/Cart/modifyUserCart"
        case .checkCartData(couponid: _, way: _, storeID: _):
            return "app/Cart/selectCart"
        case .storeInfo(storeID: _):
            return "app/store/detail"
            

            
            

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
            
        case .apiTest:
            dic = ["uid": "9999999999"]
        case .loginAciton(let id):
            dic = ["token": id]
        case .bindingStoreOrNot:
            dic = [:]
        case .bindingStroreAction(let storeID):
            dic = ["storeId": storeID]
//        case .SY_BindingStoreList(let lat, let lng):
//            dic = ["lat": lat, "lng": lng]
//        case .SY_hotStoreList(let lat, let lng):
//            dic = ["lat": lat, "lng": lng]
//        case .SY_NearByStoreList(let lat, let lng):
//            dic = ["lat": lat, "lng": lng]
        case .Store_mainPageData(let storeID, let type):
            dic = ["storeId": storeID, "type": type]
        case .getStoreFiltrateTags:
            dic = [:]
        case .getDishesClassify(let storeID):
            dic = ["storeId": storeID]
        case .getClassifyDishes(let classifyID, let storeID, let keyword):
            dic = ["classifyId": classifyID, "storeId": storeID, "keyword": keyword]
        case .addShoppingCart(let dishesID, let buyNum, let type, let optionList, let deskID):
            dic = ["buyNum": buyNum, "dishesId": dishesID, "type": type, "optionList": optionList, "deskId": deskID]
        case .getAddedCartDishes(let storeID, let psType):
            dic = ["storeId": storeID, "deliveryType": psType]
        case .loadDishedDetail(let dishesId, let deskId):
            dic = ["dishesId": dishesId, "deskId": deskId]
        case .storeList_binding(let tag, let lat, let lng, let page):
            dic = ["lat": lat, "lng": lng, "pageIndex": page, "tagId": tag]
        case .storeList_hot(let tag, let lat, let lng, let page):
            dic = ["lat": lat, "lng": lng, "pageIndex": page, "tagId": tag]
            
        case .storeList_nearby(let tag, let lat, let lng, let page, let allStore):
            ///env = 2  是生产环境下的测试
            dic = ["lat": lat, "lng": lng, "pageIndex": page, "tagId": tag, "allStore": allStore, "env": ENV]
        case .updateCartNum(let buyNum, let cartID):
            dic = ["buyNum": buyNum, "carId": cartID]
        case .loadConfirmOrderDetail(let lat, let lng, let buyWay, let storeID, let couponID, let postCode):
            dic = ["deliveryType": buyWay, "lat": lat, "lng": lng, "storeId": storeID, "couponId": couponID, "postcode": postCode]
        case .searchStoreList(let keyword, let lat, let lng, let page):
            dic = ["keyword": keyword, "lat": lat, "lng": lng, "pageIndex": page, "env": ""]
        case .canChooseTimeList(let storeID, let type):
            dic = ["storeId": storeID, "deliveryType": type]
        case .canChooseTimeList_YD(let storeID, let type):
            dic = ["storeId": storeID, "deliveryType": type]
        case .getAddressList(let storeID, let type, let page):
            dic = ["storeId": storeID, "listType": type, "pageIndex": page]
        case .editeAddress(let address, let lat, let lng, let phone, let postCode, let receiver, let id, let detail, let defaultOrNot):
            dic = ["address": address, "addressId": id, "detail": detail, "lat": lat, "lng": lng, "phone": phone, "postcode": postCode, "name": receiver, "defaultAddr": defaultOrNot]
        case .deleteAddress(let id):
            dic = ["addressId": id]
        case .creatOrder(let submitModel):
            dic = ["couponId": submitModel.couponId, "deliveryType": submitModel.type, "payType": submitModel.paymentMethod, "remark": submitModel.remark, "storeId": submitModel.storeId, "orderAddress": ["address": submitModel.recipientAddress, "name": submitModel.recipient, "phone": submitModel.recipientPhone, "takeTime": submitModel.hopeTime, "lat": submitModel.recipientLat, "lng": submitModel.recipientLng, "postCode": submitModel.recipientPostcode], "deskId": submitModel.deskId]
        case .orderpay(let orderID, let payType):
            dic = ["orderId": orderID, "payType": payType]
        case .getOrderList(let page):
            dic = ["pageIndex": page]
        case .getOrderDetail(let orderID):
            dic = ["orderId": orderID]
        case .orderCancel(let orderID):
            dic = ["orderId": orderID]
        case .getReviewsList(let storeID, let page):
            dic = ["storeId": storeID, "pageIndex": page]
        case .orderConfirm(let orderID):
            dic = ["orderId": orderID]
        case .orderEvaluate(let content, let orderID, let psStar, let cpStar, let fwStar, let nickName):
            dic = ["content": content, "orderId": orderID, "deliveryNum": psStar, "dishesNum": cpStar, "serviceNum": fwStar, "nickName": nickName]
        case .orderComplaint(let content, let orderID, let photo):
            dic = ["content": content, "orderId": orderID, "imageList": photo]
        case .orderPaying(let orderID):
            dic = ["orderId": orderID]
        case .getCurrentLocation(let orderID):
            dic = ["orderId": orderID]
        case .updateCloubMessageToken(let token):
            dic = ["token": token]
        case .getWalletAmout:
            dic = [:]
        case .getWalletDeail(let page):
            dic = ["pageIndex": page]
        case .getWalletAndOrderAmount(let orderID):
            dic = ["orderId": orderID]
        case .getCalOrderTime(let type, let storeID, let time):
            dic = ["deliveryType": type, "storeId": storeID, "takeTime": time]
        case .getHelpList:
            dic = [:]
        case .getHelpDetail(let id):
            dic = ["helpId": id]
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
        case .orderAgain(let orderID):
            dic = ["orderId": orderID]
        case .getPlaintOrderDishAndReason(let orderID):
            dic = ["orderId": orderID]
        case .complaintsDishes(let other, let orderID, let reasonID, let imageurl, let dishes, let hopeID):
            dic = ["otherReason": other, "dishesList": dishes, "imageList": imageurl, "orderId": orderID, "plaintReasonId": reasonID, "userHope": hopeID]
        case .logout:
            dic = [:]
        case .CheckAppVer:
            dic = ["sysType": "2", "verId": UserDefaults.standard.verID!]
        case .getClassifyAndDishesList(let storeID, let deskId):
            dic = ["storeId": storeID, "deskId": deskId]
        case .emptyCart(let storeID):
            dic = ["storeId": storeID]
        case .deleteAccountApply:
            dic = [:]
        case .doSuggest(let name, let phone, let suggest):
            dic = ["content": suggest, "name": name, "phone": phone]
        case .getSuggestList(let page):
            dic = ["pageIndex": page]
        case .isHaveMessage:
            dic = [:]
        case .doReadMessage(let id):
            dic = ["messageUserId": id]
        case .getMessageList(let page):
            dic = ["pageIndex": page]
        case .payCancel(let orderID):
            dic = ["orderId": orderID]
        case .deleteCartGoods(let id):
            dic = ["carId": id]
        case .refreshOrderStatus(let id):
            dic = ["orderId": id]
        case .updateUserInfo(let name, let email, let birthday):
            dic = ["name": name, "email": email, "birthday": birthday]
        case .getUserInfo:
            dic = [:]
        case .getMyCouponList:
            dic = [:]
        case .getAvaliableCouponList(let dishesPrice, let storeID):
            dic = ["dishesPrice": dishesPrice, "storeId": storeID]
        case .doPrizeDraw(let orderID):
            dic = ["orderId": orderID]
        case  .getPrizeList:
            dic = [:]
        case .isHaveDrawPrize:
            dic = [:]
        case .getStoreListFirstDiscount:
            dic = [:]
        case  .getStoreDetailFirstDiscount(let storeID):
            dic = ["storeId": storeID]
        case .getJiFenDetailList(let page, let type):
            dic = ["pageIndex": page, "type": type]
        case .getJiFenExchangeList(let storeID):
            dic = ["storeId": storeID]
        case .jiFenExchange(let exID):
            dic = ["pointsCouponId": exID]
        case .getJiFenCount:
            dic = [:]
        case .checkDesk(let storeID, let deskID):
            dic = ["deskId": deskID, "storeId": storeID]

            

            
            
            
            
            
            
            

            
            

            
            
        case .getFirstPageData(let lat, let lng):
            dic = ["lat": lat, "lng": lng]
        case .getStoreList(let keywords, let type, let tag, let lat, let lng, let page):
            dic = ["keyWords": keywords, "lat": lat, "lng": lng, "orderType": type, "page": page, "limit": "10", "tags": tag]
        case .getStoreMenu(let id):
            dic = ["storeId": id]
        case .editeDishSpectification(let cartDishID, let classiftyID, let dishID, let count, let storeID, let selectArr):
            dic = ["cartDishesId": cartDishID, "classificationId": classiftyID, "dishId": dishID, "count": count, "storeId": storeID, "specification": selectArr]

        case .checkCartData(let couponid, let way, let storeID):
            dic = ["couponId": couponid, "isDelivery": way, "storeId": storeID]
        case .storeInfo(let storeID):
            dic = ["storeId": storeID]
            
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
        
        //操作系统版本
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
                       "token-user": token,
                       "token": token,
                       "verId": UserDefaults.standard.verID ?? "0",
                       "verCode": "v\(curAppVer)",
                       "sysType": "02",
                       "sysModel": systemtype,
                       "sysVer": systemVer,
                       "lang": curLanguage,
                       "deviceId": deviceID,
                       "deviceType": "apple",
                       "sysLang": Locale.preferredLanguages.first ?? ""
                        ]
        print(baseDic)
        
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
    
    case errorCode10
    
} 

class ErrorTool {
    
    static func errorMessage(_ m_error: Error) -> String {
        switch m_error as! NetworkError {
        case .unkonw:
            return ERROR_Message
        case .errorCode10:
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

