//
//  NumberCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/25.
//

import UIKit

class NumberCell: UICollectionViewCell {
    
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 5
        lab.layer.borderColor = MAINCOLOR.cgColor
        lab.layer.borderWidth = 1
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(text: String, isSel: Bool) {
        numberLab.text = text
        if isSel {
            numberLab.backgroundColor = MAINCOLOR
        } else {
            numberLab.backgroundColor = .white
        }
    }
    
    
}



class NumberHeader: UICollectionReusableView {
    
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        return lab
    }()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
