//
//  StoreTagCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/19.
//

import UIKit

class StoreTagCell: UICollectionViewCell {
    
    
    let tagLab: UILabel = {
        let lab = UILabel()
        lab.font = SFONT(10)
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 3
        lab.layer.borderWidth = 1
        lab.textAlignment = .center
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
