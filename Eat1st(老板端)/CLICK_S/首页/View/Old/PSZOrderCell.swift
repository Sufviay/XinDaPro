//
//  PSZOrderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/27.
//

import UIKit

class PSZOrderCell: BaseTableViewCell {

    
    var clickBlock: VoidBlock?
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
        lab.text = "#099"
        return lab
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .right)
        lab.text = "Delivering"
        return lab
    }()
    
    
    private let checkBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("check"), for: .normal)
        return but
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "88 Taishan East Street Changchun Road Street"
        return lab
    }()
    
    

    override func setViews() {
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalTo(numberLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(checkBut)
        checkBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(50)
        }
    
        //checkBut.addTarget(self, action: #selector(clickCheckAciton), for: .touchUpInside)
        
    }
    
    
    
    
    @objc private func clickCheckAciton() {
        //self.clickBlock?("")
    }
    
    func setCellData(model: RiderDeliveryModel, isSelect: Bool) {
        self.addressLab.text = model.address
        self.numberLab.text = "#" + model.dayNum
        
//        if isSelect {
            self.contentView.backgroundColor = HCOLOR("#FFD982").withAlphaComponent(0.1)
            self.checkBut.isHidden = false
//        } else {
//            self.contentView.backgroundColor = .white
//            self.checkBut.isHidden = true
//        }
        
    }
    
}
