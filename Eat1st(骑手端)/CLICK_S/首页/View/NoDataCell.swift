//
//  NoDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/28.
//

import UIKit

class NoDataCell: BaseTableViewCell {

    
    private let tImage: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noData-1")
        return img
    }()
    

    override func setViews() {
        
        contentView.addSubview(tImage)
        tImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 258, height: 258))
            $0.center.equalToSuperview()
        }
        
    }
    

    

}
