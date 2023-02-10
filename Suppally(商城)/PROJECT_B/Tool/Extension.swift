//
//  File.swift
//  PROJECT_B
//
//  Created by 肖扬 on 2023/1/7.
//

import Foundation



class PJCUtil: NSObject {
    
    
    
    //MARK: - 字典转JSON
    static func convertDictionaryToString(dict:[String:Any]?) -> String {
        
        var result:String = ""
        
        if dict != nil {
            
            do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                let jsonData = try JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
              
         
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    result = JSONString
                }
         
            } catch {
                result = ""
            }
        }
        
        return result
    }

}



//MARK: - 关于按钮
extension UIButton {
    
    ///设置基础样式
    public func setCommentStyle(_ frame: CGRect, _ titleStr: String, _ titleColor: UIColor, _ strFont: UIFont, _ backColor: UIColor) {
        self.frame = frame
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = strFont
        self.backgroundColor = backColor
    }
}

//MARK: - 关于UILable的拓展方法
extension UILabel {
    
    ///设置基础样式
    public func setCommentStyle(_ color: UIColor, _ mfont: UIFont, _ alignment: NSTextAlignment) {
        self.textColor = color
        self.textAlignment = alignment
        self.font = mfont
        /**
         lineBreakMode 属性用于Label文字的省略形式
         */
        self.lineBreakMode = .byTruncatingTail
    }
}
