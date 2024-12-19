//
//  Extension.swift
//  Demo
//
//  Created by 岁变 on 5/6/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit
import SwiftyJSON
import CommonCrypto


//MARK: - 关于颜色的拓展方法
extension UIColor {
    
    ///通过颜色的十六进制来进行颜色的设置 不需要“#”
    convenience init(hexString: String) {
        
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
         
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
         
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
         
        let rString = (cString as NSString).substring(with: range)
         
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
         
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
         
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    ///颜色转为图片
    open func changeImage()-> UIImage {
        let rect = CGRect(x: 0,y: 0,width: 1,height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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



enum ZGJButtonImageEdgeInsetsStyle {
    case top /// image在上，label在下
    case left /// image在左，label在右
    case bottom /// image在下，label在上
    case right /// image在右，label在左
}

//MARK: - 关于按钮
extension UIButton {
    
    ///设置基础样式
    open func setCommentStyle(_ frame: CGRect, _ titleStr: String, _ titleColor: UIColor, _ strFont: UIFont, _ backColor: UIColor) {
        self.frame = frame
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = strFont
        self.backgroundColor = backColor
    }
    
    
    func imagePosition(at style: ZGJButtonImageEdgeInsetsStyle, space: CGFloat) {
         guard let imageV = imageView else { return }
         guard let titleL = titleLabel else { return }
         //获取图像的宽和高
         let imageWidth = imageV.frame.size.width
         let imageHeight = imageV.frame.size.height
         //获取文字的宽和高
        let labelWidth  = titleL.intrinsicContentSize.width
         let labelHeight = titleL.intrinsicContentSize.height
         
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
         //UIButton同时有图像和文字的正常状态---左图像右文字，间距为0
         switch style {
         case .left:
             //正常状态--只不过加了个间距
             imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
             labelEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right: -space * 0.5)
         case .right:
             //切换位置--左文字右图像
             //图像：UIEdgeInsets的left是相对于UIButton的左边移动了labelWidth + space * 0.5，right相对于label的左边移动了-labelWidth - space * 0.5
             imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space * 0.5, bottom: 0, right: -labelWidth - space * 0.5)
             labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space * 0.5, bottom: 0, right: imageWidth + space * 0.5)
         case .top:
             //切换位置--上图像下文字
             /**图像的中心位置向右移动了labelWidth * 0.5，向上移动了-imageHeight * 0.5 - space * 0.5
              *文字的中心位置向左移动了imageWidth * 0.5，向下移动了labelHeight*0.5+space*0.5
             */
             imageEdgeInsets = UIEdgeInsets(top: -imageHeight * 0.5 - space * 0.5, left: labelWidth * 0.5, bottom: imageHeight * 0.5 + space * 0.5, right: -labelWidth * 0.5)
             labelEdgeInsets = UIEdgeInsets(top: labelHeight * 0.5 + space * 0.5, left: -imageWidth * 0.5, bottom: -labelHeight * 0.5 - space * 0.5, right: imageWidth * 0.5)
         case .bottom:
             //切换位置--下图像上文字
             /**图像的中心位置向右移动了labelWidth * 0.5，向下移动了imageHeight * 0.5 + space * 0.5
              *文字的中心位置向左移动了imageWidth * 0.5，向上移动了labelHeight*0.5+space*0.5
              */
             imageEdgeInsets = UIEdgeInsets(top: imageHeight * 0.5 + space * 0.5, left: labelWidth * 0.5, bottom: -imageHeight * 0.5 - space * 0.5, right: -labelWidth * 0.5)
             labelEdgeInsets = UIEdgeInsets(top: -labelHeight * 0.5 - space * 0.5, left: -imageWidth * 0.5, bottom: labelHeight * 0.5 + space * 0.5, right: imageWidth * 0.5)
         }
         self.titleEdgeInsets = labelEdgeInsets
         self.imageEdgeInsets = imageEdgeInsets
     }

    
}

//MARK: - 关于View
extension UIView {
    
    ///切指定的圆角
    func cornerWithRect(rect: CGRect, byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

//MARK: - 关于String
extension String {
    
    
    //处理转义
    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)

    }
    
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    
    ///字符串 长度
    var length: Int {
        return self.count
    }
    
    ///返回text的高度
    func getTextHeigh(_ font:UIFont,_ width:CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let dic = [NSAttributedString.Key.font: font]
        let stringSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return stringSize.height
    }
    
    ///计算text宽度
    func getTextWidth(_ font: UIFont, _ height: CGFloat) -> CGFloat {
        let size = CGSize(width: 1000, height: height)
        let dic = [NSAttributedString.Key.font: font]
        let stringSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return stringSize.width
    }
    
    
    ///计算富文本字符串高度
    func getAttributedTextHeight(_ font: UIFont, _ width: CGFloat, _ lineSpace: CGFloat) -> CGFloat  {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpace
        
        let attributedStr = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: font])
        
        let size = attributedStr.boundingRect(with: CGSize(width: width, height: 10000), options: .usesLineFragmentOrigin, context: nil).size
        return size.height
    }
    
    
    ///计算字符串的行数
    func getStringLine(font: UIFont, strWidth: CGFloat) -> Int {
        let h = self.getTextHeigh(font, strWidth)
        return Int(ceil(h / font.lineHeight))
    }
    
    
    
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }

    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    /// 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    /// 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
    ///md5加密
    func md5Encrypt() -> String {
        let utf8_str = self.cString(using: .utf8)
        let str_len = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digest_len = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digest_len)
        CC_MD5(utf8_str, str_len, result)
        let str = NSMutableString()
        for i in 0..<digest_len {
            str.appendFormat("%02X", result[i])
        }
        result.deallocate()
        return str as String
    }

    ///隐藏手机号
    func hidePhoneNumber() -> String {
        if self.count < 5 {
            var str = ""
            for _ in 0 ..< self.count {
                str += "*"
            }
            return str
        } else {
            //替换一段内容，两个参数：替换的范围和用来替换的内容
            let start = self.index(self.startIndex, offsetBy: (self.count - 5) / 2)
            let end = self.index(self.startIndex, offsetBy: (self.count - 5) / 2 + 4)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            return self.replacingCharacters(in: range, with: "****")
        }
    }
    
    //调整UILabel、UITextView等文本设置行间距、字间距
    func attributedString(font: UIFont, textColor: UIColor, lineSpaceing: CGFloat, wordSpaceing: CGFloat) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        let attributes = [
                NSAttributedString.Key.font             : font,
                NSAttributedString.Key.foregroundColor  : textColor,
                NSAttributedString.Key.paragraphStyle   : style,
                NSAttributedString.Key.kern             : wordSpaceing]
            
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        // 设置某一范围样式
        // attrStr.addAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, value: <#T##Any#>, range: <#T##NSRange#>)
        return attrStr
    }
    
        
}

//MARK: - 关于Date
extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    // 获取 时间戳
    var timeStampInt: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    
    
    /// 转换时间 yyyy/MM/dd
    func getString(_ fomat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fomat
        return formatter.string(from: self)
    }
    
    ///获取相对指定日期任意天数的日期
    func getSomeOneDateWith(day: Double) -> Date {
        let timeInterval: TimeInterval = day * 24 * 60 * 60
        let returnDate = self.addingTimeInterval(timeInterval)
        return returnDate
    }
    
    ///获取两个日期相差的天数
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
    ///获取当前年到指定年的数组
    func getYearStrArr(yearCount: Int) -> [String] {
        var tempArr: [String] = []
        
        //获取当前年
        let currentyear: Int = Int(self.getString("yyyy")) ?? 1994
        
        
        for num in 0..<yearCount {
            let yearStr = String(currentyear - num)
            tempArr.append(yearStr)
        }
        return tempArr
    }
    
    ///根据年月获取天数
    func getDayStrArr(year: String, month: String) -> [String] {
        var tempArr: [String] = []
        var dateComponets = DateComponents()
        dateComponets.year = Int(year)
        dateComponets.month = Int(month)
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponets)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        let dayCount = range.count
        
        for num in 1..<dayCount + 1 {
            tempArr.append(String(num))
        }
        return tempArr
    }
    


}


//MARK: - 关于UserDefaults

public struct Keys {
    
    static let verID: String = "verID"
    
    static let isLogin = "isLogin"
    static let giftId = "giftId"
    static let isAgree = "isAgree"
    static let token = "token"
    static let userID = "userID"
    static let userName = "name"
    static let userEmail = "userEmail"
    static let userPhone = "userPhone"
    
    static let tsToken = "tsToken"

    static let searchHis = "history"

    static let local_lat = "local_lat"
    static let local_lng = "local_lng"
    static let postCode = "postcode"
    static let address = "address"
    static let doorNum = "doorNum"
    static let receiver = "receiver"
    static let phone = "phone"
    
    

    
    //关于通知中心
    ///用于显示/隐藏筛选排序栏
    static let sxpxStatus = "sxpxStatus"

}


extension UserDefaults {
    
    
    ///版本号
    var verID: String? {
        set {
            set(newValue, forKey: Keys.verID)
        }
        get {
            return string(forKey: Keys.verID)
        }
    }
    

    
    ///登录状态
    var isLogin: Bool {
        set {
            set(newValue, forKey: Keys.isLogin)
        }
        get {
            return bool(forKey: Keys.isLogin)
        }
    }

    
    ///是否同意了法律条文
    var isAgree: Bool {
        set {
            set(newValue, forKey: Keys.isAgree)
        }
        get {
            return bool(forKey: Keys.isAgree)
        }
    }

    

    ///token
    var token: String? {
        set {
            set(newValue, forKey: Keys.token)
        }
        get {
            return string(forKey: Keys.token)
        }
    }
    
    
    ///推送Token
    var tsToken: String? {
        set {
            set(newValue, forKey: Keys.tsToken)
        }
        get {
            return string(forKey: Keys.tsToken)
        }
    }
    
    ///userID
    var userID: String? {
        set {
            set(newValue, forKey: Keys.userID)
        }
        get {
            return string(forKey: Keys.userID)
        }
    }

    ///userName
    var userName: String? {
        set {
            set(newValue, forKey: Keys.userName)
        }
        get {
            return string(forKey: Keys.userName)
        }
    }
    
    var userEmail: String? {
        set {
            set(newValue, forKey: Keys.userEmail)
        }
        get {
            return string(forKey: Keys.userEmail)
        }
    }
    
    var userPhone: String? {
        set {
            set(newValue, forKey: Keys.userPhone)
        }
        get {
            return string(forKey: Keys.userPhone)
        }
    }
    
    
    ///搜索历史数组
    var searchHisArr: [Any]? {
        set {
            set(newValue, forKey: Keys.searchHis)
        }
        get {
            return array(forKey: Keys.searchHis)
        }
    }
    
    ///纬度
    var local_lat: String? {
        set {
            set(newValue, forKey: Keys.local_lat)
        }
        get {
            return string(forKey: Keys.local_lat)
        }
    }
    
    ///经度
    
    var local_lng: String? {
        set {
            set(newValue, forKey: Keys.local_lng)
        }
        get {
            return string(forKey: Keys.local_lng)
        }
    }
    
    ///地址
    var address: String? {
        set {
            set(newValue, forKey: Keys.address)
        }
        get {
            return string(forKey: Keys.address)
        }
    }
    
    ///邮编
    var postCode: String? {
        set {
            set(newValue, forKey: Keys.postCode)
        }
        get {
            return string(forKey: Keys.postCode)
        }
    }
    
    
    ///门牌号
    var doorNum: String? {
        set {
            set(newValue, forKey: Keys.doorNum)
        }
        get {
            return string(forKey: Keys.doorNum)
        }
    }

    
    ///收货人
    var receiver: String? {
        set {
            set(newValue, forKey: Keys.receiver)
        }
        get {
            return string(forKey: Keys.receiver)
        }
    }
    
    ///电话
    var phone: String? {
        set {
            set(newValue, forKey: Keys.phone)
        }
        get {
            return string(forKey: Keys.phone)
        }
    }
    
    //礼品券
    var giftID: String? {
        set {
            set(newValue, forKey: Keys.giftId)
        }
        get {
            return string(forKey: Keys.giftId)
        }
    }
    

    
    ///用户信息
    /**
     id    number
     user_name       名字
     mobile          手机号
     head_img        头像
     user_level_id   单位
     sex             性别
     server_phone    客服电话
     address         地址
     pending_payment 待付款订单数量
     to_be_delivered 待发货订单数量
     to_be_received  待收货订单数量
     completed       已完成订单数量
     */
    
//    var userInfo: [String: Any]? {
//        set {
//            set(newValue, forKey: Keys.userInfo)
//        }
//        get {
//            return dictionary(forKey: Keys.userInfo)
//        }
//    }

    
    /// - 清空
    static func removeAll() {
        UserDefaults.standard.isLogin = false
        UserDefaults.standard.removeObject(forKey: Keys.token)

        UserDefaults.standard.removeObject(forKey: Keys.userName)
        UserDefaults.standard.removeObject(forKey: Keys.userEmail)
        UserDefaults.standard.removeObject(forKey: Keys.userPhone)
        UserDefaults.standard.removeObject(forKey: Keys.giftId)
    }
    
}


extension UIDevice {
   var modelName: String {
      var systemInfo = utsname()
      uname(&systemInfo)
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      let identifier = machineMirror.children.reduce("") { identifier, element in
         guard let value = element.value as? Int8, value != 0 else { return identifier }
         return identifier + String(UnicodeScalar(UInt8(value)))
      }
      switch identifier {
         //TODO:iPod touch
         case "iPod1,1":                                       return "iPod touch"
         case "iPod2,1":                                       return "iPod touch (2nd generation)"
         case "iPod3,1":                                       return "iPod touch (3rd generation)"
         case "iPod4,1":                                       return "iPod touch (4th generation)"
         case "iPod5,1":                                       return "iPod touch (5th generation)"
         case "iPod7,1":                                       return "iPod touch (6th generation)"
         case "iPod9,1":                                       return "iPod touch (7th generation)"

         //TODO:iPad
         case "iPad1,1":                                       return "iPad"
         case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
         case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
         case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
         case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
         case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
         case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
         case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
         case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"

         //TODO:iPad Air
         case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
         case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
         case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
         case "iPad13,1", "iPad13,2":                          return "iPad Air (4rd generation)"

         //TODO:iPad Pro
         case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
         case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
         case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch)"
         case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
         case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
         case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch)"
         case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
         case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
         case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
         case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"

         //TODO:iPad mini
         case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
         case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad Mini 2"
         case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad Mini 3"
         case "iPad5,1", "iPad5,2":                            return "iPad Mini 4"
         case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
         case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"

         //TODO:iPhone
         case "iPhone1,1":                               return "iPhone"
         case "iPhone1,2":                               return "iPhone 3G"
         case "iPhone2,1":                               return "iPhone 3GS"
         case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
         case "iPhone4,1":                               return "iPhone 4s"
         case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
         case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
         case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
         case "iPhone7,2":                               return "iPhone 6"
         case "iPhone7,1":                               return "iPhone 6 Plus"
         case "iPhone8,1":                               return "iPhone 6s"
         case "iPhone8,2":                               return "iPhone 6s Plus"
         case "iPhone8,4":                               return "iPhone SE (1st generation)"
         case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
         case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
         case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
         case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
         case "iPhone10,3", "iPhone10,6":                return "iPhone X"
         case "iPhone11,8":                              return "iPhone XR"
         case "iPhone11,2":                              return "iPhone XS"
         case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
         case "iPhone12,1":                              return "iPhone 11"
         case "iPhone12,3":                              return "iPhone 11 Pro"
         case "iPhone12,5":                              return "iPhone 11 Pro Max"
         case "iPhone12,8":                              return "iPhone SE (2nd generation)"
         case "iPhone13,1":                              return "iPhone 12 mini"
         case "iPhone13,2":                              return "iPhone 12"
         case "iPhone13,3":                              return "iPhone 12 Pro"
         case "iPhone13,4":                              return "iPhone 12 Pro Max"
         case "iPhone14,4":                              return "iPhone 13 mini"
         case "iPhone14,5":                              return "iPhone 13"
         case "iPhone14,2":                              return "iPhone 13 Pro"
         case "iPhone14,3":                              return "iPhone 13 Pro Max"
         case "iPhone14,6":                              return "iPhone SE (3rd generation)"

         case "AppleTV5,3":                              return "Apple TV"
         case "i386", "x86_64":                          return "iPhone Simulator"
         default:                                        return identifier
      }
   }
}


extension UITextField {
    
    //设置Placeholder的颜色
    func setPlaceholder(_ str: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString.init(string: str, attributes: [.foregroundColor: color])
    }
    
}




