//
//  OrderDishAttatchItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderDishAttatchItemCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F4F6F9")
        view.layer.cornerRadius = 5
        return view
    }()

    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(10), .left)
        lab.text = "11111"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(10), .left)
        lab.text = "11111"
        lab.numberOfLines = 0
        return lab
    }()

    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), SFONT(10), .right)
        lab.text = "£0.00"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-100)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }

        
        backView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(5)
        }
        
        backView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.right.equalTo(namelab1)
            $0.top.equalTo(namelab1.snp.bottom)
        }
        
        
    }
    
    
    func setCellData(model: OrderDishSelectItemModel) {
        namelab1.text = model.nameEn
        namelab2.text = model.nameHk
        
        moneylab.text = "£\(D_2_STR(model.price))"
        
    }


    

}
