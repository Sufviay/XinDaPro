//
//  ComplaintsButtonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsButtonCell: BaseTableViewCell {

    
    var clickDealBlock: VoidBlock?
    
    var clickDetailBlock: VoidBlock?

    private let detailBut_S: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 10
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        but.layer.borderWidth = 2
        but.isHidden = false
        return but
    }()
    
    private let detailLab_b: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .center)
        lab.text = "Order details"
        return lab
    }()

    private let nextBut_b: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sjt_b")
        return img
    }()
    
    
    
    
    private let detailBut_B: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#465DFD")
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    private let detailLab_w: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Order details"
        return lab
    }()
    
    private let nextBut_w: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sjt_w")
        return img
    }()
    
    
    private let dealBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reply", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 10
        but.isHidden = false
        return but
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(dealBut)
        dealBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(contentView.snp.centerX).offset(-7)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(detailBut_S)
        detailBut_S.snp.makeConstraints {
            $0.centerY.height.equalTo(dealBut)
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalTo(contentView.snp.centerX).offset(7)
        }
        
        detailBut_S.addSubview(detailLab_b)
        detailLab_b.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        detailBut_S.addSubview(nextBut_b)
        nextBut_b.snp.makeConstraints {
            $0.left.equalTo(detailLab_b.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.centerY.equalToSuperview()
        }
        
        
        contentView.addSubview(detailBut_B)
        detailBut_B.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().offset(10)
        }
        
        detailBut_B.addSubview(detailLab_w)
        detailLab_w.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        detailBut_B.addSubview(nextBut_w)
        nextBut_w.snp.makeConstraints {
            $0.left.equalTo(detailLab_w.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.centerY.equalToSuperview()
        }
        
        
        
        
        dealBut.addTarget(self, action: #selector(clickDealAction), for: .touchUpInside)
        detailBut_S.addTarget(self, action: #selector(clickDetailAction), for: .touchUpInside)
        detailBut_B.addTarget(self, action: #selector(clickDetailAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDetailAction() {
        clickDetailBlock?("")
    }
    
    @objc private func clickDealAction() {
        clickDealBlock?("")
    }
    
    
    func setCellData(type: String) {
        
        if type == "2" {
            //已回复 详情按钮
            detailBut_B.isHidden = false
            detailBut_S.isHidden = true
            dealBut.isHidden = true
        } else {
            //未回复
            detailBut_B.isHidden = true
            detailBut_S.isHidden = false
            dealBut.isHidden = false
        }
        
    }
    
    
}
