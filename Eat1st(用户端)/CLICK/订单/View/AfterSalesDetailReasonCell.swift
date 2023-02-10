//
//  AfterSalesDetailReasonCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/6/8.
//

import UIKit

class AfterSalesDetailReasonCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Dietary Requirements not met "
        return lab
    }()
    
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unsel_f")
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.left.equalToSuperview().offset(20)
        }

        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    
    func setCellData(nameStr: String, isSelect: Bool) {
        self.titlab.text = nameStr
        if isSelect {
            self.selectImg.image = LOIMG("sel_f")
            self.titlab.textColor = HCOLOR("#FEC501")
        } else {
            self.selectImg.image = LOIMG("unsel_f")
            self.titlab.textColor = HCOLOR("#333333")
        }
    }
}
