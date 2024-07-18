//
//  DeskModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/12.
//

import UIKit
import SwiftyJSON



enum DeskStatus {
    
    ///空的
    case Empty
    ///餐桌使用中
    case Process
    ///结算
    case Settlement
    ///禁用
    case Occupied
    
}


class DeskModel: NSObject {
    
    ///餐桌Id
    var deskId: String = ""
    ///餐桌名称
    var deskName: String = ""
    ///未出餐及以前的数量
    var workNum: Int = 0
    ///待结算数量
    var settleNum: Int = 0
    ///占用状态 (1未占用，2占用中）
    var occupyType: String = ""
    ///结算状态（1未结算，2结算中）
    var settleType: String = ""
    ///预付金额
    var advancePrice: Double = 0
    ///容纳人数
    var dinersNum: Int = 0
    
    ///餐桌状态
    var deskStatus: DeskStatus = .Empty

    
    func updateModel(json: JSON) {
        deskId = json["deskId"].stringValue
        deskName = json["deskName"].stringValue
        workNum = json["workNum"].intValue
        settleNum = json["settleNum"].intValue
        occupyType = json["occupyType"].stringValue
        settleType = json["settleType"].stringValue
        advancePrice = json["advancePrice"].doubleValue
        dinersNum = json["dinersNum"].intValue
        
        
        if workNum + settleNum == 0 {
            if occupyType == "2" {
                //禁用
                deskStatus = .Occupied
            }
            if occupyType == "1" {
                //空餐做
                deskStatus = .Empty
                
            }
        } else {
            if settleType == "1" {
                //使用中
                deskStatus = .Process
            }
            if settleType == "2" {
                //结算中
                deskStatus = .Settlement
            }
        }
    }
}
