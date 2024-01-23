//
//  NoDataView.swift
//  WinShop
//
//  Created by 岁变 on 8/31/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noData")
        return img
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(16), .center)
        lab.text = "No information yet"
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.size.equalTo(CGSize(width: 188, height: 188))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(picImg.snp.bottom).offset(-5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
