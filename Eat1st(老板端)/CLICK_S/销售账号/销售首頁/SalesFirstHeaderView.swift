//
//  SalesFirstHeaderView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/4.
//

import UIKit
import SwiftyJSON


class ToTalDataModel: NSObject {
    ///预计收入[...]
    var estimatedRevenue: Double = 0
    ///店铺数量[...]
    var storeCount: Int = 0
    ///下级销售员数量[...]
    var subUserCount: Int = 0
    ///已结佣金[...]
    var totalRevenue: Double = 0
    
    
    func updateModel(json: JSON) {
        estimatedRevenue = json["estimatedRevenue"].doubleValue
        storeCount = json["storeCount"].intValue
        subUserCount = json["subUserCount"].intValue
        totalRevenue = json["totalRevenue"].doubleValue
    }
    
    
}

class SalesFirstHeaderView: UIView {
    
    var clickBlock: VoidBlock?
    
    private let backView: UIImageView = {
        let img = UIImageView()
        let image = GRADIENTCOLOR(HCOLOR("#2767FF"), HCOLOR("#3775FB"), CGSize(width: S_W - 40, height: 145), 1)
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.image = image
        return img
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        return view
    }()
    
    private let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#3472FC"), BFONT(9), .center)
        lab.text = "MONTHLY"
        lab.backgroundColor = .white
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 9
        return lab
    }()
    
    private let totalBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let totalMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, NUMFONT_2, .left)
        lab.text = "0"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    private let slab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_14, .left)
        lab.text = "£"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_14, .left)
        lab.text = "Total Commission".local
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xs_next")
        return img
    }()
    

    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_14, .left)
        lab.text = "Store"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_14, .left)
        lab.text = "This Month"
        return lab
    }()
    
    private let tlab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_14, .left)
        lab.text = "Person"
        return lab
    }()


    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_18, .left)
        lab.text = "0"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    private let personLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_18, .left)
        lab.text = "0"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()

    
    
    private let es_MoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_18, .left)
        lab.text = "0"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    
    private let slab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_10, .left)
        lab.text = "£"
        return lab
    }()

    

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(80)
        }
        
        
        addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(18)
        }

        
        addSubview(totalBut)
        totalBut.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(line.snp.top)
        }

        addSubview(totalMoneyLab)
        totalMoneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.bottom.equalTo(line.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-30)
        }
        
        addSubview(slab1)
        slab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(totalMoneyLab).offset(-3)
        }
        
        addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.left.equalTo(tlab1.snp.right).offset(10)
        }
        
        
        addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        addSubview(tlab4)
        tlab4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(105))
            $0.centerY.equalTo(tlab2)
        }

        
        addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(200))
            $0.centerY.equalTo(tlab2)
        }

        
        addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.left.equalTo(tlab2)
            $0.top.equalTo(tlab2.snp.bottom).offset(2)
        }
        
        addSubview(personLab)
        personLab.snp.makeConstraints {
            $0.left.equalTo(tlab4)
            $0.centerY.equalTo(countLab)
        }
        
        addSubview(es_MoneyLab)
        es_MoneyLab.snp.makeConstraints {
            $0.centerY.equalTo(countLab)
            $0.left.equalTo(tlab3).offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        addSubview(slab2)
        slab2.snp.makeConstraints {
            $0.bottom.equalTo(es_MoneyLab).offset(-2)
            $0.left.equalTo(tlab3)
        }

        
        totalBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   @objc private func clickAction() {
       clickBlock?("")
    }
    
    
    
    func setData(data: ToTalDataModel) {
        totalMoneyLab.text = D_2_STR(data.totalRevenue)
        es_MoneyLab.text = D_2_STR(data.estimatedRevenue)
        personLab.text = String(data.subUserCount)
        countLab.text = String(data.storeCount)
    }
    
    
}
