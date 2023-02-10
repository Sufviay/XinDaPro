//
//  JiFenTagCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/9.
//

import UIKit

class JiFenTagCell: UICollectionViewCell {
    
    
    private let taglab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = HCOLOR("333333")
        lab.font = BFONT(15)
        lab.text = "10000"
        lab.layer.cornerRadius = 12
        lab.backgroundColor = HCOLOR("#FFF8E2")
        lab.clipsToBounds = true
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(taglab)
        taglab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.height.equalTo(24)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(name: String, isSelect: Bool) {
        if isSelect {
            
            self.taglab.backgroundColor = HCOLOR("#FFF8E2")
            self.taglab.textColor = HCOLOR("#FF7200")
            
        } else {
            self.taglab.backgroundColor = .clear
            self.taglab.textColor = HCOLOR("#333333")

        }
        
        self.taglab.text = name
    }
    
    
}
