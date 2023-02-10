//
//  PSHistoryCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/27.
//

import UIKit

class PSHistoryCell: BaseTableViewCell {

    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .left)
        lab.text = "Order id：1234567891234567891"
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "Order id：1234567891234567891"
        return lab
    }()
    

    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "88 Taishan East Street Changchun Road Street"
        return lab
    }()
    
    private let checkBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("check"), for: .normal)
        return but
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(60)
        }
        
        contentView.addSubview(checkBut)
        checkBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }

    }
    
    func setCellData(model: RiderDeliveryModel) {
        self.addressLab.text = model.address
        self.timeLab.text = model.time
        self.numberLab.text = "Order id：\(model.orderID)"
    }
    
    

}
