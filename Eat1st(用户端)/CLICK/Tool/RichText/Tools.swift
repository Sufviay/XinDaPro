//
//  Tools.swift
//  Demo
//
//  Created by 岁变 on 7/4/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit

class Tools: NSObject {
    
    class func getHtmlStrWith(webStr: String) -> String {
        
        var content = webStr.replacingOccurrences(of: "&amp;quot", with: "'")
        
        content = content.replacingOccurrences(of: "&lt;", with: "<")
        
        content = content.replacingOccurrences(of: "&gt;", with: ">")
        
        content = content.replacingOccurrences(of: "&quot;", with: "\"")
        
        let htmlStr = "<html> \n<head> \n<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"/> \n<style type=\"text/css\"> \nbody {font-size:15px;}\n</style> \n</head> \n<body><script type='text/javascript'>window.onload = function(){\nvar $img = document.getElementsByTagName('img');\nfor(var p in  $img){\n$img[p].style.width = '100%%';\n$img[p].style.height ='auto'\n}\n}</script>" + content + "</body></html>"
        return htmlStr
        
    }

}
