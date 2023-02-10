//
//  DishesSalesModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit
import SwiftyJSON


class DishesSalesModel: NSObject {
    
    var dishesID: String = ""
    var dishName: String = ""
    var imgUrl: String = ""
    var salesAmount: Double = 0
    var salesNum: Int = 0
    
    var cell_H: CGFloat = 0
    
    func updateModel(json: JSON) {
        
        self.dishesID = json["dishesId"].stringValue
        self.dishName = json["dishesName"].stringValue
        self.imgUrl = json["imageUrl"].stringValue
        self.salesAmount = json["salesAmount"].doubleValue
        self.salesNum = json["salesNum"].intValue
        
        let n_h = dishName.getTextHeigh(BFONT(15), S_W - 20 - 125)
        self.cell_H = (n_h + 45) > 65 ? (n_h + 45) : 65

    }

}
