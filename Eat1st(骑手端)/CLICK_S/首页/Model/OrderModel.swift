//
//  OrderModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import SwiftyJSON

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
    ///配送费
    var deliveryFee: Double = 0
    ///支付金额
    var payPrice: Double = 0
    ///地址
    var address: String = ""
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
    
    ///商品总金额
    var dishPrice: Double = 0
    ///优惠金额
    var discountPrice: Double = 0
    ///服务费用
    var serviceFee: Double = 0
    ///优惠金额 钱包抵扣金额
    var walletPrice: Double = 0
    ///订单金额 减去折扣 不减钱包之前的价格
    var orderPrice: Double = 0


    ///订单创建时间
    var createTime: String = ""
    
    ///付款方式 （1：cash、2：card）
    var paymentMethod: String = ""
    
    var dishArr: [OrderDishModel] = []
            
    var address_H: CGFloat = 0
    var remark_H: CGFloat = 0
    
    

    
    
    

    
    
    

    
    func updateModel(json: JSON) {

        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.statusStr = json["statusName"].stringValue
        self.dayNum = json["orderDayNum"].stringValue
        self.orderNum = json["orderId"].stringValue
        self.id = json["orderId"].stringValue
        self.deliveryFee = json["deliveryPrice"].doubleValue
        self.payPrice = json["payPrice"].doubleValue
        self.address = json["addressResult"]["address"].stringValue
        self.postCode = json["addressResult"]["postCode"].stringValue
        self.startTime = json["hopeTimeResult"]["startTime"].stringValue
        self.endTime = json["hopeTimeResult"]["endTime"].stringValue

        self.content_H = self.address == "" ? 105 : self.address.getTextHeigh(SFONT(13), S_W - 205) + 90

        


        

        self.remarks = json["remark"].stringValue

        self.perName = json["addressResult"]["name"].stringValue
        self.perPhone = json["addressResult"]["phone"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.distance = json["distance"].doubleValue
        self.lat = json["addressResult"]["lat"].doubleValue
        self.lng = json["addressResult"]["lng"].doubleValue


        self.dishPrice = json["dishesPrice"].doubleValue
        self.serviceFee = json["servicePrice"].doubleValue
        self.discountPrice = json["discountAmount"].doubleValue
        self.walletPrice = json["walletPrice"].doubleValue
        self.orderPrice = json["orderPrice"].doubleValue

        self.paymentMethod = json["payType"].stringValue


        self.createTime = json["createTime"].stringValue


        var tArr: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {

            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr


        let addressStr = self.postCode + "\n" + self.address
        address_H = self.address == "" ? 0 : addressStr.getTextHeigh(SFONT(14), S_W - 60) + 60
        remark_H = self.remarks == "" ? 0 : self.remarks.getTextHeigh(SFONT(13), S_W - 110) + 10
        
        

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
    
    
    var nameStr: String = ""
    var desStr: String = ""
    
    var dish_H: CGFloat = 0
    
    
    
    func updateModel(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = json["nameHk"].stringValue
        self.name_E = json["nameEn"].stringValue
        self.detailImg = json["imageUrl"].stringValue
        self.subFee = json["dishesPrice"].doubleValue

        
        
        var t1: String = ""
        var t2: String = ""
        for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
            
            if idx == 0 {
                t1 = jsonData["nameEn"].stringValue
                t2 = jsonData["nameHk"].stringValue
            } else {
                t1 = t1 + "/" + jsonData["nameEn"].stringValue
                t2 = t2 + "/" + jsonData["nameHk"].stringValue
            }
        }
        self.des_C = t2
        self.des_E = t1
        
        
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
        self.dish_H = a_h > 90 ? a_h : 90
        
    }
}
