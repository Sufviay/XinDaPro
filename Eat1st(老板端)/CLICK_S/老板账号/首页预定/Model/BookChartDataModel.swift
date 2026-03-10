//
//  BookChartDataModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit
import SwiftyJSON

class BookChartDataModel: NSObject {
    
    ///行数
    var lineCount: Int = 0

    ///可预约时间model
    var timeArr: [ChartBookTimeModel] = []
    
    ///晚餐人数 17:00 以后
    var dinnerNum: Int = 0
    ///午餐人数 17:00 以前
    var lunchNum: Int = 0
    ///早餐
    var breakfastNum: Int = 0
    
    
    func updateModel(json: JSON) {
        
        dinnerNum = json["data"]["dinnerNum"].intValue
        lunchNum = json["data"]["lunchNum"].intValue
        breakfastNum = json["data"]["breakfastNum"].intValue
        
        var tarr: [ChartBookTimeModel] = []
        
        
        //var bookInfoArr: [BookingContentModel] = []
        
        for jsonData in json["data"]["userReserveList"].arrayValue {
            
            let model = BookingContentModel()
            model.updateModel(json: jsonData)
            
            
            var isHave: Bool = false
            for tmodel in tarr {
                
                if model.reserveTime == tmodel.reserveTime {
                    //找到了就添加进去
                    tmodel.bookingArr.append(model)
                    isHave = true
                    break
                }
            }
            
            if !isHave {
                //没有预定时间，就创建一个新的预定时间, 并且添加进去
                let timeModel = ChartBookTimeModel()
                timeModel.reserveTime = model.reserveTime
                timeModel.reserveId = model.reserveId
                timeModel.bookingArr.append(model)
                tarr.append(timeModel)

            }
            
            
            
//            if (tarr.filter { $0.reserveId == model.reserveId }).count == 0 {
//
//                let timeModel = ChartBookTimeModel()
//                timeModel.reserveTime = model.reserveTime
//                timeModel.reserveId = model.reserveId
//                timeModel.bookingArr.append(model)
//                tarr.append(timeModel)
//            } else {
//                //包含
//                
//                
//            }
//            
//            bookInfoArr.append(model)
        }
        
        
        
//        
//        for jsonData in json["data"]["storeReserveList"].arrayValue {
//            
//            let model = ChartBookTimeModel()
//            model.reserveTime = jsonData["reserveTime"].stringValue
//            model.reserveId = jsonData["reserveId"].stringValue
//            
//            model.bookingArr = bookInfoArr.filter { $0.reserveId == model.reserveId}
//            
//            tarr.append(model)
//        }
        
        timeArr = tarr
        
        let arr: [Int] = timeArr.map { $0.bookingArr.count }
        
        if let count = arr.max() {
            lineCount = count
        } else {
            lineCount = 0
        }
        
    }

}


class ChartBookTimeModel: NSObject {
    
    var reserveTime: String = ""
    var reserveId: String = ""
    
    var bookingArr: [BookingContentModel] = []
    
}

