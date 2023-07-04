//
//  ReviewsModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/25.
//

import UIKit
import SwiftyJSON

class ReviewsModel: NSObject {
    
    ///姓名
    var name: String = ""
    ///评论时间
    var time: String = ""
    ///评论内容
    var plContent: String = ""
    ///头像
    var headUrl: String = ""
    ///菜品评分
    var dishCount: Float = 0
    ///服务评分
    var serviceCount: Float = 0
    ///配送评分
    var deliveryCount: Float = 0
    
    ///是否回复
    var isReply: Bool = false
    ///回复内容
    var replyContent: String = ""
    ///回复人姓名
    var replyName: String = ""
    ///回复时间
    var replyTime: String = ""
    
    ///评价的订单类型 1外卖。2自取  3外卖
    var orderType: String = ""
    
    
    

    
    func updateModel(json: JSON) {
        self.name = json["nickName"].stringValue == "" ? "Name" : (json["nickName"].stringValue)
        self.time = json["createTime"].stringValue
        self.plContent = json["content"].stringValue
        self.headUrl = json["photoUrl"].stringValue
        self.dishCount = json["dishesNum"].floatValue
        self.serviceCount = json["serviceNum"].floatValue
        self.deliveryCount = json["deliveryNum"].floatValue
        self.isReply = json["replyStatus"].stringValue == "1" ? false : true
        self.replyContent = json["replyContent"].stringValue
        self.replyName = json["replyName"].stringValue
        self.replyTime = json["replyTime"].stringValue
        self.orderType = json["deliveryType"].stringValue
        
    }
}
