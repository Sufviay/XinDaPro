//
//  FirstPageManager.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/24.
//

import UIKit

class FirstPageManager: NSObject {
    
    fileprivate static let kChangePageTitle = "ChangePageTitle"
    fileprivate static let kChangePageShow = "ChangePageShow"
    
    
    static let shared = FirstPageManager()
    
    var pageDataTitle: [String]
    var pageDataShow: [Bool]
    
    
    override init() {
        pageDataTitle = FirstPageManager.currentTitleArr()
        pageDataShow = FirstPageManager.currentShowArr()
        super.init()
    }
    
    
    ///
    static func currentTitleArr() -> [String] {
        if let pageArr = UserDefaults.standard.array(forKey: kChangePageTitle) {
            return pageArr as! [String]
            
        } else {
            //默认顺序
            return ["Live", "Sale Summary", "Booking", "Sale Chart", "Uber Eats", "Deliveroo"]
  
        }
    }
    
    
    static func currentShowArr() -> [Bool] {
        if let pageArr = UserDefaults.standard.array(forKey: kChangePageShow) {
            return pageArr as! [Bool]
            
        } else {
            //默认顺序
            return [true, true, true, true, true, true]
  
        }
    }


    
    
    
    /// 保存所选的语言
    static func saveFirstPageData() {
        UserDefaults.standard.set(FirstPageManager.shared.pageDataTitle, forKey: FirstPageManager.kChangePageTitle)
        UserDefaults.standard.set(FirstPageManager.shared.pageDataShow, forKey: FirstPageManager.kChangePageShow)
    }


}
