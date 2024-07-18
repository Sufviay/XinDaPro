//
//  OrderFooderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderFooderCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#D8D8D8")
        return view
    }()

    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("zk")
        return img
    }()
    
    
    override func setViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    func setCellData(isShow: Bool) {
        
        backView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 30), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 15)
        if isShow {
            xlImg.image = LOIMG("sq")
        } else {
            xlImg.image = LOIMG("zk")
        }
    }
    
}
