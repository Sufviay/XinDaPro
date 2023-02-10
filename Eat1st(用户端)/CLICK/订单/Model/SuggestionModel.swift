//
//  SuggestionModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/13.
//

import UIKit
import SwiftyJSON


class SuggestionModel: NSObject {
    ///创建时间
    var createTime: String = ""
    ///姓名
    var name: String = ""
    ///电话
    var phone: String = ""
    ///回复状态  1未回复，2已回复
    var replyStatus: String = ""
    ///回复内容
    var replyContent: String = "Call if you have any questions.Call if you have any questions."
    ///回复时间
    var replyTime: String = "2022-07-13 08:16:43"
    ///用户建议的内容
    var suggestContent: String = ""
    
    var content_H: CGFloat = 0

    var reply_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.suggestContent = json["suggestContent"].stringValue
        self.createTime = json["createTime"].stringValue
        self.replyStatus = json["replyStatus"].stringValue
        self.replyTime = json["replyTime"].stringValue
        self.replyContent = json["replyContent"].stringValue
        
        
        let c_h = self.suggestContent.getTextHeigh(BFONT(14), S_W - 35)
        self.content_H = c_h + 20 + 30
        
        let r_h = self.replyContent.getTextHeigh(SFONT(14), S_W - 60)
        self.reply_H = r_h + 15 + 15 + 35
    }
}
