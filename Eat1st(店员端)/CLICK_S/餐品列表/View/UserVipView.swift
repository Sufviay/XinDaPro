//
//  UserVipView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/7/2.
//

import UIKit

class UserVipView: UIView {

    
    private let backImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        
        var imgage =  LOIMG("vipback")
        let inset = UIEdgeInsets(top: 10, left: 80, bottom: 10, right: 120)
        imgage = imgage.resizableImage(withCapInsets: inset, resizingMode: .stretch)
        backImg.image = imgage
        //m.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: R_W(80), bottom: 10, right: R_W(120)), resizingMode: .stretch)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
