//
//  StatisticalHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit

class StatisticalHeaderCell: BaseTableViewCell {


    private let l_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_order")
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FCB138"), BFONT(17), .left)
        lab.text = "11"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "Fulfilled orders"
        return lab
    }()
    
    private let moreImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_xl_y")
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalTo(l_img.snp.right).offset(20)
            $0.top.equalToSuperview().offset(18)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(numberLab)
            $0.bottom.equalToSuperview().offset(-2)
        }
        
        contentView.addSubview(moreImg)
        moreImg.snp.makeConstraints {
            $0.centerY.equalTo(l_img)
            $0.right.equalToSuperview().offset(-40)
        }
        
    }
    
    func setCellData(section: Int, isShow: Bool, model: ReportModel) {
        if section == 5 {
            self.l_img.image = LOIMG("sy_order")
            self.numberLab.textColor = HCOLOR("#FCB138")
            self.tlab.text = "Fulfilled orders"
            if isShow {
                self.moreImg.image = LOIMG("sy_sq_y")
            } else {
                self.moreImg.image = LOIMG("sy_xl_y")
            }
            self.numberLab.text = String(model.orderNum_All)
        }
        
        if section == 6 {
            self.l_img.image = LOIMG("sy_all")
            self.numberLab.textColor = HCOLOR("#FCB138")
            self.tlab.text = "Total revenue"
            if isShow {
                self.moreImg.image = LOIMG("sy_sq_y")
            } else {
                self.moreImg.image = LOIMG("sy_xl_y")
            }
            self.numberLab.text = "£ \(D_2_STR(model.orderSum_All))"
        }
        
        if section == 8 {
            self.l_img.image = LOIMG("sy_problemOrder")
            self.numberLab.textColor = HCOLOR("#02C392")
            self.tlab.text = "Unfulfilled orders"
            if isShow {
                self.moreImg.image = LOIMG("sy_sq_g")
            } else {
                self.moreImg.image = LOIMG("sy_xl_g")
            }
            
            self.numberLab.text = String(model.unOrderNum_All)
            
        }
        
        if section == 9 {
            self.l_img.image = LOIMG("sy_lost")
            self.numberLab.textColor = HCOLOR("#02C392")
            self.tlab.text = "Lost revenue"
            if isShow {
                self.moreImg.image = LOIMG("sy_sq_g")
            } else {
                self.moreImg.image = LOIMG("sy_xl_g")
            }
            self.numberLab.text = "£ \(D_2_STR(model.unOrderSum_All))"
        }
        
    }
    

}
