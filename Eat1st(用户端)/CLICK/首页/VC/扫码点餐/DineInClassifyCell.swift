//
//  DineInClassifyCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/25.
//

import UIKit

class DineInClassifyCell: UICollectionViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        
        return view
    }()
    
    private let picImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 7
        return img
    }()
    
    private let name_E: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .left)
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Sichuan cuisine"
        return lab
    }()
    
    private let name_C: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#BE8D13"), BFONT(18), .left)
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "川菜"
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(name_C)
        name_C.snp.makeConstraints {
            $0.left.equalTo(picImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(name_E)
        name_E.snp.makeConstraints {
            $0.left.right.equalTo(name_C)
            $0.top.equalTo(name_C.snp.bottom).offset(3)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: DineInClassifyModel) {
        
        let name = model.name_C == "" ? model.dineName : model.name_C
        name_E.text = model.name_E
        name_C.text =  name
        picImg.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: HOLDIMG)
    }
    
}
