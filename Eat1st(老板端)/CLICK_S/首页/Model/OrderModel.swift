//
//  OrderModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import SwiftyJSON

class OrderModel: NSObject {
    
    ///订单流水号
    var dayNum: String = ""
    ///订单号
    var orderNum: String = ""
    ///订单ID
    var id: String = ""
    ///订单备注
    var remarks: String = "1"

    ///订单类型（1：外卖、2：自取）
    var type: String = ""
    ///订单状态  1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
    var status: OrderStatus = .unKnown
    ///状态文字
    var statusStr: String = ""
    ///购买人姓名
    var perName: String = ""
    ///购买人电话
    var perPhone: String = ""
    ///购买人经度
    var lat: Double = 0
    ///购买人纬度
    var lng: Double = 0
    ///邮编
    var postCode: String = ""
    
    
    
    ///预定送餐时间
    var hopeTime: String = ""
    ///距离
    var distance: Float = 0
    ///地址
    var address: String = ""
    ///商品总金额
    var amountOriginal: Float = 0
    ///优惠金额
    var amountDiscount: Float = 0
    ///配送费
    var amountDelivery: Float = 0
    ///订单总金额
    var amountTotal: Float = 0
    
    ///拒接原因
    var refuseReason: String = ""
    ///评论星级
    var evaluateStar: Float = 0
    ///评论内容
    var evaluateContent: String = ""
    ///评价时间
    var evaluateTime: String = ""
    
    ///订单创建时间
    var createTime: String = ""
    
    
    ///付款方式 （1：cash、2：card）
    var paymentMethod: String = ""
    
    ///投诉内容
    var tsContent: String = ""
    ///处理结果
    var tsDealDes: String = ""
    ///投诉时间
    var tsTime: String = ""
    ///菜品数组
    var dishArr: [OrderDishModel] = []
    
    ///投诉状态 （1未投诉，2未处理，3商家拒绝，4商家退款，5再送一单，6下次优惠）
    var tsStatus: String = ""
    ///订单评价状态
    var pjStatus: String = ""
    
    
    ///高度
    var cellHeight: CGFloat = 0
    
    
    var h0: CGFloat = 0
    var h1: CGFloat = 160
    var h2: CGFloat = 0
    var h3: CGFloat = 0
    var h4: CGFloat = 0
    var h5: CGFloat = 120
    var h6: CGFloat = 0
    var h7: CGFloat = 0
    var h8: CGFloat = 50
    var h9: CGFloat = 0
    var h10: CGFloat = 0
    var h11: CGFloat = 60
    var h12: CGFloat = 0
    
    
    

    
    func updateModel(json: JSON) {
        
        
        self.dayNum = json["orderDayNum"].stringValue
        self.orderNum = json["orderId"].stringValue
        self.id = json["orderId"].stringValue
        
        self.remarks = json["remark"].stringValue

        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.perName = json["addressResult"]["name"].stringValue
        self.perPhone = json["addressResult"]["phone"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.distance = json["distance"].floatValue
        self.address = json["addressResult"]["address"].stringValue
        self.lat = json["addressResult"]["lat"].doubleValue
        self.lng = json["addressResult"]["lng"].doubleValue
        self.postCode = json["addressResult"]["postCode"].stringValue
        
        self.amountOriginal = json["dishesPrice"].floatValue
        
        self.amountDelivery = json["deliveryPrice"].floatValue
        //self.amountDiscount = json["amountDiscount"].floatValue
        self.amountTotal = json["totalPrice"].floatValue
        
        self.refuseReason = json["refusesResult"]["refuseReason"].stringValue
        
        self.evaluateStar = json["evaluateResult"]["starNum"].floatValue
        self.evaluateContent = json["evaluateResult"]["evalContent"].stringValue
        self.evaluateTime = json["evaluateResult"]["evalTime"].stringValue
        
        self.paymentMethod = json["payType"].stringValue
        
        self.statusStr = json["statusName"].stringValue
        self.type = json["deliveryType"].stringValue
        
        self.tsStatus = json["plaintStatusId"].stringValue
        self.pjStatus = json["evaluateStatusId"].stringValue
        
        self.tsDealDes = json["plaintStatusName"].stringValue
        
        self.tsContent = json["complaintVO"]["content"].stringValue
        self.tsTime = json["complaintVO"]["createTime"].stringValue
        
        self.createTime = json["createTime"].stringValue

        
        

        
        var tArr: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {
            
            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr
    
        
        h0 = self.type == "1" ? 0 : 60
        
        let addressStr = self.postCode + "\n" + self.address
        h2 = self.address == "" ? 0 : addressStr.getTextHeigh(SFONT(14), S_W - 60) + 60
        h12 = self.address == "" ? 95 : self.address.getTextHeigh(SFONT(13), S_W - 205) + 80
        
        h3 = self.remarks == "" ? 0 : self.remarks.getTextHeigh(SFONT(13), S_W - 110) + 10
        h4 = CGFloat(self.dishArr.count * 90)

        h6 = self.refuseReason.getTextHeigh(SFONT(13), S_W - 160) + 20
        h7 = self.evaluateContent.getTextHeigh(SFONT(13), S_W - 160) + 55 + 30
        //h8 = 50
//        h9 = self.tsContent.getTextHeigh(SFONT(13), S_W - 180) + 20
        h10 = self.tsDealDes.getTextHeigh(SFONT(13), S_W - 180) + 20
        //h11 = 60
        
        // 6待接单。 接单、拒接单
        // 5拒接单  拒接原因
        // 7已接单  已出餐按钮
        // 8已出餐 配货员开始配送按钮 和 已取餐按钮
        // 9配送中  已送达按钮
        // 10 完成。 没有评价 没有投诉 没有按钮
        // 评价展示评价内容 时间 星级
        // 投诉了 展示查看投诉按钮
        
        
        
        // 1待接单。 接单、拒接单
        // 4拒接单  拒接原因
        // 5已接单  已出餐、以配送
        //6 已出餐  7 配送中   已送达、以取餐
        //8已取餐 9已送达   无按钮
        //10 已评价  评价内容
        //11投诉未处理。 处理按钮。投诉原因
        //12投诉已处理。 投诉内容。 投诉结果

        ///1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
    
        if status == .pay_success {
            
            self.cellHeight = h12 + h11
            
//            self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h11
            
        }
        
        //拒接
        if status == .reject {
            self.cellHeight = h12
            
//            self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h6

        }
        
        //已接单
        if status == .takeOrder {
            self.cellHeight = h12 + h11
            
//            self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h11

        }
        
        // 已出餐  点击配送按钮 或者 以取餐按钮
        if status == .cooked {
            self.cellHeight = h12 + h11
            //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h11
        }
        
        // 配送中 已送达按钮 {
        if status == .delivery_ing {
            self.cellHeight = h12 + h11
            //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h11
        }
        
        // 已完成
        if status == .finished {
            //没有评价 也没有投诉
            if self.pjStatus == "1" && self.tsStatus == "1" {
                self.cellHeight = h12
                //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5
            }
            if self.pjStatus != "1" {
                //有评价
                self.cellHeight = h12
                //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h7
            }
            if self.tsStatus != "1" {

                if tsStatus == "2" {
                    //投诉未处理
                    self.cellHeight = h12 + h11
                    //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h11
                } else {
                    //投诉已处理
                    self.cellHeight = h12
                    //self.cellHeight = h0 + h1 + h2 + h3 + h4 + h5 + h10
                }
            }
        }
    }
    

    func updateModel2(json: JSON) {
        
        self.dayNum = json["orderDayNum"].stringValue
        self.orderNum = json["orderId"].stringValue
        self.id = json["orderId"].stringValue
        
        self.remarks = json["remark"].stringValue

        self.status = PJCUtil.getOrderStatus(StatusString: json["statusId"].stringValue)
        self.perName = json["addressResult"]["name"].stringValue
        self.perPhone = json["addressResult"]["phone"].stringValue
        self.hopeTime = json["addressResult"]["takeTime"].stringValue
        self.distance = json["distance"].floatValue
        self.address = json["addressResult"]["address"].stringValue
        self.lat = json["addressResult"]["lat"].doubleValue
        self.lng = json["addressResult"]["lng"].doubleValue
        self.postCode = json["addressResult"]["postCode"].stringValue
        
        
        self.amountOriginal = json["dishesPrice"].floatValue
        
        self.amountDelivery = json["deliveryPrice"].floatValue
        //self.amountDiscount = json["amountDiscount"].floatValue
        self.amountTotal = json["totalPrice"].floatValue
        
        self.refuseReason = json["refusesResult"]["refuseReason"].stringValue
        
        self.evaluateStar = json["evaluateResult"]["starNum"].floatValue
        self.evaluateContent = json["evaluateResult"]["evalContent"].stringValue
        self.evaluateTime = json["evaluateResult"]["evalTime"].stringValue
        
        self.paymentMethod = json["payType"].stringValue
        
        self.statusStr = json["statusName"].stringValue
        self.type = json["deliveryType"].stringValue
        
        self.tsStatus = json["plaintStatusId"].stringValue
        self.pjStatus = json["evalStatusId"].stringValue
        
        self.tsDealDes = json["plaintStatusName"].stringValue
        
        self.tsContent = json["complaintVO"]["content"].stringValue
        self.tsTime = json["complaintVO"]["createTime"].stringValue
        
        self.createTime = json["createTime"].stringValue

    
        
        var tArr: [OrderDishModel] = []
        for jsonData in json["dishesList"].arrayValue {
            
            let model = OrderDishModel()
            model.updateModel2(json: jsonData)
            tArr.append(model)
        }
        self.dishArr = tArr
    
        
        h0 = self.type == "1" ? 0 : 60
        
        let addressStr = self.postCode + "\n" + self.address
        h2 = self.address == "" ? 0 : addressStr.getTextHeigh(SFONT(14), S_W - 60) + 40
        h12 = self.address == "" ? 85 : self.address.getTextHeigh(SFONT(13), S_W - 205) + 80
        
        h3 = self.remarks == "" ? 0 : self.remarks.getTextHeigh(SFONT(13), S_W - 110) + 10
        h4 = CGFloat(self.dishArr.count * 90)

        h6 = self.refuseReason.getTextHeigh(SFONT(13), S_W - 160) + 20
        h7 = self.evaluateContent.getTextHeigh(SFONT(13), S_W - 160) + 55 + 30
        //h8 = 50
//        h9 = self.tsContent.getTextHeigh(SFONT(13), S_W - 180) + 20
        h10 = self.tsDealDes.getTextHeigh(SFONT(13), S_W - 180) + 20
        //h11 = 60
        
        
        
        
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
    var subFee: Float = 0
    
    ///描述中文
    var des_C: String = ""
    ///描述英文
    var des_E: String = ""
    
    
    
    func updateModel(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = json["nameCn"].stringValue
        self.name_E = json["nameEn"].stringValue
        self.detailImg = json["imageUrl"].stringValue
        self.subFee = json["price"].floatValue
        self.des_C = json["opNameCn"].stringValue
        self.des_E = json["opNameEn"].stringValue
        
    }
    
    
    func updateModel2(json: JSON) {
        self.count = json["buyNum"].intValue
        self.listImg = json["imageUrl"].stringValue
        self.name_C = json["nameCn"].stringValue
        self.name_E = json["nameEn"].stringValue
        self.detailImg = json["imageUrl"].stringValue
        self.subFee = json["dishesPrice"].floatValue
//        self.des_C = json["opNameCn"].stringValue
//        self.des_E = json["opNameEn"].stringValue
        
        
        var t1: String = ""
        var t2: String = ""
        for (idx, jsonData) in json["optionList"].arrayValue.enumerated() {
            
            if idx == 0 {
                t1 = jsonData["nameEn"].stringValue
                t2 = jsonData["nameCn"].stringValue
            } else {
                t1 = t1 + "/" + jsonData["nameEn"].stringValue
                t2 = t2 + "/" + jsonData["nameCn"].stringValue
            }
        }
        
        self.des_C = t2
        self.des_E = t1

        
        
    }
    
    

}
