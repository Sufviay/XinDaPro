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
import MessageUI


let requestTimeOut = { (endpoint: Endpoint, done: @escaping MoyaProvider<ApiManager>.RequestResultClosure) in
    
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 20
        done(.success(request))
    } catch {
        print("超时了")
    }
    
}

class HttpTool: NSObject, SystemAlertProtocol, CommonToolProtocol {
    
    static let shared = HttpTool()
    private override init() {}
    
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
                        
                        print(json)
                        
                        if api.path != "api/user/help/getHelpDetail" && api.path != "api/user/message/getMessageList" {
                            //获取数据字典
                            guard let dic = json.dictionaryObject else {

                                print("+++++++++++++++++出错了")

                                return
                            }
                            //字典转json字符串
                            let jsonStr = PJCUtil.convertDictionaryToString(dict: dic)
                            //统一处理转义符号
                        
                            let deJsonStr = String(htmlEncodedString: jsonStr)
                        

                            if deJsonStr == nil {
                                print("+++++++++++++++++出错了")
                                return
                            }
//                            jsonStr = PJCUtil.dealHtmlZhuanYiString(contentStr: jsonStr)

                            //根据处理转义符号后的jsonString生成JSON
                            
                            
                            
                            guard let data = deJsonStr!.data(using: .utf8) else {
                                print("+++++++++++++++++出错了")
                                return
                            }

                            json = JSON(data)
                            
                        }
                        
                        if json["code"].stringValue == "1"  {
                            observer.onNext(json)
//                            observer.onCompleted()
                        } else if (json["code"].stringValue == "-1" || json["code"].stringValue == "-3" || json["code"].stringValue == "-4" || json["code"].stringValue == "-5" || json["code"].stringValue == "-6") || json["code"].stringValue == "-2" {
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.unkonw)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                PJCUtil.logOut()
                            }
                        } else if json["code"].stringValue == "6" {
                            //账户删除审核中
                            observer.onCompleted()
                            self.showSystemChooseAlert("WARNING", "Your account deletion application is under review, so you cannot log in to the application. If you have any questions, please contact customer service", "Email", "Cancel") {
                                //发邮件
                                self.sendEmail(title: "Delete the account", email: SERVICE_Email)
                            }
                        } else if json["code"].stringValue == "5" || json["code"].stringValue == "7" || json["code"].stringValue == "8" {
                            ///不支持外卖或自取
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pageRefresh"), object: nil)
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.unkonw)
                            DispatchQueue.main.after(time: .now() + 1.5) {
                                PJCUtil.currentVC()?.navigationController?.popViewController(animated: true)
                            }
                            
                        } else if json["code"].stringValue == "10" {
                            ///优惠券无法使用
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.errorCode10)
                        }
                        else if json["code"].stringValue == "11" {
                            ///手机号不存在
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.errorCode11)
                        }
                        else if json["code"].stringValue == "12" {
                            ///未设置密码
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.errorCode12)
                        }
                        else {
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
        
    
    
    //MARK: - 测试
    func apiTest() -> Observable<JSON> {
        let response = rxApiManager(api: .apiTest)
        return Observable<JSON>.create(response)
    }
    

    //MARK: - 登录
    func userLogIn(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginAciton(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 是否绑定过店铺
    func userBindingOrNot() -> Observable<JSON> {
        let response = rxApiManager(api: .bindingStoreOrNot)
        return Observable<JSON>.create(response)
    }

    //MARK: - 绑定店铺
    func bindingStore(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .bindingStroreAction(storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
//    //MARK: - 首页绑定店铺
//    func SY_BindingStore(lat: String, lng: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .SY_BindingStoreList(lat: lat, lng: lng))
//        return Observable<JSON>.create(response)
//    }
//
//    //MARK: - 首页热门店铺
//    func SY_HotStore(lat: String, lng: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .SY_hotStoreList(lat: lat, lng: lng))
//        return Observable<JSON>.create(response)
//    }
//
//    //MARK: - 首页距离最近的店铺
//    func SY_NearbyStore(lat: String, lng: String) -> Observable<JSON> {
//        let response = rxApiManager(api: .SY_NearByStoreList(lat: lat, lng: lng))
//        return Observable<JSON>.create(response)
//    }

    //MARK: - 店铺首页数据
    func Store_MainPageData(storeID: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .Store_mainPageData(storeID: storeID, type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 请求筛选标签
    func getFiltrateTags() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreFiltrateTags)
        return Observable<JSON>.create(response)
    }

    //MARK: - 菜品分类列表
    func getClassifyList(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getDishesClassify(storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 分类下的商品
    func getClassifyDishesList(classifyID: String, storeID: String, keyword: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getClassifyDishes(classifyID: classifyID, storeID: storeID, keyword: keyword))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 添加购物车
    func addShoppingCart(dishesID: String, buyNum: String, type: String, optionList: [[String: String]], deskID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .addShoppingCart(dishesID: dishesID, buyNum: buyNum, type: type, optionList: optionList, deskID: deskID))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取已添加购物车菜品列表
    func getAddedCartDishes(storeID: String, psType: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getAddedCartDishes(storeID: storeID, psType: psType))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取菜品详情
    func loadDishesDetail(dishesID: String, deskID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loadDishedDetail(dishesId: dishesID, deskId: deskID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺列表——绑定
    func storeList_Binding(tag: String, lat: String, lng: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .storeList_binding(tag: tag, lat: lat, lng: lng, page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺列表——热门
    func storeList_Hot(tag: String, lat: String, lng: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .storeList_hot(tag: tag, lat: lat, lng: lng, page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺列表——距离最近
    func storeList_Nearby(tag: String, lat: String, lng: String, allStore: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .storeList_nearby(tag: tag, lat: lat, lng: lng, page: String(page), allStore: allStore))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 搜索店铺列表
    func searchStoreList(keyword: String, lat: String, lng: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .searchStoreList(keyword: keyword, lat: lat, lng: lng, page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 更新购物车数量
    func updateCartNum(buyNum: Int, cartID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateCartNum(buyNum: String(buyNum), cartID: cartID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取确认订单详情
    func loadConfirmOrderDetail(storeID: String, buyWay: String, lat: String, lng: String, couponID: String, postCode: String, couponUserDishesId: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loadConfirmOrderDetail(lat: lat, lng: lng, buyWay: buyWay, storeID: storeID, couponID: couponID, couponUserDishesId: couponUserDishesId, postCode: postCode))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 可选择的时间列表
    func getChooseTimeList(storeID: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .canChooseTimeList(storeID: storeID, type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 可选择的时间列表预定
    func getChooseTimeList_YD(storeID: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .canChooseTimeList_YD(storeID: storeID, type: type))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取地址列表
    func getAddressList(storeID: String, type: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getAddressList(storeID: storeID, type: type, page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 修改用户地址  defaultOrNot “2”为设置默认
    func editeAddress(address: String, postCode: String, phone: String, receiver: String, lat: String, lng: String, id: String, detail: String, defaultOrNot: String) -> Observable<JSON> {
        let response = rxApiManager(api: .editeAddress(address: address, lat: lat, lng: lng, phone: phone, postCode: postCode, receiver: receiver, id: id, detail: detail, defaultOrNot: defaultOrNot))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除地址
    func deleteAddress(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteAddress(id: id))
        return Observable<JSON>.create(response)
    }

    
    //MARK: - 请求订单列表
    func getOrderList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取店铺详情
    func getStoreInfo(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .storeInfo(storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 创建订单
    func createOrder(model: CreateOrderModel) -> Observable<JSON> {
        let response = rxApiManager(api: .creatOrder(submitModel: model))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取订单详情
    func getOrderDetail(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getOrderDetail(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单取消
    func orderCancelAction(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderCancel(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单确认
    func orderConfirmAction(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderConfirm(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单支付
    func orderPay(orderID: String, payType: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderpay(orderID: orderID, payType: payType))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 店铺评论列表
    func getReviewsList(storeID: String, page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getReviewsList(storeID: storeID, page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单评价
    func orderEvalutate(content: String, orderID: String, psStar: Int, cpStar: Int, fwStar: Int, nickName: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderEvaluate(content: content, orderID: orderID, psStar: String(psStar), cpStar: String(cpStar), fwStar: String(fwStar), nickName: nickName))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 订单投诉
    func orderComplaint(content: String, orderID: String, photo: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .orderComplaint(content: content, orderID: orderID, photo: photo))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 查询当前配送员位置
    func getCurrentPSLocation(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getCurrentLocation(orderID: orderID))
        return Observable<JSON>.create(response)
    }

    //MARK: - 订单支付中
    func orderPaying(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderPaying(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取用户钱包金额
    func getWalletAmount() -> Observable<JSON> {
        let response = rxApiManager(api: .getWalletAmout)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取用户钱包明细
    func getWalletDetail(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getWalletDeail(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取钱包金额及计算订单金额
    func getWalletAndOrder(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getWalletAndOrderAmount(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取下单页面的送达时间
    func getCalOrderTime(type: String, storeID: String, time: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getCalOrderTime(type: type, storeID: storeID, time: time))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取帮助列表
    func getHelpList() -> Observable<JSON> {
        let response = rxApiManager(api: .getHelpList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取帮助详情列表
    func getHelpDetail(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getHelpDetail(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 国际化
    func setLanguage() -> Observable<JSON> {
        let response = rxApiManager(api: .uploadLanguage)
        return Observable<JSON>.create(response)
    }

    //MARK: - 再来一单
    func orderAgain(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .orderAgain(orderID: orderID))
        return Observable<JSON>.create(response)
    }

    //MARK: - 获取投诉菜单和原因
    func getPlaintOrderDishesAndReason(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getPlaintOrderDishAndReason(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 投诉菜品
    func complaintsDishes(other: String, orderID: String, dishes: [[String: Any]], reasonID: String, imageUrl: [[String: String]], hopeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .complaintsDishes(other: other, orderID: orderID, reasonID: reasonID, imageurl: imageUrl, dishes: dishes, hopeID: hopeID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 登出
    func logout() -> Observable<JSON> {
        let response = rxApiManager(api: .logout)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 检查更新
    func CheckAppVer() -> Observable<JSON> {
        let response = rxApiManager(api: .CheckAppVer)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取分类及菜品列表
    func getClassifyAndDishesList(storeID: String, deskID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getClassifyAndDishesList(storeID: storeID, deskId: deskID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 清空购物车
    func emptyCart(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .emptyCart(storeID: storeID))
        return Observable<JSON>.create(response)
    }

    //MARK: - 删除账户申请
    func deleteAccountApply() -> Observable<JSON> {
        let response = rxApiManager(api: .deleteAccountApply)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 建议
    func doSuggest(name: String, phone: String, msg: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doSuggest(name: name, phone: phone, suggest: msg))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取建议列表
    func getSuggestList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getSuggestList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 是否有未读消息
    func isHaveMessage() -> Observable<JSON> {
        let response = rxApiManager(api: .isHaveMessage)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取消息列表
    func getMessagesList(page: Int) -> Observable<JSON> {
        let response = rxApiManager(api: .getMessageList(page: String(page)))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 消息已读
    func doReadMessage(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doReadMessage(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 支付取消
    func payCancel(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .payCancel(orderID: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 删除购物车商品
    func deleteCartGoods(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .deleteCartGoods(id: id))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 刷新订单状态
    func refreshOrderStatus(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .refreshOrderStatus(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 更新用户信息
    func updateUserInfo(name: String, email: String, birthday: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateUserInfo(name: name, email: email, birthday: birthday))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取用户信息
    func getUserInfo() -> Observable<JSON> {
        let response = rxApiManager(api: .getUserInfo)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取我的优惠券列表
    func getMyCouponList() -> Observable<JSON> {
        let response = rxApiManager(api: .getMyCouponList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取可用优惠券
    func getAvabliableCouponList(dishesPrice: String, storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getAvaliableCouponList(dishesPrice: dishesPrice, storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取转盘奖品列表
    func getPrizeList() -> Observable<JSON> {
        let response = rxApiManager(api: .getPrizeList)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 转盘中奖奖品
    func doPrizeDraw(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doPrizeDraw(orderID: orderID))
        return Observable<JSON>.create(response)
    }
        
    
    //MARK: - 是否有未抽奖的订单
    func isHaveDrawPrize() -> Observable<JSON> {
        let response = rxApiManager(api: .isHaveDrawPrize)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺列表是否有首单优惠
    func getStoreListFirstDiscount() -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreListFirstDiscount)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺详情是否有首单优惠
    func getStoreDetailFirstDiscount(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreDetailFirstDiscount(storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取积分明细列表
    func getJiFenDetailList(page: Int, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getJiFenDetailList(page: String(page), type: type))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取积分兑选列表
    func getJiFenExchangeList(storeID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getJiFenExchangeList(storeID: storeID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 积分兑换
    func jiFenExchange(exID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .jiFenExchange(exID: exID))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取积分数量
    func getJiFenCount() -> Observable<JSON> {
        let response = rxApiManager(api: .getJiFenCount)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 验证餐桌
    func checkDesk(storeID: String, deskID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .checkDesk(storeID: storeID, deskID: deskID))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取国家列表
    func getCountryList() -> Observable<JSON> {
        let response = rxApiManager(api: .getCountryList)
        return Observable<JSON>.create(response)
    }
    
        
    //MARK: - 发送短信 1验证码登录，2注册，3找回密码
    func sendSMSCode(countryCode: String, phone: String, type: String) -> Observable<JSON> {
        let response = rxApiManager(api: .sendSMSCode(countryCode: countryCode, phone: phone, type: type))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 手机登陆
    func loginPhone(countryCode: String, phone: String, smsCode: String, smsID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginPhone(countryCode: countryCode, phone: phone, smsID: smsID, smsCode: smsCode))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 设置登录密码
    func setLoginPWD(pwd: String) -> Observable<JSON> {
        let response = rxApiManager(api: .setLoginPWD(pwd: pwd))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 修改密码
    func doUpdatePWD(oldPwd: String, newPwd: String) -> Observable<JSON> {
        let response = rxApiManager(api: .doUpdatePWD(oldPwd: oldPwd, newPwd: newPwd))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 找回密码
    func findPWD(countryCode: String, phone: String, smsCode: String, smsID: String, pwd: String) -> Observable<JSON> {
        let response = rxApiManager(api: .findPWD(countryCode: countryCode, phone: phone, smsID: smsID, smsCode: smsCode, pwd: pwd))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 密码登录
    func loginPWD(countryCode: String, phone: String, pwd: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginPWD(countryCode: countryCode, phone: phone, pwd: pwd))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 获取未完成的订单数
    func getUnCompleteOrderCount() -> Observable<JSON> {
        let response = rxApiManager(api: .getUnCompleteOrderCount)
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 呼叫服务员
    func callWaiter(orderID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .callWaiter(orderID: orderID))
        return Observable<JSON>.create(response)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - 获取首页数据
    func firstPageData(lat: String, lng: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getFirstPageData(lat: lat, lng: lng))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺列表
    //type: 排序条件（1:距离近远、2:经常光顾、3:评分热门)
    func storeListData(keywords: String, type: String, tag: String, lat: String, lng: String, page: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreList(keywords: keywords, type: type, tag: tag, lat: lat, lng: lng, page: page))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 店铺菜单
    func getStoreMenu(id: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getStoreMenu(id: id))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 修改菜品或是规格的购买数量
    func editeDishSpecification(cartID: String, classiftyID: String, count: Int, dishID: String, storeID: String, selectArr: [[String: String]]) -> Observable<JSON> {
        let response = rxApiManager(api: .editeDishSpectification(cartDishID: cartID, classiftyID: classiftyID, dishID: dishID, count: String(count), storeID: storeID, selectArr: selectArr))
        return Observable<JSON>.create(response)
    }
    

    
    

    
    //MARK: - 获取购物车信息
    func getCartInfo(storeID: String, psWay: String, couponID: String) -> Observable<JSON> {
        let response = rxApiManager(api: .checkCartData(couponid: couponID, way: psWay, storeID: storeID))
        return Observable<JSON>.create(response)
    }
    

    

    

    
    //MARK: - 上传推送token
    func updateTSToken(token: String) -> Observable<JSON> {
        let response = rxApiManager(api: .updateCloubMessageToken(token: token))
        return Observable<JSON>.create(response)
    }
    
    
        
    
    //MARK: - 上传图片
    func uploadImage(image: UIImage, success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->())  {

        let url = V2URL + "api/user/upload/planit"
//        let params = ["token": UserDefaults.standard.token ?? ""]
        AF.upload(multipartFormData: { (multipartFormData) in
            // 压缩
            let data = image.jpegData(compressionQuality: 0.1)
            let fileName = String.init(describing: NSDate()) + ".png"
            // withName:：是根据文档决定传入的字符串
            multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")

            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
        }, to: url, method: .post, headers: HTTPHeaders(["token-user": UserDefaults.standard.token ?? "", "token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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
    
    
    //MARK: - 上传多张图片
    func uploadImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = V2URL + "api/user/upload/planits"
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

        }, to: url, method: .post, headers: HTTPHeaders(["token-user": UserDefaults.standard.token ?? "", "token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
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


extension HttpTool: MFMailComposeViewControllerDelegate {
    
    
    
    func sendEmail(title: String, email: String) {
        if MFMailComposeViewController.canSendMail(){
            let emailVC = MFMailComposeViewController()
            //设置代理
            emailVC.mailComposeDelegate = self
            //设置主题
            emailVC.setSubject(title)
            //设置收件人
            emailVC.setToRecipients([email])
             
            //打开界面
            PJCUtil.currentVC()?.present(emailVC, animated: true, completion: nil)
        }else{
            print("不支持")
            HUD_MB.showWarnig("Sending email is unavailable!", onView: PJCUtil.getWindowView())
        }
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        if result == .sent {
            HUD_MB.showSuccess("Success", onView: PJCUtil.getWindowView())
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .failed {
            HUD_MB.showError("Failed", onView: PJCUtil.getWindowView())
        }
        if result == .saved {
            HUD_MB.showSuccess("Saved", onView:  PJCUtil.getWindowView())
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .cancelled {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    
}




