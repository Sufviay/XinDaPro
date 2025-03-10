//
//  StoreTotalAmountCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/6.
//

import UIKit

class StoreTotalAmountCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#000000")
        return view
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(13), .center)
        lab.text = "Total sales"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(13), .center)
        lab.text = "Total orders"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(20), .center)
        lab.text = "£9999"
        return lab
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(20), .center)
        lab.text = "9999"
        return lab
    }()
    

    
    
    override func setViews() {
       
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 55))
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(line.snp.left)
            $0.top.equalTo(line.snp.top).offset(10)
        }
        
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.equalTo(line.snp.right)
            $0.top.equalTo(tlab1)
        }

        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalTo(tlab1)
            $0.top.equalTo(tlab1.snp.bottom).offset(8)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerX.equalTo(tlab2)
            $0.centerY.equalTo(moneyLab)
        }

    }

    
    func setCellData(model: StoreSummaryModel) {
        moneyLab.text = "£\(D_2_STR(model.salesPrice))"
        numberLab.text = String(model.salesNum)
    }
    

}
