//
//  ComplaintsModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/18.
//

import UIKit
import SwiftyJSON

class ComplaintsModel: NSObject {
    
    ///投诉编码
    var plaintId: String = ""
    ///用户姓名
    var name: String = ""
    ///订单编码
    var orderId: String = ""
    ///用户电话
    var phone: String = ""
    ///用户投诉时间
    var createTime: String = ""
    ///投诉次数
    var plaintNum: String = ""
    ///下单次数
    var buyNum: String = ""
    ///用户投诉原因
    var plaintReason: String = ""
    ///用户期望的处理方式
    var userHope: String = ""
    ///配送类型(1外卖，2自取，3堂食）
    var deliveryType: String = ""
    ///配送类型名称
    var deliveryTypeName: String = ""
    ///处理状态 1未处理 2已处理
    var handleType: String = ""
    ///处理方式
    var handleName: String = ""
    ///处理投诉时间
    var handleTime: String = ""
    ///退款方式
    var refundWay: String = ""
    ///退款方式ID
    var handleTypeId: String = ""
    ///退款金额
    var refundPrice: String = ""
    
    ///处理内容
    var replyContent: String = ""
    
    ///用户退款金额 part
    var plaintAmount: String = ""

    ///订单金额。全部
    var orderPrice: String = ""
    
    
    ///下单时间
    var orderTime: String = ""
    
    ///是否收起
    var isShow: Bool = false
    
    ///投诉图片
    var plaintImgs: [String] = []
    
    ///投诉的菜品
    var plaintDishes: [OrderDishModel] = []
    
    ///投诉原因高度
    var reason_H: CGFloat = 0
    ///图片高度
    var picture_H: CGFloat = 0
    ///期望处理方式高度
    var hope_H: CGFloat = 0
    ///处理投诉高度
    var reply_H: CGFloat = 0
    
    
    //Cell高度
    var cell_H: CGFloat = 60 + 75
    
    
    func updateModel(json: JSON) {
        plaintId = json["plaintId"].stringValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        orderId = json["orderId"].stringValue
        plaintNum = json["plaintNum"].stringValue
        buyNum = json["buyNum"].stringValue
        deliveryType = json["deliveryType"].stringValue
        deliveryTypeName = json["deliveryTypeName"].stringValue
        handleType = json["handleType"].stringValue
        createTime = json["createTime"].stringValue
        
    }
    
    
    
    func updateModel_Detail(json: JSON) {
        
        plaintReason = "\(json["plaintReasonName"].stringValue) -- \(deliveryTypeName)"
        reason_H = plaintReason.getTextHeigh(SFONT(14), S_W - 105) + 50
        
        var tArr: [String] = []
        for jsonData in json["plaintImageList"].arrayValue {
            tArr.append(jsonData["url"].stringValue)
        }
        plaintImgs = tArr
        userHope = json["userHopeName"].stringValue
        
        //获取行数
        if plaintImgs.count != 0 {
            let line = Int(ceil(Double(plaintImgs.count) / 5))
            picture_H = (S_W - 60) / 5 + CGFloat(line - 1) * 5 + 10
        }
        
        if userHope != "" {
            hope_H = userHope.getTextHeigh(SFONT(14), S_W - 40) + 25
        }
        
        
        handleName = json["handleResult"]["handleTypeName"].stringValue
        handleTime = json["handleResult"]["handleTime"].stringValue
        refundWay = json["handleResult"]["refundFlowName"].stringValue
        handleTypeId = json["handleResult"]["handleTypeId"].stringValue
        refundPrice = D_2_STR(json["handleResult"]["refundPrice"].doubleValue)
        
        
        if handleTypeId == "2" || handleTypeId == "" {
            handleType = "1"
        } else {
            handleType = "2"
        }
        
        
        if handleType == "1" {
            replyContent = ""
        } else {
            
            if handleTypeId == "4" {
                replyContent = "Reply from the merchant:\n\(handleName)\n\(refundWay)\n\(refundPrice)"
            } else {
                replyContent = "Reply from the merchant:\n\(handleName)"
            }
        }
        
        
        if replyContent != "" {
            reply_H = replyContent.getTextHeigh(SFONT(13), S_W - 70) + 65
        }
    
        cell_H = 135 + reason_H + picture_H + hope_H + reply_H
        
        
        plaintAmount = D_2_STR(json["plaintAmount"].doubleValue)
        orderPrice = D_2_STR(json["orderResult"]["orderPrice"].doubleValue)
        
        var tArr1: [OrderDishModel] = []
        for jsonData in json["plaintDishesList"].arrayValue {
            let model = OrderDishModel()
            model.updateModel(json: jsonData)
            tArr1.append(model)
        }
        plaintDishes = tArr1
        

    }
    
}




class ComplaintsDealWayModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    
    var name_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        id = json["plaintId"].stringValue
        name = json["plaintName"].stringValue
        
        name_H = name.getTextHeigh(BFONT(13), S_W - 80) + 30
        
    }
    
    
    
}
