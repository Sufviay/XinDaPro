//
//  OrderModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import SwiftyJSON


class OtherOrderModel {
    
    ///订单状态（2已派单，3配送中，4已完成）
    var orderStatus: String = ""
    /// 用户地址
    var address: String = ""
    var lat: Double = 0
    var lng: Double = 0
    ///用户邮编 ,
    var postCode: String = ""
    ///用户电话
    var phone: String = ""
    ///订单编号
    var orderCode: String = ""
    ///订单编码
    var orderId: String = ""
    ///骑手结束配送时间
    var riderEndTime: String = ""
    ///骑手开始配送时间
    var riderStartTime: String = ""
    
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        self.orderId = json["orderId"].stringValue
        self.address = json["address"].stringValue
        self.postCode = json["postCode"].stringValue
        self.lat = json["lat"].doubleValue
        self.lng = json["lng"].doubleValue
        self.phone = json["phone"].stringValue
        self.orderCode = json["postCode"].stringValue
        self.orderStatus = json["orderStatus"].stringValue
        self.riderStartTime = json["riderStartTime"].stringValue
        self.riderEndTime = json["riderEndTime"].stringValue
            
        self.cell_H = self.address == "" ? (75 + 40 + 35) : (self.address.getTextHeigh(SFONT(13), S_W - 205) + 75 + 40 + 35)

    }
    
    
}



class OrderModel: NSObject {
    
    ///订单状态 1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
    var status: OrderStatus = .unKnown
    ///状态文字
    var statusStr: String = ""

    ///订单流水号
    var dayNum: String = ""
    ///订单号
    var orderNum: String = ""
    ///订单ID
    var id: String = ""
    ///配送开始时间
    var startTime: String = ""
    ///配送结束时间
    var endTime: String = ""
    ///邮编
    var postCode: String = ""
    ///地址
    var address: String = ""
    ///门牌号
    var houseNo: String = ""
    
    ///拼接的详细地址信息
    var addressStr: String = ""
    var hAnda_Address: String = ""
    
    ///列表内容高度
    var content_H: CGFloat = 0

    ///以上首页订单列表用的字段
    
    
    
    ///订单备注
    var remarks: String = "1"
    ///购买人姓名
    var perName: String = ""
    ///购买人电话
    var perPhone: String = ""
    ///购买人经度
    var lat: Double = 0
    ///购买人纬度
    var lng: Double = 0
    ///预定送餐时间
    var hopeTime: String = ""
    
    ///距离
    var distance: Double = 0
    
    
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
    ///支付方式 1：cash、2：online   -1位选择支付方式
    var paymentMethod: String = ""
    
    

    ///订单创建时间
    var createTime: String = ""
    //购买的菜品
    var dishArr: [OrderDishModel] = []
    //赠送的菜品
    var couponDish = OrderDishModel()
    
    //满赠的菜品
    var fullGiftDish = OrderDishModel()
    
    
    var address_H: CGFloat = 0
    var remark_H: CGFloat = 0
    
    var detailMoney_H: CGFloat = 0
    var discountMsg_H: CGFloat = 0
    
    
    

    
    
    

    
    func updateModel(json: JSON) {

        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.statusStr = json["statusName"].stringValue
        self.dayNum = json["orderDayNum"].stringValue
        self.orderNum = json["orderId"].stringValue
        self.id = json["orderId"].stringValue
//        self.deliveryFee = json["deliveryPrice"].doubleValue
//        self.payPrice = json["payPrice"].doubleValue
        self.address = json["addressResult"]["address"].stringValue
        self.houseNo = json["addressResult"]["houseNo"].stringValue
        self.postCode = json["addressResult"]["postCode"].stringValue
        self.startTime = json["hopeTimeResult"]["startTime"].stringValue
        self.endTime = json["hopeTimeResult"]["endTime"].stringValue

        

        
        
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
        
    
        

        self.remarks = json["remark"].stringValue

        self.perName = json["addressResult"]["name"].stringValue
        self.perPhone = json["addressResult"]["phone"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.distance = json["distance"].doubleValue
        self.lat = json["addressResult"]["lat"].doubleValue
        self.lng = json["addressResult"]["lng"].doubleValue


        self.createTime = json["createTime"].stringValue


        var tArr: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {

            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr
        
        self.couponDish.updateModel(json: json["couponResult"]["dishesResult"])
        
        
        self.fullGiftDish.nameStr = json["fullGiftResult"]["dishesName"].stringValue
        self.fullGiftDish.listImg = json["fullGiftResult"]["imageUrl"].stringValue

        
        if postCode != "" {
            addressStr = postCode
            
            if houseNo != "" {
                addressStr += "\n\(houseNo)"
            }
            if address != "" {
                addressStr += "\n\(address)"
            }
            
        } else {
            if houseNo != "" {
                addressStr += houseNo
            }
            if address != "" {
                addressStr += "\n\(address)"
            }
        }
        
        
        
        address_H = addressStr == "" ? 0 : addressStr.getTextHeigh(SFONT(14), S_W - 60) + 60
        remark_H = remarks == "" ? 0 : remarks.getTextHeigh(SFONT(13), S_W - 110) + 10
        
        
        
        if houseNo == "" {
            if address != "" {
                hAnda_Address = address
            }
        } else {
            if address != "" {
                hAnda_Address = houseNo + "\n" + address
            } else {
                hAnda_Address = houseNo
            }
        }
        
        content_H = hAnda_Address == "" ? 105 : hAnda_Address.getTextHeigh(SFONT(13), S_W - 205) + 90
        
        
        if discountMsg == "" {
            self.discountMsg_H = 0
        } else {
            self.discountMsg_H = discountMsg.getTextHeigh(SFONT(10), S_W - 60) + 20
        }

        let arr = [packPrice, dishesDiscountAmount, couponAmount, discountAmount, walletPrice].filter { $0 != 0 }
        self.detailMoney_H = 6 * 35 + CGFloat(arr.count) * 35 + discountMsg_H + 20
    }
}



class OrderDishModel: NSObject {
    
    var count: Int = 0
    
    ///列表图片
    var listImg: String = ""
    ///详情图片
    var detailImg: String = ""
    ///名字中文
    var name_C: String = ""
    ///名字英文
    var name_E: String = ""
    ///购物车商品总价
    var subFee: Double = 0
    
    ///描述中文
    var des_C: String = ""
    ///描述英文
    var des_E: String = ""
    
    ///商品类型 1单品，2套餐
    var dishtype: String = ""
        
    //是否是买一赠一的
    var isGiveOne: Bool = false
    
    
    var nameStr: String = ""
    var desStr: String = ""
    
    var dish_H: CGFloat = 0
    

    
    
    
    func updateModel(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = HTML(json["nameHk"].stringValue)
        self.name_E = HTML(json["nameEn"].stringValue)
        self.detailImg = json["imageUrl"].stringValue
        self.subFee = json["dishesPrice"].doubleValue
        self.dishtype = json["dishesType"].stringValue
        self.isGiveOne = json["giveOne"].stringValue == "1" ? false : true
        
        
        if dishtype == "1" {
            var t1: String = ""
            var t2: String = ""
            for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    t1 = HTML(jsonData["nameEn"].stringValue)
                    t2 = HTML(jsonData["nameHk"].stringValue)
                } else {
                    t1 = t1 + "/" + HTML(jsonData["nameEn"].stringValue)
                    t2 = t2 + "/" + HTML(jsonData["nameHk"].stringValue)
                }
            }
            self.des_C = t2
            self.des_E = t1
        }
        
        if dishtype == "2" {
            var t1: String = ""
            var t2: String = ""
            for (idx, jsonData) in json["comboList"].arrayValue.enumerated() {
                
                if idx == 0 {
                    t1 = HTML(jsonData["nameEn"].stringValue)
                    t2 = HTML(jsonData["nameHk"].stringValue)
                } else {
                    t1 = t1 + "\n" + HTML(jsonData["nameEn"].stringValue)
                    t2 = t2 + "\n" + HTML(jsonData["nameHk"].stringValue)
                }
            }
            self.des_C = t2
            self.des_E = t1

        }
        
        
        
        let curLa = PJCUtil.getCurrentLanguage()
        
        if curLa == "en_GB" {
            self.nameStr = "\(name_E)\n(\(name_C))"
            self.desStr = des_E == "" ? "" : "\(des_E)\n(\(des_C))"
        } else {
            self.nameStr = "\(name_C)\n(\(name_E))"
            self.desStr = des_C == "" ? "" : "\(des_C)\n(\(des_E))"
        }

        
        
        let n_h = nameStr.getTextHeigh(BFONT(14), S_W - 180)
        let d_h = desStr.getTextHeigh(SFONT(13), S_W - 180)
        let a_h = n_h + d_h + 5 + 25
        
        if isGiveOne {
            dish_H = a_h + 30 > 90 ? a_h + 30 : 90
        } else {
            dish_H = a_h > 90 ? a_h : 90
        }
    }
}
