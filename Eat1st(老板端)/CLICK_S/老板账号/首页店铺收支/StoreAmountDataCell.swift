//
//  StoreAmountDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/7.
//

import UIKit

class StoreAmountDataCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(14), .right)
        lab.text = "£ 1980.40"
        return lab
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .left)
        lab.text = "Total amount"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
 
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
    }
    
    
    
    func setCellData(titStr: String, number: String) {
        
        titlab.text = titStr
        numberLab.text = number
        
        
        if titStr == "Tatal Sales" || titStr == "Total Expenditure" {
            
            titlab.textColor = HCOLOR("333333")
            titlab.font = BFONT(15)
            numberLab.textColor = HCOLOR("333333")
            numberLab.font = BFONT(15)
            
        } else {
            titlab.textColor = HCOLOR("666666")
            titlab.font = BFONT(13)
            numberLab.textColor = HCOLOR("666666")
            numberLab.font = BFONT(13)
        }
        
        if titStr == "Tips" {
            line.backgroundColor = HCOLOR("AAAAAA")
        } else {
            line.backgroundColor = HCOLOR("EEEEEE")
        }
        
        
        
    }
    

}
