//
//  StoreIncomeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/3.
//

import UIKit
import SwiftyJSON

class StoreCommissionModel: NSObject {
    
    ///已结佣金[...]
    var commission: Double = 0
    ///店铺code[...]
    var storeCode: String = ""
    ///店铺id[...]
    var storeId: String = ""
    ///店铺名称[...]
    var storeName: String = ""
    
    func updateModel(json: JSON) {
        commission = json["commission"].doubleValue
        storeCode = json["storeCode"].stringValue
        storeId = json["storeId"].stringValue
        storeName = json["storeName"].stringValue
    }
    
}



class StoreIncomeCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    private let namelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_14, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Dragon Boat Bletchley"
        return lab
    }()
    
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_blue")
        return img
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TIT_12, .left)
        lab.text = "Commission"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .right)
        lab.text = "99999"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_10, .right)
        lab.text = "£"
        return lab
    }()
    
    
    
    override func setViews() {
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
        }
        
        
        contentView.addSubview(namelab)
        namelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-60)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalTo(namelab)
            $0.left.equalTo(namelab.snp.right).offset(10)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(50)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-5)
        }
        
    }
    
    
    func setCellData(model: StoreCommissionModel) {
        
        
        moneyLab.text = D_2_STR(model.commission)
        namelab.text = model.storeName
        
        //獲取店名字的寬度
        let w = model.storeName.getTextWidth(TIT_14, 15)
        
        if w > (S_W - 120) {
            nextImg.snp.remakeConstraints {
                $0.centerY.equalTo(namelab)
                $0.left.equalTo(namelab.snp.right).offset(10)
            }
        } else {
            nextImg.snp.remakeConstraints {
                $0.centerY.equalTo(namelab)
                $0.left.equalToSuperview().offset(30 + w)
            }
        }
        
    }
    
    
    
    
}
