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
            //默认顺序  Live", "Sale Summary", "Booking", "Sale Chart", "Uber Eats", "Deliveroo
            return []
  
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

    

    //判断与系统保存的是否一致
    static func matchLocally(idArr: [Int]) -> Bool {
        
        var titStrArr: [String] = []
            
        for id in idArr {
            if id == 1 {
                titStrArr.append("Live")
            }
            if id == 2 {
                titStrArr.append("Sale Summary")
            }
            if id == 3 {
                titStrArr.append("Booking")
            }
            if id == 4 {
                titStrArr.append("Sale Chart")
            }
            if id == 5 {
                titStrArr.append("Uber Eats")
            }
            if id == 6 {
                titStrArr.append("Deliveroo")
            }

        }
        
        if titStrArr.count == 0 {
            return false
        } else {
            
            if currentTitleArr().count == 0 {
                //系统没有保存过 进行保存
                FirstPageManager.shared.pageDataTitle = titStrArr
                saveFirstPageData()
                return false
            } else {
                //进行对比
                //数量相同
                if currentTitleArr().count == titStrArr.count {
                    //如果获取到的列表每一项本地都有，则视为与本地保持一致
                    
                    var isSame: Bool = true
                    for tit in titStrArr {
                        if !currentTitleArr().contains(tit) {
                            isSame = false
                            break
                        }
                    }
                    return isSame
                } else {
                    FirstPageManager.shared.pageDataTitle = titStrArr
                    saveFirstPageData()
                    return false
                }
            }
        }
    }
}
