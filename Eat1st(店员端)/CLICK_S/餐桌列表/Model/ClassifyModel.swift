//
//  ClassifyModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/16.
//

import UIKit
import SwiftyJSON


class ClassifyDataModel: NSObject {
    /// 店员分类状态（1开启，2关闭）
    var waiterClassifyStatus: String = ""
    
    ///分类列表 分类状态关闭时
    var classifyList_Off: [ClassifyModel] = []
    
    ///分类列表 分类状态开启时一级分类
    var classifyList_On: [ClassifyModel] = []
    
    ///所有的二级分类
    var allClassify_Second: [ClassifyModel] = []
    
    ///1分类、2分类、菜品关系
    var relevanceList: [ClassifyRelevanceModel] = []

    
    func updateModel(json: JSON) {
        
        waiterClassifyStatus = json["waiterClassifyStatus"].stringValue
        
        if waiterClassifyStatus == "2" {
            
            var carr: [ClassifyModel] = []
            for jsonData in json["classifyList"].arrayValue {
                let model = ClassifyModel()
                model.updateModel(json: jsonData)
                carr.append(model)
            }
            classifyList_Off = carr
            
        }
        
        if waiterClassifyStatus == "1" {
            
            var reArr: [ClassifyRelevanceModel] = []
            for jsonData in json["busiClassifyDishesRelList"].arrayValue {
                let model = ClassifyRelevanceModel()
                model.updateModle(json: jsonData)
                reArr.append(model)
            }
            relevanceList = reArr
            
            
            //1级
            var carr1: [ClassifyModel] = []
            //2级
            var carr2: [ClassifyModel] = []
            
            for jsonData in json["busiClassifyList"].arrayValue {
                let model = ClassifyModel()
                model.updateModel(json: jsonData)
                if model.parentId == "0" {
                    model.isFirst = true
                    carr1.append(model)
                } else {
                    model.isFirst = false
                    carr2.append(model)
                }
            }
            
            allClassify_Second = carr2
            
            //根据关系将2级插入1级中
            for c2_model in carr2 {
                //遍历关系
                for r_model in relevanceList {
                    
                    //找到分类ID
                    if r_model.classifyTwoId == c2_model.classify {
                        
                        //通过关系数据中一级分类ID  找到一级分类
                        let c1_ID = r_model.classifyOneId
                        
                        for c1_model in carr1 {
                            if c1_model.classify == c1_ID {
                                //找到一级分类 插入数据 如果二级分类没有 就加入
                                if (c1_model.subList.filter { $0.classify == c2_model.classify }).count == 0 {
                                    c1_model.subList.append(c2_model)
                                }
                            }
                        }
                    }
                }
            }
            
            classifyList_On = carr1
        }
    }
    
    
    
}


class ClassifyModel: NSObject {
    
    var classify: String = ""
    var classifyNameHk: String = ""
    var classifyNameEn: String = ""
    ///0 为一级
    var parentId: String = ""
    ///菜品列数
    var colNum: Int = 0
    ///菜品显示（1编号，2名称，3编号和名称）
    var displayType: String = ""
    
    
    var isFirst: Bool = false
    
    
    ///当开启店员分类是有值，二级分类
    var subList: [ClassifyModel] = []
    
    
    func updateModel(json: JSON) {
        classify = json["classify"].stringValue
        classifyNameHk = json["classifyNameHk"].stringValue
        classifyNameEn = json["classifyNameEn"].stringValue
        parentId = json["parentId"].stringValue
        colNum = json["colNum"].intValue
        displayType = json["displayType"].stringValue
        
    }
    
}


class ClassifyRelevanceModel: NSObject {
    ///一级分类编码[...]
    var classifyOneId: String = ""
    ///二级分类编码[...]
    var classifyTwoId: String = ""
    ///菜品编码[...]
    var dishesId: String = ""
    
    func updateModle(json: JSON) {
        classifyOneId = json["classifyOneId"].stringValue
        classifyTwoId = json["classifyTwoId"].stringValue
        dishesId = json["dishesId"].stringValue
    }
    
}
