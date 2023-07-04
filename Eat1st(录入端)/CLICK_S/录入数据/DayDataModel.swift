//
//  DayDataModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/23.
//

import UIKit
import HandyJSON

///用于上报的
class DayDataModel: HandyJSON {


    ///当天现金收入
    var dayIn: String = ""
    ///其他现金收入
    var otherIn: String = ""
    
    
    ///司机支出
    var driverCashOut: String = ""
    ///商品支出
    var goodsCashOut: String = ""
    ///其他支出
    var otherCashOut: String = ""
    
    ///图片列表
    var imagesList: [String] = []
    
    
    ///银行取款
    var bankOut: String = ""
    ///银行存款
    var bankIn: String = ""
    ///取款日期
    var bankOutDate: String = ""
    ///存款日期
    var bankInDate: String = ""
    
    
    ///银行过账工资
    var wagesBank: String = ""
    ///现金工资
    var wagesCash: String = ""
    ///全职员工人数
    var staffFull: String = ""
    ///兼职员工人数
    var staffPart: String = ""
    
    ///时间参数 方便测试
    var date: String = ""
    
    ///供貨商
    var supplierList: [[String: String]] = []
    
    var dayList: [PingTaiModel] = []
    
    
    
    
    var nameList: [String] = []
    
    required init() {}
    
    
}



