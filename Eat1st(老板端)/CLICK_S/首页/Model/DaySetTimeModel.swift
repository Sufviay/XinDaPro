//
//  DaySetTimeModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit
import SwiftyJSON
import HandyJSON

class DaySetTimeModel: HandyJSON {

    var weekDay: String  = ""
    var takeBegin: String = ""
    var takeEnd: String = ""
    
    var takeIsOpen: Bool = false
    
    
    var deliveryBegin: String = ""
    var deliveryEnd: String = ""
    
    var deliveryIsOpen: Bool = false
    
    
    var id: String = ""
    
    func updateModel(json: JSON) {
        self.id = json["openId"].stringValue
        self.weekDay = json["weekType"].stringValue
        self.takeBegin = json["collectionStartTime"].stringValue
        self.takeEnd = json["collectionEndTime"].stringValue
        self.deliveryBegin = json["deliveryStartTime"].stringValue
        self.deliveryEnd = json["deliveryEndTime"].stringValue
        
        self.takeIsOpen = json["collectionStatus"].stringValue == "1" ? true : false
        self.deliveryIsOpen = json["deliveryStatus"].stringValue == "1" ? true : false
        
    }

    
    required init() {
    }
}



class StoreOpeningModel: NSObject {
    
    
    ///自取的总状态（1开启，2关闭）
    var z_co_status:  Bool = false
    
    ///外卖的总状态
    var z_de_status: Bool = false

    
    

    ///时间列表
    var timeArr: [DaySetTimeModel] = []
    
    func updateModel(json: JSON) {
        
        self.z_co_status = json["collectionStatus"].stringValue == "1" ? true : false
        self.z_de_status = json["deliveryStatus"].stringValue == "1" ? true : false
        
        var tArr: [DaySetTimeModel] = []
        for jsonData in json["openTimeList"].arrayValue {
            let model = DaySetTimeModel()
            model.updateModel(json: jsonData)
            tArr.append(model)
        }
        self.timeArr = tArr
    }
    
}
