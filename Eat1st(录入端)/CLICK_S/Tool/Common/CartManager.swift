//
//  CartManager.swift
//  JinJia
//
//  Created by 岁变 on 7/22/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit
import SwiftyJSON


class CartGoodsModel: NSObject {

    ///购物车ID
    var cart_id: String = ""
    ///规格id
    var key_id: String = ""
    ///数量
    var cart_num: String = ""
    ///商品id
    var good_id: String = ""
    ///商品名称
    var name: String = ""
    ///图片
    var attachment: String = ""
    ///规格价格
    var sku_price: String = ""
    ///规格名称
    var sku_name: String = ""
    ///1未删除
    var status: String = ""
    ///邮费
    var postage: String = ""

    func updateModel(json: JSON) {
        self.cart_id = json["cart_id"].stringValue
        self.cart_num = json["cart_num"].stringValue
        self.key_id = json["key_id"].stringValue
        self.good_id = json["good_id"].stringValue
        self.name = json["name"].stringValue
        self.attachment = json["attachment"].stringValue
        self.sku_price = json["sku_price"].stringValue
        self.sku_name = json["sku_name"].stringValue
        self.status = json["status"].stringValue
        self.postage = json["postage"].stringValue
    }
    
}



class CartStoreModel: NSObject {
    
    ///商铺ID
    var shop_id: String = ""
    ///店铺名
    var shop_name: String = ""
    ///商品
    var goods: [CartGoodsModel] = []
    
    ///选择的商品的总价
    var goodsPrice: Float = 0
    ///店铺商品的备注
    var remark: String = ""
    ///配送方式
    var psWay: String = "普通配送"
    ///运费
    var psMoney: Float = 0
    ///优惠券价格
    var yhqMoney: String = ""
    
    
    func updateModel(json: JSON) {
        self.shop_id = json["sid"].stringValue
        self.shop_name = json["sname"].stringValue
        
        var tempArr: [CartGoodsModel] = []
        for jsonData in json["goods"].arrayValue {
            let model = CartGoodsModel()
            model.updateModel(json: jsonData)
            tempArr.append(model)
        }
        self.goods = tempArr
    }

}



class CartManager: NSObject {
    
    //管理类型 0 结算  1 删除
    private var managerType: String = "0"

    private var cartModelArr: [CartStoreModel] = [] {
        didSet {
            var tCount: Int = 0
            for arr in cartModelArr {
                tCount += arr.goods.count
            }
            self.allGoodsCount = tCount
        }
    }

    //每次点击的时候要更新选中状态
    var selectIndexArr: [IndexPath] = []
    
    ///商品总数
    private var allGoodsCount: Int = 0
    
    ///全选状态
    var isSelectAll: Bool = false
    
    ///选中数量
    var selectCount: Int = 0
    
    ///选中的商品总金额
    var allMoney: Float = 0.00
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateManager(dataArr: [CartStoreModel], indexArr: [IndexPath]) {
        self.cartModelArr = dataArr
        self.selectIndexArr = indexArr
        if indexArr.count == 0 {
            allMoney = 0.00
            selectCount = 0
            isSelectAll = false
        }
    }
    
    ///根据选中indexPath更新数据
    func updateCartDataBy(index: IndexPath) {

        if self.selectIndexArr.contains(index) {
            //取消选中
            if index.row == 0 {
                //取消店铺
                self.selectIndexArr = self.selectIndexArr.filter { $0.section != index.section }
            } else {
                //取消商品
                let tIndex = IndexPath(row: 0, section: index.section)
                self.selectIndexArr = self.selectIndexArr.filter { $0 != index && $0 != tIndex  }
            }
            self.isSelectAll = false
    
        } else {
            //点击选中
            if index.row == 0 {
                //选中店铺
                let goodsArr: [CartGoodsModel] = cartModelArr[index.section].goods
                self.selectIndexArr = selectIndexArr.filter { $0.section != index.section }
                self.selectIndexArr.append(index)
                
                for (idx, _) in goodsArr.enumerated() {
                    let tIndex = IndexPath(row: idx + 1, section: index.section)
                    self.selectIndexArr.append(tIndex)
                }
            } else {
                //选中商品 如果该商铺所有商品被选择则勾选上店铺
                self.selectIndexArr.append(index)
                let tArr = selectIndexArr.filter { $0.section == index.section }
                if tArr.count == cartModelArr[index.section].goods.count {
                    //该商铺商品全部被选中
                    let tIndex = IndexPath(row: 0, section: index.section)
                    self.selectIndexArr.append(tIndex)
                }
            }
        
            if selectIndexArr.count == allGoodsCount + cartModelArr.count {
                //全部选中
                self.isSelectAll = true
            } else {
                self.isSelectAll = false
            }
        }

        countNumberAndMoney()
    }

    ///点击全选按钮更新数据
    func updateCartDataBy(selectAll: Bool) {
        if selectAll {
            var tArr: [IndexPath] = []
            for (idx, model) in cartModelArr.enumerated() {
                
                tArr.append(IndexPath(row: 0, section: idx))
                for (tidx, _) in model.goods.enumerated() {
                    tArr.append(IndexPath(row: tidx + 1, section: idx))
                }
            }
            self.selectIndexArr = tArr
        } else {
            self.selectIndexArr = []
        }
        self.isSelectAll = selectAll
        countNumberAndMoney()
        
    }
    
    ///点击更改数量源更新数据
    func updateCartDataByChangeNum(cartModelArr: [CartStoreModel]) {
        self.cartModelArr = cartModelArr
        countNumberAndMoney()
    }
    
    ///点击删除更新数据
    func updateCartDataByDelete(cartModelArr: [CartStoreModel]) {
        self.cartModelArr = cartModelArr
        self.selectIndexArr = []
        countNumberAndMoney()
        self.isSelectAll = false
    }
    
    ///通过选中的购物车商品生成购物车id  多个“，“拼接
    func getCartIds() -> String {
        let tArr = self.selectIndexArr.filter { $0.row != 0 }
        var returnStr: String = ""
        for (idx, index) in tArr.enumerated() {
            let model = cartModelArr[index.section].goods[index.row - 1]
            if idx == 0 {
                returnStr = model.cart_id
            } else {
                returnStr = returnStr + "," + model.cart_id
            }
        }
        return returnStr
    }
    
    ///通过选中的下标生成确认订单也买呢需要的数据model
    func getConfirmOrderData() -> [CartStoreModel] {
        
        //先将indexPath.section相同的进行归类
        var tempArr: [[IndexPath]] = []
    
        let tIndexArr = self.selectIndexArr.filter { $0.row != 0 }
    
        for index in tIndexArr {
            
            let sectionCount = index.section

            if tempArr.count == 0 {
                let arr: [IndexPath] = [index]
                tempArr.append(arr)
            } else {
                
                var isAppend: Bool = false
                for (idx, var arr) in tempArr.enumerated() {
                    if arr[0].section == sectionCount {
                        arr.append(index)
                        tempArr.replaceSubrange(idx..<(idx + 1), with: [arr])
                        isAppend = true
                    }
                }
                if !isAppend {
                    let tarr: [IndexPath] = [index]
                    tempArr.append(tarr)

                }
            }
        }
        
        print(tempArr[0].count)
        
        var returnArr: [CartStoreModel] = []
        
        for arr in tempArr {
            let model = cartModelArr[arr[0].section]
            var price: Float = 0
            var yfPrice: Float = 0
            var goodsArr: [CartGoodsModel] = []
            for index in arr {
                let goods = cartModelArr[index.section].goods[index.row - 1]
                let goodsPrice = (Float(goods.sku_price) ?? 0) * (Float(goods.cart_num) ?? 0) + (Float(goods.postage) ?? 0)
                price += goodsPrice
                yfPrice += Float(goods.postage) ?? 0
                goodsArr.append(goods)
            }
            model.goodsPrice = price
            model.goods = goodsArr
            model.psMoney = yfPrice
            returnArr.append(model)
        }
        return returnArr
    }
    
    
    ///计算数量和价钱
    private func countNumberAndMoney() {
        let tArr = self.selectIndexArr.filter { $0.row != 0 }
        var tempCount: Int = 0
        var tempMoney: Float = 0.00
        for index in tArr {
            let model = cartModelArr[index.section].goods[index.row - 1]
            if model.status == "1" {
                //有效商品
                tempCount += 1
                let price = (Float(model.cart_num) ?? 0) * (Float(model.sku_price) ?? 0)
                tempMoney += price
            }
        }
        self.allMoney = tempMoney
        
        if managerType == "0" {
            //结算状态
            self.selectCount = tempCount
        }
        if managerType == "1" {
            //删除状态
            self.selectCount = tArr.count
        }
    }
}
