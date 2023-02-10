//
//  SetTimeDeCoTimeRangCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/9.
//

import UIKit

class SetTimeDeCoTimeRangCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(20), .left)
        lab.text = "Delivery time setting"
        return lab
    }()
    
    private let b_line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
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
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "The delivery time"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "The Collection time"
        return lab
    }()

    private let deStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 5
        but.setCommentStyle(.zero, "50", HCOLOR("080808"), BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let deEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "50", HCOLOR("080808"), BFONT(15), HCOLOR("#F8F9F9"))
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
        but.setCommentStyle(.zero, "100", HCOLOR("080808"), BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let coEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "100", HCOLOR("080808"), BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    
    private let t_lab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "min"
        return lab
    }()
    
    private let t_lab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "min"
        return lab
    }()

    


    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(line.snp.top).offset(-5)
        }

        
        contentView.addSubview(b_line)
        b_line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        
        contentView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(85)
        }
        
        contentView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-27)
        }
        
        contentView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.left.equalTo(point1.snp.right).offset(10)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.left.equalTo(point2.snp.right).offset(10)
        }
        
        
        contentView.addSubview(deEndBut)
        deEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-55)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(deEndBut.snp.left).offset(-7)
        }
        
        contentView.addSubview(deStartBut)
        deStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(line1.snp.left).offset(-7)
        }
        
        contentView.addSubview(coEndBut)
        coEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-55)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(coEndBut.snp.left).offset(-7)
        }
        
        contentView.addSubview(coStartBut)
        coStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(line2.snp.left).offset(-7)
        }
        
        contentView.addSubview(t_lab1)
        t_lab1.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(t_lab2)
        t_lab2.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-20)
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
