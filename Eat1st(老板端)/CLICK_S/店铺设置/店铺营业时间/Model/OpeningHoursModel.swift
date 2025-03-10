//
//  OpeningHoursModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit
import SwiftyJSON



class OpenHoursModel {
    
    var timeList: [WeekOpenTimeModel] = []
    
    func updateModel(json: JSON) {
        ///处理营业时间
        
        timeList.removeAll()
        
        for idx in 1...7 {
            let model = WeekOpenTimeModel()
            model.weekID = String(idx)
            if idx == 1 {
                model.weekName = "Monday"
            }
            if idx == 2 {
                model.weekName = "Tuesday"
            }
            if idx == 3 {
                model.weekName = "Wednesday"
            }
            if idx == 4 {
                model.weekName = "Thursday"
            }
            if idx == 5 {
                model.weekName = "Friday"
            }
            if idx == 6 {
                model.weekName = "Saturday"
            }
            if idx == 7 {
                model.weekName = "Sunday"
            }
            
            timeList.append(model)
        }
        
        //获取所有时间段
        var allTime: [DayTimeModel] = []
        for jsonData in json["openTimeValList"].arrayValue {
            let model = DayTimeModel()
            model.updateModel(json: jsonData)
            
            if model.status == "1" {
                allTime.append(model)
            }
        }
        
        

//        //循环星期列表
//        for jsonData in json["openTimeWeekList"].arrayValue {
//            //获取timeID
//            let timeID = jsonData["storeTimeId"].stringValue
//            //找到相对应的TimeModel
//            if (allTime.filter { $0.timeId == timeID }).count != 0 {
//                let model = allTime.filter { $0.timeId == timeID }[0]
//                
//                ///获取weekID
//                let weekId = jsonData["weekType"].stringValue
//                ///根据weekID将timeModel插入指定位置
//                timeList[(Int(weekId) ?? 0) - 1].timeArr.append(model)
//            }
//        }
        
        
        for model in allTime {
            for jsonData in json["openTimeWeekList"].arrayValue {
                //获取timeID
                let timeID = jsonData["storeTimeId"].stringValue
                if timeID == model.timeId {
                    let weekIdx = jsonData["weekType"].intValue
                    timeList[weekIdx - 1].timeArr.append(model)
                }
            }
        }
    }
}

class WeekOpenTimeModel {
    
    var weekName: String = ""
    var weekID: String = ""
    var timeArr: [DayTimeModel] = []
    
}


class DayTimeModel: NSObject {
    
    //1开启，2关闭
    var deStatus: String = ""
    var coStatus: String = ""
    
    ///启用状态
    var status: String = ""
    
    var deMin: String = ""
    var deMax: String = ""
    
    var coMin: String = ""
    var coMax: String = ""
    
    var timeId: String = ""
    var nameEn: String = ""
    var nameCn: String = ""
    var nameHk: String = ""
    
    var timeName1: String = ""
    var timeName2: String = ""
    
    
    var startTime: String = ""
    var endTime: String = ""
    
    ///时间段设置的时间（星期）
    var timeSelectWeek: [Int] = []
    
    
    
    func updateModel(json: JSON) {
        
        self.timeId = json["storeTimeId"].stringValue
        self.nameEn = json["nameEn"].stringValue
        self.nameCn = json["nameCn"].stringValue
        self.nameHk = json["nameHk"].stringValue
        self.startTime = json["startTime"].stringValue
        self.endTime = json["endTime"].stringValue
        self.deStatus = json["deliverStatus"].stringValue
        self.coStatus = json["collectStatus"].stringValue
        self.status = json["status"].stringValue
        
        self.deMin = json["deliverMin"].stringValue
        self.deMax = json["deliverMax"].stringValue
        self.coMin = json["collectMin"].stringValue
        self.coMax = json["collectMax"].stringValue
        
        let curLa = PJCUtil.getCurrentLanguage()
        if curLa == "en_GB" {
            self.timeName1 = nameEn
            self.timeName2 = nameCn
        } else {
            self.timeName1 = self.nameCn
            self.timeName2 = self.nameEn
        }        
    }

    
    func updateTimeListModel(relationJsonArr: [JSON]) {
        
        ///获取时间段和星期关系列表
        for jsonData in relationJsonArr {
            let timeID = jsonData["storeTimeId"].stringValue
            if timeID == timeId {
                let weekType = jsonData["weekType"].intValue
                if !timeSelectWeek.contains(weekType) {
                    timeSelectWeek.append(weekType)
                }
            }
        }
    }
    
}

