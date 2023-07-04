//
//  FeeTypeResultModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/30.
//

import UIKit
import SwiftyJSON


class FeeTypeResultModel: NSObject {
    
    var platTypeList: [PingTaiModel] = []
    
    var dayResultList: [DateModel] = []
    
    
    static let sharedInstance = FeeTypeResultModel()
    
    func updateModel(json: JSON) {
        
        platTypeList.removeAll()
        dayResultList.removeAll()
        
        for jsonData in json["data"]["platTypeList"].arrayValue {
            let model = PingTaiModel()
            model.name = jsonData["name"].stringValue
            model.platId = jsonData["id"].int64Value
            platTypeList.append(model)
        }
        
        
        for jsonData in json["data"]["dayResultList"].arrayValue {
            let model = DateModel()
            model.updateModel(json: jsonData, platList: platTypeList)
            dayResultList.append(model)
        }
    }
    
    func cleanPlatData() {
        for model in platTypeList {
            model.card = ""
            model.cash = ""
            model.total = ""
            model.orders = ""
        }
    }

}



class DateModel: NSObject {
    
    var stepCount: Int = 0
    
    var date: String = ""
    
    ///每天的是否填写（1否，2是）
    var writeDay: Bool = false
    ///是否是周六（1否，2是）
    var saturday: Bool = false
    ///周六是否填写（1否，2是）
    var writeSat: Bool = false
    
    var nameList: [String] = []
    
    
    func updateModel(json: JSON, platList: [PingTaiModel]) {
        self.date = json["date"].stringValue
        self.writeDay = json["writeDay"].stringValue == "1" ? false : true
        self.saturday = json["saturday"].stringValue == "1" ? false : true
        self.writeSat = json["writeSat"].stringValue == "1" ? false : true
        
        if saturday {
            stepCount = platList.count + 5
            if !writeDay {
                //未填写
                nameList = ["sat1", "sat2", "sat3"]
                for model in platList {
                    nameList.append(model.name)
                }
                nameList += ["Cash In", "Cash Out"]
            }
        } else {
            stepCount = platList.count + 2
            if !writeDay {
                //未填写
                for model in platList {
                    nameList.append(model.name)
                }
                nameList += ["Cash In", "Cash Out"]
            }
        }
        
    }
}
