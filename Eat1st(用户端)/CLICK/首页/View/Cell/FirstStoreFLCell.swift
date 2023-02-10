//
//  FirstStoreFLCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/13.
//

import UIKit

class FirstStoreFLCell: BaseTableViewCell {

    
    let labImg: UIImageView = {
        let img = UIImageView()
        //img.image = LOIMG("Favourite")
        return img
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.setImage(LOIMG("more_y"), for: .normal)
        but.isUserInteractionEnabled = false
        return but
    }()


    override func setViews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(labImg)
        labImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(R_W(10))
        }
        
        contentView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        
        
    }
    
    

}
