//
//  PostCodeNoDataView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class PostCodeNoDataView: UIView {

    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("loacl_noData")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        let tempStr = "Input the correct PostCode to help us accurately search and calculate the delivery time"
        lab.attributedText = tempStr.attributedString(font: SFONT(15), textColor: FONTCOLOR, lineSpaceing: 10, wordSpaceing: 0)
        lab.textAlignment = .center
        return lab
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear

        self.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        self.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(s_img.snp.bottom).offset(15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
