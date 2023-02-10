//
//  MessageModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit
import SwiftyJSON

class MessageModel: NSObject {
    
    var id: String = ""
    var title: String = ""
    var createTime: String = ""
    var content: String = "<div style=\"text-align:center;\">\n\tNeed help?\n</div>"
    var isRead: Bool = false
    
    var sikpContent: String = ""
    /// 跳转类型（1无跳转，2店铺，3URL）
    var sikpType: String = ""
    
    var list_H: CGFloat = 0
    
    var t_H_detail: CGFloat = 0
    

    func updateModel(json: JSON) {
        
        self.id = json["messageUserId"].stringValue
        self.title = json["title"].stringValue
        self.createTime = json["createTime"].stringValue
        self.content = json["content"].stringValue
        self.isRead = json["readType"].stringValue == "1" ? false : true
        
        self.sikpType = json["skipType"].stringValue
        self.sikpContent = json["skipContent"].stringValue
        
        let t_H = title.getTextHeigh(BFONT(15), S_W - 200)
        self.list_H = t_H + 15 + 92 + 15
        
        self.t_H_detail = title.getTextHeigh(BFONT(15), S_W - 20 - 15 - 130)
    
    }
    
}
