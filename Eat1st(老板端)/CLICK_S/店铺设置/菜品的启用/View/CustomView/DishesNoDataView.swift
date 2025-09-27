//
//  DishesNoDataView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/10.
//

import UIKit

class DishesNoDataView: UIView {


    
    var type: String = "1" {
        didSet {
            if type == "1" {
                self.titLab.text = "All items are off your menu"
            }
            if type == "2" {
                self.titLab.text = "All items are on your menu"
            }
        }
    }
    
    private let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_noData")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, BFONT(17), .center)
        lab.text = "All items are on your menu"
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 130, height: 130))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
        }
        
        self.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(25)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
