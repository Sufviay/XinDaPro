//
//  DateTool.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/23.
//

import UIKit

class DateTool: NSObject {
    
    
    ///String转Date
    static func dateFromStringByFormatter(dateString: String, formatter: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = formatter
        return format.date(from: dateString) ?? Date()
        
    }
    
    ///date 转 String
    static func stringFromDate(date: Date, formatter: String) -> String  {
        let format = DateFormatter()
        format.dateFormat = formatter
        return format.string(from: date)
    }
    
    
    ///获取年月日对象
    static func getDateComponents(date: Date) -> DateComponents {

        var calendar = Calendar.current
        ///设置每周开始日期是周日
        calendar.firstWeekday = 1
        return calendar.dateComponents([.year, .month, .day, .weekOfYear, .quarter], from: date)
        
    }
    
    
    
    
    
    ///获取某年的周数
    static func getWeekCountBy(year: Int) -> Int {
        
        //获取当前年
        let curYear = self.getDateComponents(date: Date()).year
        
        if curYear == year {
            let comps = self.getDateComponents(date: Date())
            if comps.month == 12 {
                if comps.weekOfYear == 1 {
                    return 52
                } else {
                    return comps.weekOfYear!
                }
            } else {
                return comps.weekOfYear!
            }
            
        } else {
            let yearDate = self.dateFromStringByFormatter(dateString: "\(year)-12-31", formatter: "yyyy-MM-dd")
            let comps = self.getDateComponents(date: yearDate)
            let week = comps.weekOfYear
            if week == 1 {
                return 52
            } else {
                return week ?? 0
            }
        }
    }
    
    
    ///通过年、 周数 计算此周的时间范围
    static func getWeekRangeDateBy(year: Int, week: Int) -> String {
        
        var weekDate = ""
        let timeAxis = "\(year)-06-01 12:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: timeAxis)
        
        var calerdar = Calendar.current
        ///设置一周的第一天是周日
        calerdar.firstWeekday = 1
        calerdar.minimumDaysInFirstWeek = 7
        let comps = calerdar.dateComponents([.weekOfYear, .weekday, .weekdayOrdinal, .year, .month, .day], from: date!)
        
        
        var todayIsWeek: Int = comps.weekOfYear!
        if self.getWeekCountBy(year: year) == 53 {
            todayIsWeek += 1
        }
        
        //获取时间轴是星期几 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
        let todayIsWeekDay: Int = comps.weekday!
        // 计算当前日期和这周的星期日和星期六差的天数
        //firstDiff 星期日相差天数 、 lastDiff 星期六相差天数
        var firstDiff: Int = 0
        var lastDiff: Int = 0
        
        firstDiff = calerdar.firstWeekday - todayIsWeekDay
        lastDiff = 7 - todayIsWeekDay
        
        var firstDayOfWeek: Date = Date(timeInterval: TimeInterval(24 * 60 * 60 * firstDiff), since: date!)
        var lastDayOfWeek: Date = Date(timeInterval: TimeInterval(24 * 60 * 60 * lastDiff), since: date!)
        
        let weekdifference = week - todayIsWeek
        
        firstDayOfWeek = Date(timeInterval: TimeInterval(24 * 60 * 60 * 7 * weekdifference), since: firstDayOfWeek)
        lastDayOfWeek = Date(timeInterval: TimeInterval(24 * 60 * 60 * 7 * weekdifference), since: lastDayOfWeek)
        
        let days = Date().daysBetweenDate(toDate: lastDayOfWeek)
        if days > 0 {
            //lastDayOfWeek 为未来的的日期
            let firstStr = self.stringFromDate(date: firstDayOfWeek, formatter: "MM-dd")
            let lastStr = self.stringFromDate(date: Date(), formatter: "MM-dd")
            weekDate = "\(firstStr)~\(lastStr)"
        } else {
            let firstStr = self.stringFromDate(date: firstDayOfWeek, formatter: "MM-dd")
            let lastStr = self.stringFromDate(date: lastDayOfWeek, formatter: "MM-dd")
            weekDate = "\(firstStr)~\(lastStr)"
        }
        return weekDate
    }
    
    ///年月算天数
    static func getDaysBy(year: Int, month: Int) -> Int {

        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            return 31
        }
        if month == 4 || month == 6 || month == 9 || month == 11 {
            return 30
        }
        if year % 4 == 1 || year % 4 == 2 || year % 4 == 3 {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    
    
    ///年月算天数
    static func getDaysBy(month: Int) -> Int {

        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            return 31
        }
        if month == 4 || month == 6 || month == 9 || month == 11 {
            return 30
        }
        return 29
    }

}
