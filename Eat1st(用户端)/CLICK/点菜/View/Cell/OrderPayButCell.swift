//
//  OrderPayButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/10.
//

import UIKit

class OrderPayButCell: BaseTableViewCell {

    var clickPayBlock: VoidBlock?
    
    private let payBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Pay Now", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(payBut)
        payBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        payBut.addTarget(self, action: #selector(clickPayAction), for: .touchUpInside)
    }
    
    
    func setCellData(titStr: String) {
        self.payBut.setTitle(titStr, for: .normal)
    }
    
    
    @objc func clickPayAction() {
        clickPayBlock?("")
    }
    
    

}
