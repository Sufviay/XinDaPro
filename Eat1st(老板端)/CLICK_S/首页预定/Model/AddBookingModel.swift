//
//  AddBookingModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit
import HandyJSON

class AddBookingModel: HandyJSON {

    ///预定日期[...]
    var date: String = ""
    
    ///联系人[...]
    var name: String = ""
    ///联系电话[...]
    var phone: String = ""
    ///店家预定编码[...]
    var reserveId: String = ""
    ///预定人数[...]
    var reserveNum: Int = 2
    
    
    required init() {
        
    }
    
}
