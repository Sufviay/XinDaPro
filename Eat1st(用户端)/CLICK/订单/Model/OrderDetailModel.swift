//
//  OrderDetailModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/2.
//

import UIKit
import SwiftyJSON


class OrderDetailModel: NSObject {

    ///接单人
    var recipient: String = ""
    ///电话
    var recipientPhone: String = ""
    ///地址
    var recipientAddress: String = ""
    ///门牌号
    var houseNo: String = ""
    
    ///收货人经纬度
    var recipientLat: String = ""
    var recipientLng: String = ""
    
    var postCode: String = ""

    ///期望时间
    var hopeTime: String = ""
    ///备注
    var remark: String = ""

    
    ///订单编号
    var orderNum: String = ""
    
    ///订单ID
    var orderID: String = ""
    
    ///订单类型1：外卖、2：自取 3 堂食
    var type: String = ""
    ///订单状态
    ///1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
    var status: OrderStatus = .unKnown
    ///状态文字
    var statusStr: String = ""
    
    ///店铺信息
    var storeInfo = StoreInfoModel()
    
    
    
    /**
     [model.actualFee, model.deliveryFee, model.serviceFee, model.packPrice, model.dishesDiscountAmount, model.couponAmount, model.discountAmount, 0, model.orderPrice, model.walletPrice, model.payPrice]
     */
    
    ///商品实际金额
    var actualFee: Double = 0
    ///配送金额
    var deliveryFee: Double = 0
    ///服务费用
    var serviceFee: Double = 0
    ///包装费
    var packPrice: Double = 0
    ///菜品的优惠金额
    var dishesDiscountAmount: Double = 0
    ///优惠券抵扣金额
    var couponAmount: Double = 0
    ///折扣金额
    var discountAmount: Double = 0
    ///订单金额 减去折扣 不减钱包之前的价格
    var orderPrice: Double = 0
    ///优惠金额 钱包抵扣金额
    var walletPrice: Double = 0
    ///实际付款金额
    var payPrice: Double = 0
    ///总金额
    var totalFee: Double = 0
    ///折扣比例
    var discountScale: String = ""
    ///是否有折扣 1有折扣，2无折扣
    var discountStatus: String = ""
    ///折扣说明
    var discountMsg: String = ""
    ///菜品是否有优惠 1无优惠 2有优惠
    var dishesDiscountType: String = ""
    ///是否有优惠券（1是，2否）
    var couponType: String = ""
    ///支付方式 1：cash、2：online   3pos  4cash&pos  -1位选择支付方式
    var paymentMethod: String = ""
    ///订单免除金额
    var noPaidPrice: Double = 0
    
    ///订单中套餐的金额
    var baleDishesPrice: Double = 0
    
    ///余额支付金额
    var rechargePrice: Double = 0
    
    
    
    ///预定说明
    var reserveMsg: String = ""
    
    ///评论信息
    var evaluateContent: String = ""
    ///菜品评分
    var dishStar: Float = 0
    ///服务评分
    var serviceStar: Float = 0
    ///配送评分
    var deliveryStar: Float = 0
    ///评价时间
    var evaluateTime: String = ""
    ///评价回复
    var pjReplyContent: String = ""

    ///评价状态 1未评价，2已评价
    var pjStatus: String = ""

    
    ///拒接原因
    var refuseReason: String = ""
    
    
    ///商家取消原因
    var cancelReason: String = ""
    
    
    ///投诉内容
    var tsContent: String = ""
    ///投诉原因
    var tsReason: String = ""
    
    ///投诉处理方式 （1未处理，2拒绝，3退款，4再送一单，5下次优惠）
    var tsDealWay: String = ""
    ///投诉状态 1未投诉，2未处理，3商家拒绝，4商家退款，5再送一单，6下次优惠
    var tsStauts: String = ""
    ///投诉图片
    var tsImgArr: [String] = []
    ///处理投诉内容
    var tsDealContent: String = ""
    ///投诉时间
    var tsTime: String = ""
    ///投诉处理时间
    var tsDealTime: String = ""
    
    
    
        
    ///菜品数组
    var dishArr: [OrderDishModel] = []
    
    ///优惠券菜品
    var couponDish = CartDishModel()
    
    ///满赠的菜品
    var fullGiftDish = CartDishModel()
    

    
    ///配送员ID
    var deliveryMan: String = ""

    ///配送经度维度
    var deliveryLat: String = ""
    var deliveryLng: String = ""
    
    ///店铺支持的支付方式 1现金、2卡、99全部支持
    var storePayType: String = ""
    ///预计送达时间
    var startTime: String = ""
    var endTime: String = ""
    ///是否超时（1是2否）
    var timeOut: Bool = false
    
    
    
    var msgArr: [String] = []
    
    ///下单时间
    var createTime: String = ""
    ///期望送达时间
    var takeTime: String = ""
    
    ///订单是否可以抽奖  (1是，2否）
    var prizeStatus: Bool = false
    ///是否已经抽奖了   1是，2否
    var prizeDrawStatus: Bool = false
    
    
    var discountMsg_H: CGFloat = 0
    var confirmMoney_H: CGFloat = 0
    var detailMoney_H: CGFloat = 0
    
    //退款相关
    
    ///订单退款状态编码（1无退款，2退款中，3退款成功，4退款失败）
    var refundStatusId: String = ""
    ///订单退款状态名称
    var refundStatusName: String = ""
    
    ///退款类型名称
    var refundTypeName: String = ""
    ///退款方式
    var refundFlowName: String = ""
    ///退款金额
    var cardPrice: Double = 0
    var posPrice: Double = 0
    var cashPrice: Double = 0
    
    ///退款时间
    var refundCreateTime: String = ""
    
    


    
    
    

    
    func updateModel(json: JSON, _ isConfirm: Bool = false) {
        self.recipient = json["addressResult"]["name"].stringValue
        self.recipientPhone = json["addressResult"]["phone"].stringValue
        self.recipientAddress = json["addressResult"]["address"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.remark = json["remark"].stringValue
        self.recipientLng = json["addressResult"]["lng"].stringValue
        self.recipientLat = json["addressResult"]["lat"].stringValue
        self.postCode = json["addressResult"]["postCode"].stringValue
        self.houseNo = json["addressResult"]["houseNo"].stringValue
        self.takeTime = json["addressResult"]["takeTime"].stringValue

        self.createTime = json["createTime"].stringValue
            
        self.orderNum = json["orderId"].stringValue
        self.orderID = json["orderId"].stringValue
        self.type = json["deliveryType"].stringValue
        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.statusStr = json["statusName"].stringValue
        self.storeInfo.updateModel(json: json["storeResult"])
        
                
        self.actualFee = json["dishesPrice"].doubleValue
        self.deliveryFee = json["deliveryPrice"].doubleValue
        self.totalFee = json["totalPrice"].doubleValue
        self.serviceFee = json["servicePrice"].doubleValue
        self.walletPrice = json["walletPrice"].doubleValue
        self.payPrice = json["payPrice"].doubleValue
        self.orderPrice = json["orderPrice"].doubleValue
        self.packPrice = json["packPrice"].doubleValue
        self.dishesDiscountAmount = json["dishesDiscountAmount"].doubleValue
        self.dishesDiscountType = json["dishesDiscountType"].stringValue
        self.couponAmount = json["couponAmount"].doubleValue
        self.couponType = json["couponType"].stringValue
        self.discountStatus = json["discountStatus"].stringValue
        self.discountScale = json["discountScale"].stringValue
        self.discountAmount = json["discountAmount"].doubleValue
        self.discountMsg = json["discountMsg"].stringValue
        self.paymentMethod = json["payType"].stringValue
        self.noPaidPrice = json["settleResult"]["noPaidPrice"].doubleValue
        self.rechargePrice = json["rechargePrice"].doubleValue
        
        
        self.reserveMsg = json["reserveMsg"].stringValue

        
        self.evaluateContent = json["evaluateResult"]["content"].stringValue
        self.pjReplyContent = json["evaluateResult"]["replyontent"].stringValue
        self.dishStar = json["evaluateResult"]["dishesNum"].floatValue
        self.serviceStar = json["evaluateResult"]["serviceNum"].floatValue
        self.deliveryStar = json["evaluateResult"]["deliveryNum"].floatValue
        self.evaluateTime = json["evaluateResult"]["createTime"].stringValue
        self.pjStatus = json["evalStatusId"].stringValue
        
        
        self.refuseReason = json["refuseResult"]["refuseReason"].stringValue
        
        self.cancelReason = json["cancelReasonResult"]["reasonOther"].stringValue
        
        self.startTime = json["hopeTimeResult"]["startTime"].stringValue
        self.endTime = json["hopeTimeResult"]["endTime"].stringValue
        self.timeOut = json["hopeTimeResult"]["timeOut"].stringValue == "1" ? true : false
        
        self.tsContent = json["plaintResult"]["content"].stringValue
        self.tsReason = json["plaintResult"]["plaintReasonName"].stringValue
        self.tsDealWay = json["plaintResult"]["handleType"].stringValue
        self.tsStauts = json["plaintStatusId"].stringValue
        self.tsTime = json["plaintResult"]["createTime"].stringValue
        self.tsDealTime = json["plaintResult"]["handleTime"].stringValue
        self.tsDealContent = json["plaintStatusName"].stringValue
        
        self.storePayType = json["storePayType"].stringValue
        
        self.prizeStatus = json["prizeStatus"].stringValue == "1" ? false : true
        self.prizeDrawStatus = json["prizeDrawStatus"].stringValue == "1" ? false : true
        
        
        self.refundCreateTime = json["refundResult"]["createTime"].stringValue
        self.refundFlowName = json["refundResult"]["refundFlowName"].stringValue
        self.refundTypeName = json["refundResult"]["refundTypeName"].stringValue
        self.cardPrice = json["refundResult"]["cardPrice"].doubleValue
        self.posPrice = json["refundResult"]["posPrice"].doubleValue
        self.cashPrice = json["refundResult"]["cashPrice"].doubleValue
        
        self.refundStatusName = json["refundStatusName"].stringValue
        self.refundStatusId = json["refundStatusId"].stringValue
        
       
        
        
        var tArr1: [String] = []
        for jsonData in json["plaintResult"]["plaintImageList"].arrayValue {
            tArr1.append(jsonData["url"].stringValue)
        }
        self.tsImgArr = tArr1
        
        
        self.deliveryMan = json["deliveryMan"].stringValue
        

        
        ///处理订单中的套餐商品
        
        var t1Arr: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {
            
            let model = OrderDishModel()
            model.updateModel(json: jsonData, isConfirm: isConfirm)
            t1Arr.append(model)
            
            
            if model.isGiveOne {
                if !isConfirm {
                    let t_model = OrderDishModel()
                    t_model.isGive = true
                    t_model.updateModel(json: jsonData, isConfirm: false)
                    t1Arr.append(t_model)
                }
            }
        }
        
        if !isConfirm {
           //订单详情里
            
            dishArr = t1Arr.filter { $0.baleSort == "0" }
            
            //套餐商品
            let taoCanArr = t1Arr.filter { $0.baleSort != "0" }


            var t2Arr: [OrderDishModel] = []
            
            //套餐
            //如果套餐数组中不存在相同的 baleSort 就创建一个 OrderDishModel
            //如果存在 当作赠品 可删除

            for tcmodel in taoCanArr {
                
                let arr = t2Arr.filter { $0.baleSort == tcmodel.baleSort }
                if arr.count == 0 {
                    let newModel = OrderDishModel()
                    newModel.subFee = json["baleDishesPrice"].doubleValue
                    if PJCUtil.getCurrentLanguage() == "zh_CN" || PJCUtil.getCurrentLanguage() == "zh_HK" {
                        newModel.name_C = json["baleNameHk"].stringValue
                    } else {
                        newModel.name_C = json["baleNameEn"].stringValue
                    }
                    
                    newModel.baleSort = tcmodel.baleSort
                    newModel.discountType = "1"
                    newModel.count = 1
                    newModel.des_C = tcmodel.name_C
                    
                    let h1 = newModel.name_C.getTextHeigh(BFONT(14), S_W - 195)
                    let h2 = newModel.des_C.getTextHeigh(SFONT(11), S_W - 195)
                    
                    newModel.dish_H = h1 + h2 + 35 < 75 ? 75 : h1 + h2 + 35
                    t2Arr.append(newModel)

                } else {
                    
                    arr.first!.des_C = arr.first!.des_C + "\n" + tcmodel.name_C
                    let h1 = arr.first!.name_C.getTextHeigh(BFONT(14), S_W - 195)
                    let h2 = arr.first!.des_C.getTextHeigh(SFONT(11), S_W - 195)
                    
                    arr.first!.dish_H = h1 + h2 + 35 < 75 ? 75 : h1 + h2 + 35

                }
                
                
            }
            
            dishArr += t2Arr
            
        } else {
            self.dishArr = t1Arr
        }
    
        
        self.couponDish.updateModel(json: json["couponResult"]["dishesResult"])
        self.fullGiftDish.updateModel(json: json["fullGiftResult"])
        
        
        var payWay: String = ""
        
        if paymentMethod == "1" {
            payWay = "cash"
        }
        else if paymentMethod == "2" {
            payWay = "card"
        }
        else if paymentMethod == "3" {
            payWay = "Pos"
        }
        else if paymentMethod == "4" {
            payWay = "Cash&Pos"
        } else if paymentMethod == "5" {
            payWay = "WX"
        } else if paymentMethod == "6" {
            payWay = "Wallet Spent"
        } else {
            payWay = "No choice yet"
        }
        
        
        
        var addressStr = ""
        
        if postCode != "" {
            addressStr = postCode
            
            if houseNo != "" {
                addressStr += "\n\(houseNo)"
            }
            if recipientAddress != "" {
                addressStr += "\n\(recipientAddress)"
            }
            
        } else {
            if houseNo != "" {
                addressStr += houseNo
            }
            if recipientAddress != "" {
                addressStr += "\n\(recipientAddress)"
            }
        }
        
        
        self.msgArr = [recipient, recipientPhone, addressStr, takeTime, remark, createTime, payWay, ""]
        
        
        if discountMsg == "" {
            self.discountMsg_H = 0
        } else {
            self.discountMsg_H = discountMsg.getTextHeigh(SFONT(10), S_W - 60) + 20
        }
                
        //actualFee, deliveryFee, serviceFee, orderPrice
        
        
        if type == "1" {
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee, rechargePrice].filter { $0 != 0 }
            self.confirmMoney_H = 3 * 30 + CGFloat(arr.count) * 30 + discountMsg_H + 20
            
            let arr1 = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, walletPrice, serviceFee, noPaidPrice, rechargePrice].filter { $0 != 0 }
            self.detailMoney_H = 4 * 35 + CGFloat(arr1.count) * 35 + discountMsg_H + 20
            
        } else {
            let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, serviceFee, deliveryFee, rechargePrice].filter { $0 != 0 }
            self.confirmMoney_H = 2 * 30 + CGFloat(arr.count) * 30 + discountMsg_H + 20
            
            let arr1 = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, walletPrice, serviceFee, deliveryFee, noPaidPrice, rechargePrice].filter { $0 != 0 }
            self.detailMoney_H = 3 * 35 + CGFloat(arr1.count) * 35 + discountMsg_H + 20
        }
        
//        let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount].filter { $0 != 0 }
//        self.confirmMoney_H = 4 * 30 + CGFloat(arr.count) * 30 + discountMsg_H + 20
        
        
        //actualFee, deliveryFee, serviceFee,  orderPrice
//        let arr1 = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, walletPrice].filter { $0 != 0 }
//        self.detailMoney_H = 5 * 35 + CGFloat(arr1.count) * 35 + discountMsg_H + 20
        
    }
    

}
