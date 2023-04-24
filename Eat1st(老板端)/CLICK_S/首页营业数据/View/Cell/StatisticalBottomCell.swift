//
//  StatisticalBottomCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/1.
//

import UIKit

class StatisticalBottomCell: BaseTableViewCell {

    var clickBlock: VoidBlock?

    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .center)
        lab.text = "Information displayed is based on data collected in the past"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .right)
        lab.text = "28 days."
        return lab
    }()
    
    private let xyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(10), .left)
        lab.text = "Terms & conditions"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    private let backTopBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sy_backtop"), for: .normal)
        return but
    }()
    
    private let topBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Back to top", HCOLOR("#666666"), SFONT(14), .clear)
        return but
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .center)
        lab.text = "Check my cookie preferences"
        return lab
    }()
        
    
    override func setViews() {
        
        
//        contentView.addSubview(tlab1)
//        tlab1.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(15)
//        }
//
//
//        contentView.addSubview(tlab2)
//        tlab2.snp.makeConstraints {
//            $0.top.equalTo(tlab1.snp.bottom).offset(2)
//            $0.right.equalTo(contentView.snp.centerX).offset(-35)
//        }
//
//        contentView.addSubview(xyLab)
//        xyLab.snp.makeConstraints {
//            $0.centerY.equalTo(tlab2)
//            $0.left.equalTo(tlab2.snp.right).offset(0)
//        }
//
        contentView.addSubview(topBut)
        topBut.snp.makeConstraints {

            $0.centerX.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 80, height: 30))
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(backTopBut)
        backTopBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalTo(topBut)
            $0.right.equalTo(topBut.snp.left).offset(-5)
        }

        
//
//        contentView.addSubview(tlab3)
//        tlab3.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(topBut.snp.bottom).offset(5)
//
//        }
        
        backTopBut.addTarget(self, action: #selector(clickBackTop), for: .touchUpInside)
        topBut.addTarget(self, action: #selector(clickBackTop), for: .touchUpInside)
        
    }
    
    
    @objc private func clickBackTop() {
        
        clickBlock?("")
    }
    
    
}
