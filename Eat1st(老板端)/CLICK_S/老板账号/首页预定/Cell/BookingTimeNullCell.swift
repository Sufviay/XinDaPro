//
//  BookingTimeNullCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/15.
//

import UIKit

class BookingTimeNullCell: BaseTableViewCell {


    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Please choose a time below"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    
    
    private let nullImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("null")
        return img
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .center)
        lab.text = "No reservation information at the moment"
        return lab
    }()
    
    
    
    override func setViews() {
        
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        
        contentView.addSubview(nullImg)
        nullImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 173, height: 145))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nullImg.snp.bottom).offset(20)
        }
        
    }
    
    

}
