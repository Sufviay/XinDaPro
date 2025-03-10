//
//  MyLanguageManager.swift
//  Eat1st-Store
//
//  Created by 肖扬 on 2024/12/25.
//

import UIKit

class MyLanguageManager: NSObject {
    
    
    fileprivate static let kChooseLanguageKey = "ChooseLanguage"
    
    ///单例
    static let shared = MyLanguageManager()
    
    
    enum Language: String {
        
        case Chinese = "zh-Hans"
        case English = "en"
                
        var code: String {
            return rawValue
        }
    }

    var language: Language
    
    override init() {
        
        //切换语言
        object_setClass(Foundation.Bundle.main, Bundle.self)
        language = MyLanguageManager.currentLanguage()
        super.init()
    }
    
    
    
    /// 获取上次保存的语言,如果从未保存过，获取系统的语言，默认英文
    static func currentLanguage() -> Language {
        if let langString = UserDefaults.standard.string(forKey: kChooseLanguageKey) {
            return Language(rawValue: langString)!
            
        } else {
            //获取系统的语言
            
            if let lang = Locale.preferredLanguages.first {
                if lang.contains("zh") {
                    return .Chinese
                } else if lang.contains("en") {
                    return .English
                } else {
                    return .English
                }
            } else {
                return .English
            }
        }
    }

    
    /// 保存所选的语言
    static func saveLanguage() {
        UserDefaults.standard.set(MyLanguageManager.shared.language.rawValue, forKey: MyLanguageManager.kChooseLanguageKey)
    }

    func valueWithKey(key: String!) -> String {
        let str = NSLocalizedString(key, comment: "")
        return str
    }

}



private var bundleByLanguageCode: [String: Foundation.Bundle] = [:]

extension MyLanguageManager.Language {
    var bundle: Foundation.Bundle? {
        /// 存起来, 避免一直创建
        if let bundle = bundleByLanguageCode[code] {
            return bundle
        } else {
            let mainBundle = Foundation.Bundle.main
            if let path = mainBundle.path(forResource: code, ofType: "lproj"),
                let bundle = Foundation.Bundle(path: path) {
                bundleByLanguageCode[code] = bundle
                return bundle
            } else {
                return nil
            }
        }
    }
}
/// 首先, 我们会在启动时设置成我们自己的Bundle,这样就可以做到,当使用时会调用这个方法.
class Bundle: Foundation.Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = MyLanguageManager.shared.language.bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
