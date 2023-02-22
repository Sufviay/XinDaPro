//
//  RoundedCornersCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/12.
//

import UIKit



class OrderRoundedCornersCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 20), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)
        return view
    }()
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
            
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}


class TopCornersCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 20), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
        
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
            
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(10)

        }
    }
}


class BottomCornersCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 20), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)
        return view
    }()
        
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
            
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(0)

        }
    }
}

