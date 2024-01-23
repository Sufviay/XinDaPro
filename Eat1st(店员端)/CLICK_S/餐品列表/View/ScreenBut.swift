//
//  ScreenBut.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit

class ScreenBut: UIButton {

    
    var jiantouImg: String = "" {
        didSet {
            img2.image = LOIMG(jiantouImg)
        }
    }
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("shaixuan")
        return img
    }()
    
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xiala")
        return img
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(11), .right)
        lab.text = "Screen"
        return lab
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(img2)
        img2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 6, height: 3))
            $0.right.equalToSuperview().offset(-2)
        }
        
        addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(img2.snp.left).offset(-1)
        }
        
        addSubview(img1)
        img1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titlab.snp.left).offset(-3)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
