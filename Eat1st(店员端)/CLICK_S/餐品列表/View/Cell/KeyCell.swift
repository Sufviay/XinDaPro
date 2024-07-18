//
//  KeyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/15.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    
    private let backView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 3
        let W = (S_W - 40 - 27) / 10
        img.image = GRADIENTCOLOR(HCOLOR("#FAFAFA"), HCOLOR("#F1F1F1"), CGSize(width: W, height: W))
        return img
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(15), .center)
        return lab
    }()
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("shanchu")
        return img
    }()
    
    private let backLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(10), .center)
        lab.text = "Back"
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 5))
            $0.centerY.equalToSuperview().offset(-5)
            $0.centerX.equalToSuperview()
        }
        
        backView.addSubview(backLab)
        backLab.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(5)
            $0.centerX.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setCellData(titStr: String) {
        titlab.text = titStr
        if titStr == "" {
            backImg.isHidden = false
            backLab.isHidden = false
        } else {
            backImg.isHidden = true
            backLab.isHidden = true
        }
    }
    
    
}
