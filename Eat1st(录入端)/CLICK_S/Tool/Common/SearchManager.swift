//
//  SearchManager.swift
//  JinJia
//
//  Created by 岁变 on 7/20/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit

class SearchManager {
    
    ///获取搜索历史
    open class func getHistoryArr() -> [String] {
        //获取搜索数组
        if UserDefaults.standard.searchHisArr == nil {
            UserDefaults.standard.searchHisArr = []
        }
        return UserDefaults.standard.searchHisArr as! [String]
    }
    
    ///开始搜索
    open class func doSearch(_ msg: String) {
        
        //获取搜索数组
        if UserDefaults.standard.searchHisArr == nil {
            let searchArr: [String] = [msg]
            UserDefaults.standard.searchHisArr = searchArr
        } else {
            
            let tempArr: [String] = UserDefaults.standard.searchHisArr as! [String]
            var hisArr: [String] = tempArr.filter { $0 != msg }
            hisArr.insert(msg, at: 0)
            
            if hisArr.count > 5 {
                UserDefaults.standard.searchHisArr = Array(hisArr[0...5])
            } else {
                UserDefaults.standard.searchHisArr = hisArr
            }
        }
    }
    
    
    ///删除历史记录
    open class func deleteHistory() {
        UserDefaults.standard.searchHisArr = []
    }
    
}
