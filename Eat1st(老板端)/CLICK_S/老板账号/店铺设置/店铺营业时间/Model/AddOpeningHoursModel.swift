//
//  AddOpeningHoursModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit
import HandyJSON



class AddTimeSubmitModel: HandyJSON {
    
    var storeTimeId: String = ""
    
    ///名字
    var nameCn: String = ""
    var nameEn: String = ""
    var nameHk: String = ""
    
    ///营业时间
    var startTime: String = ""
    var endTime: String = ""
    
    ///自取营业状态 1开启，2关闭
    var collectStatus: String = ""
    ///外卖营业状态 1开启，2关闭
    var deliverStatus: String = ""
    
    ///自取最大时间
    var collectMax: String = "0"
    ///自取最小时间
    var collectMin: String = "0"
    
    
    ///外卖最大时间
    var deliverMax: String = "0"
    ///外卖最小时间
    var deliverMin: String = "0"

    ///禁用状态（1启用、2禁用）
    var status: String = ""
    
    ///星期列表
    var weekTypeList: [[String: Int]] = []
    
    required init() {}
    
    
}
