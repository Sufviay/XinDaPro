//
//  DistanceChargeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/11.
//

import UIKit

class DistanceChargeCell: BaseTableViewCell {
    
    var clickDeleteBlock: VoidBlock?
    
    var editeBlock: VoidBlock?

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_3, .left)
        lab.text = "Distribution distance"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), TXT_2, .left)
        lab.text = "Less than or equal to".local
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_3, .left)
        lab.text = "Delivery charge".local
        return lab
    }()
    
    private let xlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()
    
    private let xlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()

    
    private let mlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_3, .left)
        lab.text = "MILES"
        return lab
    }()
    
    private let plab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_3, .left)
        lab.text = "POUND"
        return lab
    }()
    
    private let mNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), TIT_4, .right)
        lab.text = "4"
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    
    private let pNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), TIT_4, .right)
        lab.text = "300.00"
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let deleBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "DELETE".local, .white, SFONT(13), HCOLOR("#465DFD"))
        but.setImage(LOIMG("dis_delete"), for: .normal)
        but.layer.cornerRadius = 14
        return but
    }()
    
    
    
    
    override func setViews() {
            
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(1)
            
        }
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-68)
        }
        
        contentView.addSubview(xlab1)
        xlab1.snp.makeConstraints {
            $0.centerY.equalTo(tlab1).offset(3)
            $0.left.equalTo(tlab1.snp.right)
        }
        
        contentView.addSubview(xlab2)
        xlab2.snp.makeConstraints {
            $0.centerY.equalTo(tlab3).offset(3)
            $0.left.equalTo(tlab3.snp.right)
        }
        
        contentView.addSubview(mlab)
        mlab.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.right).offset(-60)
            $0.centerY.equalTo(tlab1).offset(3)
        }
        
        contentView.addSubview(plab)
        plab.snp.makeConstraints {
            $0.centerY.equalTo(tlab3).offset(3)
            $0.left.equalTo(mlab)
        }
        
        contentView.addSubview(mNumLab)
        mNumLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalTo(mlab.snp.left).offset(-5)
        }
        
        contentView.addSubview(pNumLab)
        pNumLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.right.equalTo(plab.snp.left).offset(-5)
        }

        contentView.addSubview(deleBut)
        deleBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 28))
            $0.right.equalToSuperview().offset(-28)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        
        deleBut.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(clickTapAction))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickTapAction))
        self.mNumLab.addGestureRecognizer(tap1)
        self.pNumLab.addGestureRecognizer(tap2)
        
    }
    
    func setCellData(model: DeliveryFeeModel, type: String) {
        
        if type == "1" {
            self.tlab1.text = "Distribution distance".local
            self.tlab2.isHidden = false
            self.mNumLab.text = String(model.distance)
            self.mlab.text = "MILES"
            
        }
        if type == "2" {
            self.tlab1.text = "Delivery area Postcode".local
            self.tlab2.isHidden = true
            self.mNumLab.text = model.postCode
            self.mlab.text = ""
        }
        
        
        self.pNumLab.text = String(model.amount)
    }
    
    
    @objc private func clickTapAction() {
        self.editeBlock?("")
        
    }
    @objc private func deleteAction() {
        clickDeleteBlock?("")
    }
    
    
}
