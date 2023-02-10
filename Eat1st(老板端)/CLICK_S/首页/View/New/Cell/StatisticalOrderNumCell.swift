//
//  StatisticalOrderNumCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/22.
//

import UIKit

class StatisticalOrderNumCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let l_img: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .left)
        return lab
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(18), .right)
        return lab
    }()
    
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.isHidden = true
        img.image = LOIMG("sy_numNext")
        return img
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(55)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-53)
        }
        
    }
    
    
    func setCellData(idx: Int, model: OrderNumModel)  {
        if idx == 1 {
            self.titlab.text = "Wait for order"
            self.l_img.image = LOIMG("sy_djd")
            self.numberLab.text = String(model.waitReceive)
            self.numberLab.textColor = HCOLOR("#465DFD")
        }
        if idx == 2 {
            self.titlab.text = "Pending meal"
            self.l_img.image = LOIMG("sy_yjd")
            self.numberLab.text = String(model.waitCook)
            self.numberLab.textColor = HCOLOR("#465DFD")
        }
        if idx == 3 {
            self.titlab.text = "Pending delivery"
            self.l_img.image = LOIMG("sy_ycc")
            self.numberLab.text = String(model.waitSend)
            self.numberLab.textColor = HCOLOR("#465DFD")
        }
        if idx == 4 {
            self.titlab.text = "Pending pick up"
            self.l_img.image = LOIMG("sy_dps")
            self.numberLab.text = String(model.waitTake)
            self.numberLab.textColor = HCOLOR("#465DFD")
        }
        if idx == 5 {
            self.titlab.text = "Finished"
            self.l_img.image = LOIMG("sy_ywc")
            self.numberLab.text = String(model.success)
            self.numberLab.textColor = HCOLOR("#465DFD")
        }
        if idx == 6 {
            self.titlab.text = "Driver"
            self.l_img.image = LOIMG("sy_rider")
            self.numberLab.text = String(model.riderNum)
            self.numberLab.textColor = HCOLOR("#02C392")
        }
    }
}
