//
//  LocalizationTool.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/21.
//

import UIKit

enum Language {
    ///英文
    case english
    ///简体中文
    case Simp_Chinese
    ///繁体中文
    case Trad_Chinese
    
}




class LocalizationTool {
    
    static let shared = LocalizationTool()
    let defaults = UserDefaults.standard
    var bundle: Bundle?
    var currentlanguage: Language = .english
    
    
    
    func checkLanguage() {
        currentlanguage = getLanguage()
    }
    
    func getLanguage() -> Language {
        
        if let lang = Locale.preferredLanguages.first {
            if lang.hasPrefix("zh") {
                if lang.contains("Hant") || lang.contains("Trad") {
                    return .Trad_Chinese
                }
                return .Simp_Chinese
            } else if lang.contains("en") {
                return .english
            } else {
                return .Trad_Chinese
            }
        } else {
            return .Trad_Chinese
        }
    }
    
    func valueWithKey(key: String) -> String {
        let bundle = LocalizationTool.shared.bundle
        if let bundle = bundle {
            return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "", comment: "")
        } else {
            return NSLocalizedString(key, comment: "")
        }
    }

}


extension String {
    var localized: String {
        return LocalizationTool.shared.valueWithKey(key: self)
    }
}



