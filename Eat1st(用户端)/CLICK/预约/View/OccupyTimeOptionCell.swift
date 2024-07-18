//
//  OccupyTimeOptionCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyTimeOptionCell: UICollectionViewCell {
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(13), .center)
        
        lab.clipsToBounds = true
        lab.backgroundColor = HCOLOR("#FAFAFA")
        lab.layer.cornerRadius = 6
        lab.layer.borderWidth = 0
        lab.layer.borderColor = MAINCOLOR.cgColor
        return lab
    }()
    
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sel")
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(2)
            $0.right.equalToSuperview().offset(-2)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
        }
        
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.bottom.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: OccupyTimeModel, isSelect: Bool) {
        timeLab.text = model.reserveTime
        if isSelect {
            timeLab.backgroundColor = HCOLOR("#FEF7DF")
            timeLab.layer.borderWidth = 2
            selectImg.isHidden = false
        } else {
            timeLab.backgroundColor = HCOLOR("#FAFAFA")
            timeLab.layer.borderWidth = 0
            selectImg.isHidden = true

        }
        
    }
}
