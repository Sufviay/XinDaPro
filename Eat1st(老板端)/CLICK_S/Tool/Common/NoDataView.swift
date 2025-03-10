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
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.text = "No data available".local
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.size.equalTo(CGSize(width: 190, height: 160))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(20)
        }
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
