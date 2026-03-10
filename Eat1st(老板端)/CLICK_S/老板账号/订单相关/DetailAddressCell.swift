//
//  DetailAddressCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/31.
//

import UIKit

class DetailAddressCell: BaseTableViewCell {

    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("local")
        return img
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), SFONT(12), .left)
        lab.numberOfLines = 0
        lab.text = "88 Taishan East Street Changchun Road Street"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 11, height: 11))
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(1)
            $0.right.equalToSuperview().offset(20)
        }
    
    }
    
    
    func setCellData(address: String) {
        addressLab.text = address
    }
    
    
}
