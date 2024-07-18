//
//  OccupyTimeModel.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/11.
//

import UIKit
import SwiftyJSON

class OccupyInfoModel: NSObject {

    ///当前日期[...]
    var localDate: String = ""
    ///外卖结束时间（HH:mm）{...}
    var localTime: String = ""
    ///当前日期后最大可预定天数[...]
    var maxDayNum: Int = 0
    ///时间列表[...]
    var timeList: [OccupyTimeModel] = []
    
    var time_H: CGFloat = 100
    
    func updateModel(json: JSON) {
        localDate = json["localDate"].stringValue
        localTime = json["localTime"].stringValue
        maxDayNum = json["maxDayNum"].intValue
        
        var tarr: [OccupyTimeModel] = []
        for jsondata in json["timeList"].arrayValue {
            let model = OccupyTimeModel()
            model.updateModel(json: jsondata)
            tarr.append(model)
        }
        
        timeList = tarr
        
        if timeList.count != 0 {
            let line: Int = (timeList.count % 3)
            time_H = (CGFloat(line) * 40) + (CGFloat(line - 1) * 10) + 40
        }
    
    }
    
}



class OccupyTimeModel: NSObject {
    ///店铺预定编码[...]
    var reserveId: String = ""
    ///外卖结束时间（HH:mm）{...}
    var reserveTime: String = ""
    ///可预定人数[...]
    var reserveNum: Int = 0
    
    
    func updateModel(json: JSON) {
        reserveId = json["reserveId"].stringValue
        reserveTime = json["reserveTime"].stringValue
        reserveNum = json["reserveNum"].intValue
    }
    
    
}
