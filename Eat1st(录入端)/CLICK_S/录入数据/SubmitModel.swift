//
//  SubmitModel.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/13.
//

import UIKit
import HandyJSON

class SubmitModel: HandyJSON {
    
    var inList: [InModel] = []
    var outWLList: [OutModel] = []
    var outWSList: [OutModel] = []
    var outWOList: [OutModel] = []
    var outQRList: [OutModel] = []
    var outQUList: [OutModel] = []
    var outQOList: [OutModel] = []

    var nameList: [String] = []
    
    
    
    func setOutModel() {
        for idx in 1..<9 {
            let model = OutModel()
            model.code = "LB0\(idx)"
            outWLList.append(model)
        }
        
        for idx in 0..<2 {
            let model = OutModel()
            if idx == 0 {
                model.code = "S01PFT"
            }
            if idx == 1 {
                model.code = "S02HHO"
            }
            outWSList.append(model)
        }
        
        for idx in 0..<2 {
            let model = OutModel()
            if idx == 0 {
                model.code = "O01PTC"
            }
            if idx == 1 {
                model.code = "O02TRA"
            }
            outWOList.append(model)
        }
        
        for idx in 0..<4 {
            let model = OutModel()
            if idx == 0 {
                model.code = "R01RNT"
            }
            if idx == 1 {
                model.code = "R02BNR"
            }
            if idx == 2 {
                model.code = "R03SEC"
            }
            if idx == 3 {
                model.code = "R04CTX"
            }
            outQRList.append(model)
        }
        
        for idx in 0..<3 {
            let model = OutModel()
            if idx == 0 {
                model.code = "U01ELE"
            }
            if idx == 1 {
                model.code = "U02GAS"
            }
            if idx == 2 {
                model.code = "U03WAT"
            }
            outQUList.append(model)
        }
        
        
        for idx in 0..<6 {
            let model = OutModel()
            if idx == 0 {
                model.code = "O01TEL"
            }
            if idx == 1 {
                model.code = "O02INT"
            }
            if idx == 2 {
                model.code = "O03WAS"
            }
            if idx == 3 {
                model.code = "O04BKC"
            }
            if idx == 4 {
                model.code = "O05BKC"
            }
            if idx == 5 {
                model.code = "O05ITC"
            }

            outQOList.append(model)
        }

        
    }
    
    
    
    required init() {}
}



class InModel: HandyJSON {
    
    ///平台ID
    var paltId: Int64 = 0
    var o: String = ""
    var b: String = ""
    var b1: String = ""
    var b2: String = ""
    var c: String = ""
    var tt: String = ""
    var name: String = ""

    required init() {}
    
}

class OutModel: HandyJSON {
    
    var code: String = ""
    var b: String = ""
    var c: String = ""
    var from: String = ""
    var to: String = ""
    
    required init() {}
}
