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
    public func changeImage()-> UIImage {
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
        //adjustsFontSizeToFitWidth = true
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
    
    ///国际化
    var local: String {
        return MyLanguageManager.shared.valueWithKey(key: self)
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
            str.appendFormat("%02x", result[i])
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
    
    
    /// 字符串的匹配范围 方法一
    ///
    /// - Parameters:
    /// - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    func hw_exMatchStrRange(_ matchStr: String) -> [NSRange] {
        var allLocation = [Int]() //所有起点
        let matchStrLength = (matchStr as NSString).length  //currStr.characters.count 不能正确统计表情

        let arrayStr = self.components(separatedBy: matchStr)//self.componentsSeparatedByString(matchStr)
        var currLoc = 0
        arrayStr.forEach { currStr in
            currLoc += (currStr as NSString).length
            allLocation.append(currLoc)
            currLoc += matchStrLength
        }
        allLocation.removeLast()
        return allLocation.map { NSRange(location: $0, length: matchStrLength) } //可把这段放在循环体里面，同步处理，减少再次遍历的耗时
    }
    
    
    /// -  yyyy-mm-dd 日期转化成英文
    func changeDateInEnglish() -> String {
        
        let strArr = self.components(separatedBy: "-")
        let year = strArr[0]
        let month = strArr[1]
        let day = strArr[2]
    
        var enMon: String = ""
        
        if month == "01" {
            enMon = "Jan"
        }
        
        if month == "02" {
            enMon = "Feb"
        }
        
        if month == "03" {
            enMon = "Mar"
        }
        
        if month == "04" {
            enMon = "Apr"
        }
        
        if month == "05" {
            enMon = "May"
        }
        
        if month == "06" {
            enMon = "Jun"
        }
        
        if month == "07" {
            enMon = "Jul"
        }
        
        if month == "08" {
            enMon = "Aug"
        }
        
        if month == "09" {
            enMon = "Sep"
        }
        
        if month == "10" {
            enMon = "Oct"
        }
        
        if  month == "11" {
            enMon = "Nov"
        }
        
        if month == "12" {
            enMon = "Dec"
        }
        
        return day + " " + enMon + " " + year
        
    }
    
    
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
    
    ///字符串转时间
    func changeDate(formatter: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
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
    
    
    ///获取相对指定日期任意天数的日期
    func getSomeOneDateWith(count: Int) -> [String] {
        
        var tempArr: [String] = []
        
        for num in 0..<count {
            let timeInterval: TimeInterval = Double(num) * 24 * 60 * 60
            let returnDate = self.addingTimeInterval(timeInterval)
            tempArr.append(returnDate.getString("yyyy-MM-dd"))
        }
        return tempArr
    }

    
    ///获取相对指定日期任意天数的日期
    func getSomeOneDateModelWith(count: Int) -> [DateModel] {
        
        var tempArr: [DateModel] = []
        
        for num in 0..<count {
            let timeInterval: TimeInterval = Double(num) * 24 * 60 * 60
            let returnDate = self.addingTimeInterval(timeInterval)
            let model = DateModel()
            model.yearDate = returnDate.getString("yyyy-MM-dd")
            model.monthDate = returnDate.getString("MM-dd")
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: returnDate)
            let shortWeekday = calendar.shortWeekdaySymbols[weekday - 1]            
            model.week = shortWeekday
            model.idx = num
            tempArr.append(model)
        }
        return tempArr
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
    static let userType = "userType"
    static let token = "token"
    static let userID = "userID"
    static let userName = "name"
    static let storeName = "sname"
    static let userRole = "userRole"
    static let userAuth = "userAuth"
    static let accountNum = "accountNum"
    
    
    static let tsToken = "tsToken"

    static let searchHis = "history"

    static let local_lat = "local_lat"
    static let local_lng = "local_lng"
    static let postCode = "postcode"
    static let address = "address"
    static let receiver = "receiver"
    static let phone = "phone"
    static let storeLat = "storeLat"
    static let storeLng = "storeLng"
    
    

    
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

    ///用户类型 (1老板，2配送员，3后厨）
    var userType: String? {
        set {
            set(newValue, forKey: Keys.userType)
        }
        get {
            return string(forKey: Keys.userType)
        }
    }
    
    
    ///角色名 （1老板，2配送员，3店家)
    var userRole: String? {
        set {
            set(newValue, forKey: Keys.userRole)
        }
        get {
            return string(forKey: Keys.userRole)
        }
    }
    
    
    ///用户权限 （1无店铺设置权限，2有店铺设置权限)
    var userAuth: String? {
        set {
            set(newValue, forKey: Keys.userAuth)
        }
        get {
            return string(forKey: Keys.userAuth)
        }
    }

    
    
    ///帐号
    var accountNum: String? {
        set {
            set(newValue, forKey: Keys.accountNum)
        }
        get {
            return string(forKey: Keys.accountNum)
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
    
    

    ///token
    var token: String? {
        set {
            set(newValue, forKey: Keys.token)
        }
        get {
            return string(forKey: Keys.token)
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
    
    ///店铺名称
    var storeName: String? {
        set {
            set(newValue, forKey: Keys.storeName)
        }
        get {
            return string(forKey: Keys.storeName)
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

    ///店铺坐标
    var storeLat: Double? {
        set {
            set(newValue, forKey: Keys.storeLat)
        }
        get {
            return double(forKey: Keys.storeLat)
        }
    }
    
    
    var storeLng: Double? {
        set {
            set(newValue, forKey: Keys.storeLng)
        }
        get {
            return double(forKey: Keys.storeLng)
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
    
    
    /// - 赋值用户信息
//    static func setUserInfo(json: JSON) {
//        UserDefaults.standard.userName = json["user_name"].stringValue
//        UserDefaults.standard.userID = json["id"].stringValue
//        UserDefaults.standard.userHeadImg = json["head_img"].stringValue
//        UserDefaults.standard.userUnit = json["user_level_id"].stringValue
//        UserDefaults.standard.userAddress = json["address"].stringValue
//        UserDefaults.standard.userPhone = json["mobile"].stringValue
//        UserDefaults.standard.serverPhone = json["server_phone"].stringValue
//        UserDefaults.standard.dfhCount = json["to_be_delivered"].intValue
//        UserDefaults.standard.dfkCount = json["pending_payment"].intValue
//        UserDefaults.standard.dshCount = json["to_be_received"].intValue
//        UserDefaults.standard.ywcCount = json["completed"].intValue
//    }
    
    
    /// - 清空
//    static func removeAll() {
//        UserDefaults.standard.isLogin = false
//        UserDefaults.standard.removeObject(forKey: Keys.loginTime)
//        UserDefaults.standard.removeObject(forKey: Keys.token)
//        UserDefaults.standard.removeObject(forKey: Keys.searchHis)
//        //UserDefaults.standard.removeObject(forKey: Keys.userInfo)
//
//        UserDefaults.standard.removeObject(forKey: Keys.userName)
//        UserDefaults.standard.removeObject(forKey: Keys.head_img)
//        UserDefaults.standard.removeObject(forKey: Keys.userUnit)
//        UserDefaults.standard.removeObject(forKey: Keys.mobile)
//        UserDefaults.standard.removeObject(forKey: Keys.server_phone)
//        UserDefaults.standard.removeObject(forKey: Keys.userID)
//        UserDefaults.standard.removeObject(forKey: Keys.address)
//        UserDefaults.standard.removeObject(forKey: Keys.ywcCount)
//        UserDefaults.standard.removeObject(forKey: Keys.dshCount)
//        UserDefaults.standard.removeObject(forKey: Keys.dfhCount)
//        UserDefaults.standard.removeObject(forKey: Keys.dfkCount)
//    }
    
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





