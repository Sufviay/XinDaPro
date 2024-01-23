//
//  CartDishSelectItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/19.
//

import UIKit

class CartDishSelectItemCell: BaseTableViewCell {
    
    private let point: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FEC501")
        view.layer.cornerRadius = 3.5
        return view
    }()

    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(11), .left)
        lab.text = "11111"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.text = "11111"
        lab.numberOfLines = 0
        return lab
    }()

    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#EE7763"), BFONT(10), .right)
        lab.text = "+£0.00"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 7, height: 7))
        }
        
        contentView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-70)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.right.equalTo(namelab1)
            $0.top.equalTo(namelab1.snp.bottom)
        }
        
    }
    
    func setCellData(model: CartDishItemModel) {
        namelab1.text = model.nameEn
        namelab2.text = model.nameHk

        if model.itemType == "2" {
            moneylab.text = ""
        } else {
            moneylab.text = "£\(D_2_STR(model.price))"
        }
        
    }
    

}
