//
//  CreateModel.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/28.
//

import UIKit
import HandyJSON

class CreateOrderModel: HandyJSON {

    var couponId: String = ""
    ///期望送货时间
    var hopeTime: String = ""
    ///现金付款或在线付款(1：现金、2 卡)
    var paymentMethod: String = ""
    ///收货人姓名
    var recipient: String = ""
    ///收货人地址 拼接好的 
    var recipientAddress: String =  ""
    
    ///地址
    var address: String = ""
    ///门牌号
    var doorNum: String = ""
    
    ///收货人纬度
    var recipientLat: String = ""
    ///收货人经度
    var recipientLng: String =  ""
    ///收货人联系电话
    var recipientPhone: String = ""
    ///收货人邮编
    var recipientPostcode: String = ""
    ///备注
    var remark: String = ""
    ///店铺 ID
    var storeId: String = ""
    ///1：外卖、2：自取
    var type: String = ""
    
    var deskId: String = ""
    ///满赠菜品ID
    var giftDishesId: String = ""
    ///优惠券选择的菜品
    var couponUserDishesId: String = ""
    
    required init() {
        
    }
    
}
