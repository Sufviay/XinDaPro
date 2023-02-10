//
//  StoreFirstHeadCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreFirstHeadCell: BaseTableViewCell {
    
    
    private var headImg: CustomImgeView = {
        let img = CustomImgeView()
        return img
    }()

    override func setViews() {
        
        contentView.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setCellData(imgStr: String) {
        self.headImg.setImage(imageStr: imgStr)
    }
    
    
}
