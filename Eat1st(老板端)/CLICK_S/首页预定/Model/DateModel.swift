//
//  DateModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit

class DateModel: NSObject {
    
    
    var yearDate: String = ""
    var monthDate: String = ""
    var week: String = ""
    var idx = 0

    
    
    func updateModel(date: Date) {
        yearDate = date.getString("yyyy-MM-dd")
        monthDate = date.getString("MM-dd")
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let shortWeekday = calendar.shortWeekdaySymbols[weekday - 1]
        week = shortWeekday
    }
    

    
}
