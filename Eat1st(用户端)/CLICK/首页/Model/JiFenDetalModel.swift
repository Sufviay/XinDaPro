//
//  JiFenDetalModel.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/9.
//

import UIKit
import SwiftyJSON


class JiFenDetalModel: NSObject {
    
    var name: String = ""
    
    var time: String = ""
    ///积分流水类型（1订单消费，2积分兑换，3投诉扣减，4平台补回，5过期失效）
    var type: String = ""
    ///积分数量（当pointsType=2，3，5为负，其他为正） ,
    var number: Int = 0
    
    ///积分使用数量
    var useNum: Int = 0
    
    var orderID: String = ""
    
    
    func updateModel(json: JSON) {
        self.name = json["pointsTypeName"].stringValue
        self.time = json["createTime"].stringValue
        self.type = json["pointsType"].stringValue
        self.number = json["pointsNum"].intValue
        self.useNum = json["useNum"].intValue
        self.orderID = json["orderId"].stringValue
    }
    

}
