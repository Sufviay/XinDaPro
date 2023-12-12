//
//  ReportModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/1.
//

import UIKit
import SwiftyJSON


class OrderNumModel: NSObject {
    
    ///已完成数量
    var success: Int = 0
    ///待出餐数量
    var waitCook: Int = 0
    ///待接单数量
    var waitReceive: Int = 0
    ///待配送数量
    var waitSend: Int = 0
    ///待送达数量
    var waitTake: Int = 0
    ///骑手数量
    var riderNum: Int = 0
    ///桌子数量
    var deskEmptyNum: Int = 0
    ///占用的桌子数量
    var deskOccupyNum: Int = 0
    
    
    
    func updateModel(json: JSON) {
        self.success = json["success"].intValue
        self.waitCook = json["waitCook"].intValue
        self.waitReceive = json["waitReceive"].intValue
        self.waitSend = json["waitSend"].intValue
        self.waitTake = json["waitTake"].intValue
        self.riderNum = json["riderNum"].intValue
        self.deskEmptyNum = json["deskEmptyNum"].intValue
        self.deskOccupyNum = json["deskOccupyNum"].intValue
        
        
    }
    
}



class ReportModel: NSObject {

    
    
    //MARK: - 成功
    
    
    //订单数
    
    ///成功的总订单数量
    var orderNum_All: Int = 0
    ///card的总订单数
    var cardOrderNum_All: Int = 0
    ///cash的总订单数
    var cashOrderNum_All: Int = 0
    ///POS的总订单数
    var posOrderNum_All: Int = 0

    ///App 订单数量
    var appOrderNum: Int = 0
    ///商家订单数量
    var machOrderNum: Int = 0
    ///外卖订单数量
    var deOrderNum: Int = 0
    ///自取订单数量
    var coOrderNum: Int = 0
    ///堂食订单数
    var dineOrderNum: Int = 0
    
    
    

    //订单金额
    
    ///成功的总订单金额
    var orderSum_All: Double = 0
    
    ///card的订单总金额
    var cardOrderSum_All: Double = 0
    ///cash的订单总金额
    var cashOrderSum_All: Double = 0
    ///POS的订单总金额
    var posOrderSum_All: Double = 0

    
    
    ///App 订单金额
    var appOrderSum: Double = 0
    ///商家订单金额
    var machOrderSum: Double = 0
    ///外卖订单金额
    var deOrderSum: Double = 0
    ///自取订单金额
    var coOrderSum: Double = 0
    ///堂食订单金额
    var dineOrderSum: Double = 0
    
    
    

    
    ///配送费用
    var deliveryFee: Double = 0
    ///堂食服务费
    var dineServiceFee: Double = 0
    ///平台服务费
    var platServiceFee: Double = 0
    
    
    ///打包费
    var packFee: Double = 0
    ///优惠金额
    var discountPrice: Double = 0
    ///cash小费
    var tipCashPrice: Double = 0
    ///pos小费
    var tipPosPrice: Double = 0
    
    
    //MARK: - 拒接订单

    var refundNum: Int = 0
    var refundSum: Double = 0
    
    
    
    
    
    //MARK: - 未成功
    //订单数
    
    ///未成功的总订单数量
    var unOrderNum_All: Int = 0
    
    ///用户取消的订单数
    var userCancelOrderNum: Int = 0
    ///商家取消的订单数
    var busiCancelOrderNum: Int = 0
    
    ///App 订单数量
    var unAppOrderNum: Int = 0
    ///商家订单数量
    var unMachOrderNum: Int = 0
    ///外卖订单数量
    var unDeOrderNum: Int = 0
    ///自取订单数量
    var unCoOrderNum: Int = 0
    ///堂食订单数量
    var unDineOrderNum: Int = 0

    
    //订单金额
    ///未成功的总订单金额
    var unOrderSum_All: Double = 0
    ///商家取消的订单金额
    var busiCancelOrderSum: Double = 0
    ///用户取消的订单金额
    var userCacnelOrderSum: Double = 0

    ///App 订单金额
    var unAppOrderSum: Double = 0
    ///商家订单金额
    var unMachOrderSum: Double = 0
    ///自取订单金额
    var unDeOrderSum: Double = 0
    ///外卖订单金额
    var unCoOrderSum: Double = 0
    ///堂食订单金额
    var unDineOrderSum: Double = 0

    


    
    
    
    
    func updateModel(json: JSON) {
        
        
        //成功的订单数据
        
        self.cardOrderNum_All = json["cardNum"].intValue
        self.cashOrderNum_All = json["cashNum"].intValue
        self.posOrderNum_All = json["posNum"].intValue
        
        self.appOrderNum = json["appNum"].intValue
        self.machOrderNum = json["businessNum"].intValue
        self.deOrderNum = json["deliveryNum"].intValue
        self.coOrderNum = json["collectionNum"].intValue
        self.dineOrderNum = json["dineInNum"].intValue
        
        self.orderNum_All = json["allNum"].intValue
        
        
        
        
        
        //成功订单金额数据
        self.cardOrderSum_All = json["cardPrice"].doubleValue
        self.cashOrderSum_All = json["cashPrice"].doubleValue
        self.posOrderSum_All = json["posPrice"].doubleValue
        
        self.appOrderSum = json["appPrice"].doubleValue
        self.machOrderSum = json["businessPrice"].doubleValue
        self.deOrderSum = json["deliveryPrice"].doubleValue
        self.coOrderSum = json["collectionPrice"].doubleValue
        self.dineOrderSum = json["dineInPrice"].doubleValue
        
        self.orderSum_All = json["allPrice"].doubleValue
        
        self.deliveryFee = json["deliveryFee"].doubleValue
        self.dineServiceFee = json["dineServiceFee"].doubleValue
        self.platServiceFee = json["platServiceFee"].doubleValue
        self.packFee = json["packFee"].doubleValue
        self.tipCashPrice = json["tipCashPrice"].doubleValue
        self.tipPosPrice = json["tipPosPrice"].doubleValue
        self.discountPrice = json["noPayPrice"].doubleValue
        
        
        //拒接
        self.refundNum = json["refundNum"].intValue
        self.refundSum = json["refundPrice"].doubleValue
        
        
        //未成功订单数据
        self.userCancelOrderNum = json["userCancelNum"].intValue
        self.busiCancelOrderNum = json["busiCancelNum"].intValue
        
        self.unAppOrderNum = json["unAppNum"].intValue
        self.unMachOrderNum = json["unBusinessNum"].intValue
        self.unDeOrderNum = json["unDeliveryNum"].intValue
        self.unCoOrderNum = json["unCollectionNum"].intValue
        //self.unDineOrderNum = json[""]
        self.unOrderNum_All = unDeOrderNum + unCoOrderNum
        
        
        //未成功的订单金额数据
        self.userCacnelOrderSum = json["userCancelPrice"].doubleValue
        self.busiCancelOrderSum = json["busiCancelPrice"].doubleValue
        self.unAppOrderSum = json["unAppPrice"].doubleValue
        self.unMachOrderSum = json["unBusinessPrice"].doubleValue
        self.unCoOrderSum = json["unCollectionPrice"].doubleValue
        self.unDeOrderSum = json["unDeliveryPrice"].doubleValue
        
        self.unOrderSum_All = unDeOrderSum + unCoOrderSum
    }
    
}
