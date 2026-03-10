//
//  ReviewsModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/19.
//

import UIKit
import SwiftyJSON


class ReviewsModel: NSObject {

    ///评价总数
    var evaluateNum: String = ""
    ///店铺评价总分
    var evaluateScore: Int = 0
    ///评价列表
    var evaluateList: [ReviewListModel] = []
    
    
    func updateModel(json: JSON) {
        self.evaluateNum = json["evaluateNum"].stringValue
        self.evaluateScore = Int(ceil(json["evaluateScore"].floatValue))
        
        var tArr: [ReviewListModel] = []
        for jsonData in json["evaluateList"].arrayValue {
            let model = ReviewListModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        
        self.evaluateList = tArr
    }
    
    
}



class ReviewListModel: NSObject {
    
    ///评价编码
    var evaluateId: String = ""
    ///用户姓名
    var name: String = ""
    ///用户电话
    var phone: String = ""
    ///菜品分数
    var dishesNum: Float = 0
    ///服務分数
    var serviceNum: Float = 0
    ///配送/自取时效评分
    var deliveryNum: Float = 0
    ///评价内容
    var content: String = ""
    ///评价时间
    var createTime: String = ""
    ///订单编码
    var orderId: String = ""
    ///当日流水号
    var orderDayNum: String = ""
    ///下单时间
    var orderTime: String = ""
    /// 配送类型（1外卖，2自取，3堂食）
    var deliveryType: String = ""
    ///配送类型名称
    var deliveryTypeName: String = ""
    ///投诉次数
    var plaintNum: String = ""
    ///下单次数
    var buyNum: String = ""
    ///回复状态（1未回复，2已回复）
    var replyStatus: String = ""
    ///回复人姓名
    var replyName: String = ""
    ///回复人内容
    var replyContent: String = ""
    ///回复时间
    var replyTime: String = ""
    ///送达时间
    var deliveryTime: String = ""
    
    
    ///评论高度
    var content_H: CGFloat = 0
    
    ///回复高度
    var reply_H: CGFloat = 0
    
    ///cell的高度
    var cell_H: CGFloat = 0
    
    
    func updateModel(json: JSON) {
        self.deliveryTime = json["deliveryTime"].stringValue
        self.replyTime = json["replyTime"].stringValue
        self.replyContent = json["replyContent"].stringValue
        self.replyName = json["replyName"].stringValue
        self.replyStatus = json["replyStatus"].stringValue
        self.buyNum = json["buyNum"].stringValue
        self.plaintNum = json["plaintNum"].stringValue
        self.deliveryTypeName = json["deliveryTypeName"].stringValue
        self.deliveryType = json["deliveryType"].stringValue
        self.orderTime = json["orderTime"].stringValue
        self.orderDayNum = json["orderDayNum"].stringValue
        self.orderId = json["orderId"].stringValue
        self.createTime = json["createTime"].stringValue
        self.content = json["content"].stringValue
        self.deliveryNum = json["deliveryNum"].floatValue
        self.serviceNum = json["serviceNum"].floatValue
        self.dishesNum = json["dishesNum"].floatValue
        self.phone = json["phone"].stringValue
        self.name = json["name"].stringValue
        self.evaluateId = json["evaluateId"].stringValue
        
        self.content_H = content.getTextHeigh(SFONT(14), S_W - 40) + 25
        
        let repStr = "Reply content\n\(replyContent)"
        self.reply_H = repStr.getTextHeigh(SFONT(13), S_W - 70) + 40
        
        
        if content == "" {
            
            if replyStatus == "1" {
                cell_H = 200
            } else {
                cell_H = 200 + reply_H
            }
        } else {
            if replyStatus == "1" {
                cell_H = 200 + content_H
            } else {
                cell_H = 200 + content_H + reply_H
            }
        }
        
        
    }
    
    
    func updateModelByReply(reply: String) {
        replyStatus = "2"
        replyContent = reply
        
        let repStr = "Reply content\n\(replyContent)"
        reply_H = repStr.getTextHeigh(SFONT(13), S_W - 70) + 40
        
        if content == "" {
            cell_H = 200 + reply_H
        } else {
            cell_H = 200 + content_H + reply_H
        }
    }
        
}
