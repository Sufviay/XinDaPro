//
//  AttachModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/17.
//

import UIKit
import SwiftyJSON

class AttachModel: NSObject {
    
    ///菜品附加编码[...]
    var attachId: String = ""
    ///菜品附加编号[...]
    var attachCode: String = ""
    /// 菜品附加分类编码[...]
    var classifyId: String = ""
    ///菜品附加繁体中文名称[...]
    var nameHk: String = ""
    ///菜品附加英文名称[...]
    var nameEn: String = ""
    ///价格[...]
    var price: Double = 0
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        attachId = json["attachId"].stringValue
        attachCode = json["attachCode"].stringValue
        classifyId = json["classifyId"].stringValue
        nameHk = json["nameHk"].stringValue
        nameEn = json["nameEn"].stringValue
        price = json["price"].doubleValue
        
        let th = nameEn.getTextHeigh(BFONT(13), S_W - 30 - 15 - 75 - 10 - 15) + nameHk.getTextHeigh(SFONT(11), S_W - 30 - 15 - 75 - 10 - 15)
        
        cell_H = (th + 20) > 50 ? (th + 20) : 50
        
    }
    
}



class AttachClassifyModel: NSObject {
    
    
    ///分类编码[...]
    var classifyId: String = ""
    ///分类繁体中文名称[...]
    var nameHk: String = ""
    ///分类英文名称[...]
    var nameEn: String = ""
    
    ///附加菜品
    var attachList: [AttachModel] = []
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        classifyId = json["classifyId"].stringValue
        nameHk = json["nameHk"].stringValue
        nameEn = json["nameEn"].stringValue
        
        let th = nameEn.getTextHeigh(BFONT(13), 55) + nameHk.getTextHeigh(SFONT(11), 55)
        
        cell_H = (th + 25) > 55 ? (th + 25) : 55
    }
    
    
}
