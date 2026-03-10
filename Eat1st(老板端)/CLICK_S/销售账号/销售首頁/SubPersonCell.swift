//
//  SubPersonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/8.
//

import UIKit
import SwiftyJSON


class SubCommissionModel: NSObject {
    ///已结佣金[...]
    var commission: Double = 0
    ///下级销售id[...]
    var userId: String = ""
    ///下级销售名称[...]
    var userName: String = ""
    
    func updateModel(json: JSON) {
        commission = json["commission"].doubleValue
        userId = json["userId"].stringValue
        userName = json["userName"].stringValue
    }
}


class SubPersonCell: BaseTableViewCell {


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
            $0.right.equalToSuperview().offset(-15)
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
    
    
    func setCellData(model: SubCommissionModel) {
        
        moneyLab.text = D_2_STR(model.commission)
        namelab.text = model.userName
                
    }
    

}
