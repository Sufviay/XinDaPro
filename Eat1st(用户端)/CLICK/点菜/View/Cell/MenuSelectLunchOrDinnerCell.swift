//
//  MenuSelectLunchOrDinnerCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/15.
//

import UIKit

class MenuSelectLunchOrDinnerCell: BaseTableViewCell {
    
    var clickBlock: VoidStringBlock?
    
    private var type: String = "" {
        didSet {
            if type == "lunch" {
                self.l_Line.isHidden = false
                self.d_Line.isHidden = true
                self.lunchBut.setTitleColor(FONTCOLOR, for: .normal)
                self.lunchBut.titleLabel?.font = BFONT(17)
                self.dinnerBut.setTitleColor(HCOLOR("666666"), for: .normal)
                self.dinnerBut.titleLabel?.font = BFONT(14)
            }
            
            if type == "dinner" {
                self.d_Line.isHidden = false
                self.l_Line.isHidden = true
                self.dinnerBut.setTitleColor(FONTCOLOR, for: .normal)
                self.dinnerBut.titleLabel?.font = BFONT(17)
                self.lunchBut.setTitleColor(HCOLOR("666666"), for: .normal)
                self.lunchBut.titleLabel?.font = BFONT(14)
            }
        }
    }

    private let lunchBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Lunch", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    
    private let dinnerBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Dinner", HCOLOR("#666666"), BFONT(14), .white)
        return but
    }()
    
    private let l_Line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let d_Line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()
    
    override func setViews() {
        
        contentView.addSubview(lunchBut)
        lunchBut.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(S_W / 2)
        }
        
        contentView.addSubview(dinnerBut)
        dinnerBut.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(S_W / 2)
        }
        
        
        lunchBut.addSubview(l_Line)
        l_Line.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        dinnerBut.addSubview(d_Line)
        d_Line.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        
        lunchBut.addTarget(self, action: #selector(clickLunchAction), for: .touchUpInside)
        dinnerBut.addTarget(self, action: #selector(clickDinnerAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickLunchAction() {
        if type != "lunch" {
            self.type = "lunch"
            self.clickBlock?("lunch")
        }
    }
    
    @objc private func clickDinnerAction() {
        if type != "dinner" {
            self.type = "dinner"
            self.clickBlock?("dinner")
        }
    }
    
    
    func setCellData(type: String) {
        self.type = type
    }
    
    
}
