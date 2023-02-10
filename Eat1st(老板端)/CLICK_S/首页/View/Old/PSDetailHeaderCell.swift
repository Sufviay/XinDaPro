//
//  PSDetailHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/26.
//

import UIKit

class PSDetailHeaderCell: BaseTableViewCell {

    
    var clickBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Deilvery Order"
        return lab
    }()
    
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "more", HCOLOR("666666"), SFONT(14), .clear)
        but.isHidden = true
        return but
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_s"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(40)
        }
        
        self.moreBut.addTarget(self, action: #selector(clickNextAciton), for: .touchUpInside)
        self.nextBut.addTarget(self, action: #selector(clickNextAciton), for: .touchUpInside)
        
    }
    
    
    func setCellData(titStr: String) {
//        if titStr == "Delivery Order" {
//            self.backgroundColor = .clear
//            self.contentView.backgroundColor = .clear
//            self.moreBut.isHidden = true
//            self.nextBut.isHidden = true
//        } else {
//            self.backgroundColor = .white
//            self.contentView.backgroundColor = .white
//            self.moreBut.isHidden = false
//            self.nextBut.isHidden = false
//        }
        
        self.titLab.text = titStr
    }
    
    @objc private func clickNextAciton() {
        self.clickBlock?("")
    }
    
    
}
