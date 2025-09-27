//
//  HolidayModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/6/26.
//

import UIKit
import HandyJSON

class HolidayModel: HandyJSON {

    ///假日日期[...]
    var date: String = ""
    ///开始时间（HH:mm）{...}
    var endTime: String = ""
    ///假日名称[...]
    var holiday: String = ""
    ///店铺假日编码[...]
    var holidayId: String = ""
    ///假日备注[...]
    var remark: String = ""
    ///开始时间（HH:mm）{...}
    var startTime: String = ""
    ///状态（1启用，2禁用）[...]
    var status: String = ""
    
    
    var cell_H: CGFloat = 0
    
    
    required init() {}
    
    
    func uodateHight() {
        
        if remark == "" {
            cell_H = 130
        } else {
            cell_H = 130 + ("remark: \(remark)").getTextHeigh(TXT_1, S_W - 100) + 10
        }
        
    }
    
    
}
