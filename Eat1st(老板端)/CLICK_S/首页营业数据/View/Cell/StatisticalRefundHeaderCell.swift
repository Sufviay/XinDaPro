//
//  StatisticalRefundHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/12/5.
//

import UIKit

class StatisticalRefundHeaderCell: BaseTableViewCell {

    private let l_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_refund")
        return img
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "Refund orders"
        return lab
    }()
    
    private let moreImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_xl_z")
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(l_img.snp.right).offset(20)
            $0.centerY.equalTo(l_img)
        }
        
        contentView.addSubview(moreImg)
        moreImg.snp.makeConstraints {
            $0.centerY.equalTo(l_img)
            $0.right.equalToSuperview().offset(-40)
        }

        
        
    }
    
    
    func setCellData(isShow: Bool) {
        if isShow {
            self.moreImg.image = LOIMG("sy_sq_z")
        } else {
            self.moreImg.image = LOIMG("sy_xl_z")
        }

        
    }
    
    

}
