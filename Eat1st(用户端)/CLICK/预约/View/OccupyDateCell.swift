//
//  OccupyDateCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyDateCell: BaseTableViewCell {

    var clickNumBlock: VoidBlock?
    
    var clickDateBlock: VoidBlock?
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#999999")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Party"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Date"
        return lab
    }()
    
    private let numBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let dateBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let xl1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl")
        return img
    }()
    
    private let xl2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl")
        return img
    }()

    private let perNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = ""
        return lab
    }()

    

    override func setViews() {
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(150))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1, height: 35))
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(line1.snp.right).offset(25)
            $0.top.equalTo(tlab1)
        }
        
        contentView.addSubview(numBut)
        numBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(line1.snp.left)
            $0.bottom.equalToSuperview().offset(-15)
            $0.top.equalTo(tlab1.snp.bottom).offset(10)
        }
        
        contentView.addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.left.equalTo(line1.snp.right)
            $0.top.bottom.equalTo(numBut)
            $0.right.equalToSuperview()
        }
        
        numBut.addSubview(xl1)
        xl1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 5))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
        dateBut.addSubview(xl2)
        xl2.snp.makeConstraints {
            $0.size.centerY.equalTo(xl1)
            $0.right.equalToSuperview().offset(-35)
        }
        
        numBut.addSubview(perNumLab)
        perNumLab.snp.makeConstraints {
            $0.centerY.equalTo(xl1)
            $0.left.equalTo(tlab1)
        }
        
        dateBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalTo(xl2)
            $0.left.equalTo(tlab2)
        }
        
        dateBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
        numBut.addTarget(self, action: #selector(clickPersonAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickPersonAction() {
        clickNumBlock?("")
    }
    
    @objc private func clickDateAction() {
        clickDateBlock?("")
    }
    
    
    func setCellData(model: OccupyModel) {
        perNumLab.text = String(model.reserveNum)
        dateLab.text = model.date
        
    }
    
}
