//
//  OccupyModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/11.
//

import UIKit
import SwiftyJSON
import HandyJSON



class OccupyModel: HandyJSON {
    
    ///店铺预定编码[...]
    var reserveId: String = ""
    ///联系人[...]
    var name: String = UserDefaults.standard.userName ?? ""
    ///联系电话[...]
    var phone: String = UserDefaults.standard.userPhone ?? ""
    ///邮箱
    var email: String = UserDefaults.standard.userEmail ?? ""
    
    ///预定日期
    var date: String = ""
    ///预定人数[...]
    var reserveNum: Int = 2
    
    
    
    
    required init(){}

}
