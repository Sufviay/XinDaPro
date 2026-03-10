//
//  StoreModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/1/26.
//

import UIKit
import SwiftyJSON

class StoreModel: NSObject {
    
    ///老板账号权限（1无店铺设置权限，2有店铺设置权限）[...]
    var auth: String = ""
    ///店铺编码[...]
    var storeId: String = ""
    ///店铺名称[...]
    var storeName: String = ""
    
    
    func updateModel(json: JSON) {
        auth = json["auth"].stringValue
        storeId = json["storeId"].stringValue
        storeName = json["storeName"].stringValue
    }
    
}
