//
//  GroupModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/15.
//

import UIKit
import SwiftyJSON

class GroupModel: NSObject {
    ///分类编码[...]
    var classifyId: String = ""
    ///分组编码[...]
    var groupId: String = ""
    ///父节点编码（一级节点为0）[...]
    var parentId: String = ""
    ///简体名称[...]
    var nameCn: String = ""
    ///繁体名称[...]
    var nameHk: String = ""
    ///英文名称[...]
    var nameEn: String = ""
    ///查询类型（1菜品，2分类），一级时返回null[...]
    var searchType: String = ""
    
    //子分组 当开启了二级分类时需要处理
    var sub_Group: [GroupModel] = []
    
    //分组关联的分类ID数据 searchType == "1"时才有值，且当searchType == "1" 且 关联分类为空时，要对全部进行筛选
    var relClassifyArr: [String] = []
    
    //是否时二级分类
    var isSecond: Bool = false
    
    func updateWithGroup(json: JSON) {
       
        groupId = json["groupId"].stringValue
        parentId = json["parentId"].stringValue
        nameCn = HTMLSTR(json["nameCn"].stringValue)
        nameHk = HTMLSTR(json["nameHk"].stringValue)
        nameEn = HTMLSTR(json["nameEn"].stringValue)
        searchType = json["searchType"].stringValue
        //isClassifty = false
    }
    
    func updateWithClassifty(model: ClassifyModel) {
        classifyId = model.classify
        groupId = model.classify
        nameEn = HTMLSTR(model.classifyNameEn)
        nameHk = HTMLSTR(model.classifyNameHk)
    
    }
    

}
