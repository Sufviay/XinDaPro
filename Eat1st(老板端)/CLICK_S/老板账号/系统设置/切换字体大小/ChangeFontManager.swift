//
//  ChangeFontManager.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/28.
//

import UIKit

class ChangeFontManager: NSObject {

    fileprivate static let kChooseFontSize = "ChooseFontSize"
    
    enum FontSize: String {
        
        case large  = "lar"
        case medium = "med"
        case small =  "sma"
                
        var code: String {
            return rawValue
        }
    }

    static let shared = ChangeFontManager()
    
    var fontsize: FontSize
    
    
    override init() {
        fontsize = ChangeFontManager.currentFontSize()
        super.init()
    }

    
    
    static func currentFontSize() -> FontSize {
        if let font = UserDefaults.standard.string(forKey: kChooseFontSize) {
            return FontSize(rawValue: font)!
        } else {
            return .medium
        }
    }
    
    
    /// 保存所选的语言
    static func saveFontSize() {
        UserDefaults.standard.set(ChangeFontManager.shared.fontsize.rawValue, forKey: ChangeFontManager.kChooseFontSize)
    }
    
    
    static func updateFontSize() {
        ///20
        TIT_20 = S_BFONT(20)
        ///16
        TIT_16 = S_BFONT(16)
        ///14
        TIT_14 = S_BFONT(14)
        ///18
        TIT_18 = S_BFONT(18)
        ///12
        TIT_12 = S_BFONT(12)
        ///10
        TIT_10 = S_BFONT(10)


        ///25
        NUMFONT_1 = S_BFONT(25)
        ///22
        NUMFONT_2 = S_BFONT(22)
        ///15
        NUMFONT_3 = S_BFONT(15)


        ///14
        TXT_14 = S_SFONT(14)
        ///12
        TXT_12 = S_SFONT(12)
        ///10
        TXT_10 = S_SFONT(10)

    }

}
