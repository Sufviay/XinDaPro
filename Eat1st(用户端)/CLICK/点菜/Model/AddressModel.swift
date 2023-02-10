//
//  AddressModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/28.
//

import UIKit
import SwiftyJSON

class AddressModel: NSObject {
    
    var lat: String = ""
    var lng: String = ""
    var postcode: String = ""
    var receiver: String = ""
    var overRange: Bool = true
    var address: String = ""
    var id: String = ""
    var phone: String = ""
    var detail: String = ""
    ///是否是默认地址
    var isDefault: Bool = false
    
    ///地址显示的高度
    var address_H: CGFloat = 0
    
    
    func updateModel(json: JSON) {
        self.address = json["address"].stringValue
        self.id = json["addressId"].stringValue
        self.overRange = json["deliverType"].stringValue == "2" ? true : false
        self.isDefault = json["defaultAddr"].stringValue == "2" ? true : false
        self.detail = json["detail"].stringValue

        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
        self.postcode = json["postcode"].stringValue
        self.receiver = json["name"].stringValue
        self.phone = json["phone"].stringValue
        
        
        
        
        let c_str = "\(self.address)\n\(self.detail)"
        let c_h = c_str.getTextHeigh(SFONT(13), S_W - 90)

        let t_str = "\(self.receiver), \(self.phone), \(self.postcode)"
        var t_h: CGFloat = 0
        if self.isDefault {
            t_h = t_str.getTextHeigh(BFONT(14), S_W - 145)
        } else {
            t_h = t_str.getTextHeigh(BFONT(14), S_W - 80)
        }
        
        self.address_H = t_h + c_h + 55

    }
}
