//
//  OrderTSDealCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/17.
//

import UIKit

class OrderTSDealCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("F8F8F8")
        view.layer.cornerRadius = 10
        return view
    }()

    
    let tsDealLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = HCOLOR("#F8F8F8")
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "2222222222"
        return lab
    }()
    
    let dealTime: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "11111"
        return lab
    }()
    

    
    
    override func setViews() {
        
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        backView.addSubview(dealTime)
        dealTime.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-5)

        }
        

        tView.addSubview(tsDealLab)
        tsDealLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
    }
    
    func setCellData(model: OrderDetailModel) {
        
        self.dealTime.text = model.tsDealTime
        self.tsDealLab.text = model.tsDealContent
        
    }
    
    
    
    
}
