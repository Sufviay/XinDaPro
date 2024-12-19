//
//  ProjectHeader.swift
//  Demo
//
//  Created by 岁变 on 5/6/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

/**
 工程的通配文件
 将工程中通用的设置写在这里
 */


//MARK: - 关于尺寸
///屏幕bounds
let S_BS = UIScreen.main.bounds
///屏幕宽度
let S_W = UIScreen.main.bounds.width
///屏幕高度
let S_H = UIScreen.main.bounds.height
///屏幕比例
let S_SCALE = S_H / S_W


//MARK: - 关于尺寸适配
///判断手机是否为全屏
var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

///状态栏的高度
let statusBarH = UIApplication.shared.statusBarFrame.size.height

///底部状态栏的高度
let bottomBarH: CGFloat = UIApplication.shared.delegate?.window?!.safeAreaInsets.bottom ?? 0

///判断放大模式
let IS_BIG: Bool = S_W == 320 ? true : false  //放大模式

///比例宽度
let R_W : (CGFloat) -> CGFloat = {width in
    return S_W * width /  375
}

///比例高度
let R_H: (CGFloat) -> CGFloat = {height in
    var H: CGFloat = S_H
    if statusBarH > 20 {
        H = S_H - statusBarH - bottomBarH
    } else {
        H = S_H
    }
    return H * height / 667
}


///比例高
let SA_H: (CGFloat, CGFloat) -> CGFloat = { (w, s) in
    //s 宽高比
    return w / s
}

///比例宽
let SA_W: (CGFloat, CGFloat) -> CGFloat = { (h, s) in
    //s 宽高比
    return h * s
}

///根据UI给的尺寸设置等比例高度
let SET_H: (CGFloat, CGFloat) -> CGFloat = { (nHeight, nWidht) in
    let scale = nWidht / nHeight
    let ruleWidth = S_W * nWidht / 375
    let ruleHeight = ruleWidth / scale
    return ruleHeight
}

///根据UI给的尺寸设置等比例宽度
let SET_W: (CGFloat, CGFloat) -> CGFloat = { (rHeight, rWidht) in
    let scale = rWidht / rHeight
    let ruleHeight = S_H * rHeight / 667
    let ruleWidth =  ruleHeight * scale
    return ruleWidth
}


//MARK: - 关于颜色

//十六进制颜色
let HCOLOR: (String) -> UIColor = { temps in
    //处理数值
    var cString = temps.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
     
    let length = (cString as NSString).length
    //错误处理
    if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
        //返回whiteColor
               
        return UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
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
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}


///GRB颜色
let RCOLOR: (CGFloat, CGFloat, CGFloat) -> UIColor = { (red, green, blue) in
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
}

///GRB加alpha
let RCOLORA: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = { (red, green, blue, alpha) in
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

///随机色
let RANDOMCOLOR: () -> UIColor = {
    return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
}

///渐变色
let GRADIENTCOLOR: (UIColor, UIColor, CGSize) -> UIImage = { (b_color, e_color, size) in
    let gradient = CAGradientLayer()
    let frameAndStatusBar = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    gradient.frame = frameAndStatusBar
    gradient.colors = [b_color.cgColor,  e_color.cgColor]
    let gradientLocations:[NSNumber] = [0.0, 1.0]
    gradient.locations = gradientLocations
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 0)
    UIGraphicsBeginImageContext(gradient.frame.size)
    gradient.render(in: UIGraphicsGetCurrentContext()!)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage!
}


let BACKCOLOR: UIColor = HCOLOR("#FFFFFF")
let MAINCOLOR: UIColor = HCOLOR("#465DFD")
let FONTCOLOR: UIColor = HCOLOR("#080808")
let SFONTCOLOR: UIColor = HCOLOR("#666666")
let HOLDCOLOR: UIColor = HCOLOR("#F8F8F8")


let D_2_STR: (Double) -> String = { num in
    ///高精度计算
    let numberString = String(format: "%.2f", num)
    var outNumber = numberString
    var i = 1

    if numberString.contains("."){
        while i < numberString.count{
            if outNumber.hasSuffix("0") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                i = i + 1
            } else {
                break
            }
        }
        if outNumber.hasSuffix("."){
            outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
        }
        return outNumber
    } else {
        return numberString
    }
}



//MARK: - 关于字体

///设置字体值
let SFONT: (CGFloat) -> UIFont  = { fontnum in
    return UIFont.systemFont(ofSize: fontnum)
}

///设置字体值（加粗）
let BFONT: (CGFloat) -> UIFont = { fontnum in
    return UIFont.boldSystemFont(ofSize: fontnum)
}

//MARK: - 关于图片
///设置本地图片（必须设置否则崩溃 ！）
let LOIMG: (String) -> UIImage = { (name) in
    let img = UIImage(named: name) ?? UIImage()
    return img
}

//MARK: - 关于Block

typealias VoidBlock = (_ any: Any) -> ()
typealias VoidStringBlock = (_ str: String) -> ()
typealias VoidIntBlock = (_ num: Int) -> ()
typealias VoidImgBlock = (_ img: UIImage?) -> ()


//MARK: - 网络
let HTTPTOOl = HttpTool.shared



//"http://api.moneycheers.net/"
//"https://api.foodo2o.com/"


let ISONLINE: Bool = true

let VERID: String = "5"
var BASEURL: String = ISONLINE ? "https://api.foodo2o.com/" : "https://api-test.foodo2o.com/"

