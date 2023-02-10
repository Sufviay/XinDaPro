//
//  SetDeliveryTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/19.
//

import UIKit

class SetDeliveryTimeCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3

        
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = "Delivery time setting"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let point1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let point2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#144DDE")
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Collection"
        return lab
    }()

    private let deStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "50", FONTCOLOR, BFONT(15), HCOLOR("#F1F1F1"))
        return but
    }()
    
    private let deEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "50", FONTCOLOR, BFONT(15), HCOLOR("#F1F1F1"))
        return but
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    
    private let coStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "100", FONTCOLOR, BFONT(15), HCOLOR("#F1F1F1"))
        return but
    }()
    
    private let coEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "100", FONTCOLOR, BFONT(15), HCOLOR("#F1F1F1"))
        return but
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()


    

    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(tlab.snp.bottom)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab.snp.bottom).offset(27)
        }
        
        backView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-27)
        }
        
        backView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.left.equalTo(point1.snp.right).offset(10)
        }
        
        backView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.left.equalTo(point2.snp.right).offset(10)
        }
        
        
        backView.addSubview(deEndBut)
        deEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(deEndBut.snp.left).offset(-10)
        }
        
        backView.addSubview(deStartBut)
        deStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(line1.snp.left).offset(-10)
        }
        
        backView.addSubview(coEndBut)
        coEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(coEndBut.snp.left).offset(-10)
        }
        
        backView.addSubview(coStartBut)
        coStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 53, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(line2.snp.left).offset(-10)
        }
        
        deStartBut.addTarget(self, action: #selector(setDeMinAction), for: .touchUpInside)
        deEndBut.addTarget(self, action: #selector(setDeMaxAction), for: .touchUpInside)
        
        coStartBut.addTarget(self, action: #selector(setCoMinAction), for: .touchUpInside)
        coEndBut.addTarget(self, action: #selector(setCoMaxAction), for: .touchUpInside)
        
    }
    
    
    
    @objc private func setDeMinAction() {
        clickBlock?("deMin")
        
    }
    
    @objc private func setDeMaxAction() {
        clickBlock?("deMax")
        
    }
    
    @objc private func setCoMinAction() {
        clickBlock?("coMin")
    }
    
    @objc private func setCoMaxAction() {
        clickBlock?("coMax")
    }
    
    func setCellData(model: TimeRangeModel) {
        self.coStartBut.setTitle(String(model.coMin), for: .normal)
        self.coEndBut.setTitle(String(model.coMax), for: .normal)
        self.deStartBut.setTitle(String(model.deMin), for: .normal)
        self.deEndBut.setTitle(String(model.deMax), for: .normal)
    }
    
    
    
    
}
