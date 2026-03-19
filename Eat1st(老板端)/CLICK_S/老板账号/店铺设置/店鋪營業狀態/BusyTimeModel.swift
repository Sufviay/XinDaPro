//
//  BusyTimeModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/3/18.
//

import UIKit
import SwiftyJSON

class BusyTimeModel: NSObject {

    ///繁忙编码[...]
    var busyId: String = ""
    ///繁忙名称[...]
    var busyName: String = ""
    ///是否被选择（1是，2否）[...]
    var select: String = ""
    var idx: Int = 1000
    
    
    func updateModel(json: JSON) {
        busyId = json["busyId"].stringValue
        busyName = json["busyName"].stringValue
        select = json["select"].stringValue
    }
    
}




class platformStatusModel: NSObject {
    
    var name: String = ""
    var id: String = ""
    ///ONLINE  OFFLINE
    var onLine: Bool = false
    
    
    func updateUberModel(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        
        let status = json["orderability"]["status"].stringValue
        if status == "ONLINE" {
            onLine = true
        } else {
            onLine = false
        }
        
    }
    
    
    func updateDeliverooModel(json: JSON) {
        id = json["siteId"].stringValue
        name = json["siteName"].stringValue
        
        let status = json["status"].stringValue
        if status == "1" {
            onLine = true
        } else {
            onLine = false
        }
    }
    
}


