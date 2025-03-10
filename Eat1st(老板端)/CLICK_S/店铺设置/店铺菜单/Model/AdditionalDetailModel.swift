//
//  AdditionalDetailModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/27.
//

import UIKit
import HandyJSON

class AdditionalDetailModel: HandyJSON {
    
    
    ///菜品名
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    
    ///分类编码
    var classifyId: Int64 = 0
    var classifyNameCn: String = ""
    var classifyNameEn: String = ""
    var classifyNameHk: String = ""


    
    var price: String = "0"
    
    var attachId: Int64 = 0
    var attachCode: String = ""
    
    var dishName1: String = ""
    var dishName2: String = ""
    var classifyStr: String = ""
    /// 菜品种类（1食物，2饮料, 3奶茶）
    var dishesKind: String = ""
    
    ///1启用 2禁用
    var statusId: String = ""
    
    required init() { }
    
    
    
    func updateModle() {
        
        let curL = PJCUtil.getCurrentLanguage()

        if curL == "en_GB" {
            dishName1 = nameEn == "" ? "--" : nameEn
            dishName2 = nameHk == "" ? "--" : nameHk
        } else {
            dishName1 = nameHk == "" ? "--" : nameHk
            dishName2 = nameEn == "" ? "--" : nameEn
        }
        
        self.classifyStr = self.dealMsg(enStr: classifyNameEn, hkStr: classifyNameHk)
    }

    
    ///处理信息
    private func dealMsg(enStr: String, hkStr: String) -> String {
        var msgStr = ""
        let curL = PJCUtil.getCurrentLanguage()
        
        if enStr == "" && hkStr == "" {
            msgStr = "--"
        }

        if hkStr != "" && enStr == "" {
            msgStr = hkStr
        }
        if enStr != "" && hkStr == "" {
            msgStr = enStr
        }
        if enStr != "" && hkStr != "" {
            if curL == "en_GB" {
                msgStr = enStr + "\n" + hkStr
            } else {
                msgStr = hkStr + "\n" + enStr
            }
        }
        return msgStr
    }
    
}
