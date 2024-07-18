//
//  AddBut.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/2.
//

import UIKit

class AddBut: UIButton {


    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("add")
        return img
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(11), .right)
        lab.text = "ADD"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = .clear
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-2)
        }
        
        self.addSubview(img1)
        img1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titlab.snp.left).offset(-3)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
