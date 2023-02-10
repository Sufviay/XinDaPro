//
//  FirstActivityTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class FirstActivityTableCell: BaseTableViewCell {


    private let wheelView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_wheel")
        return img
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Flash sale"
        return lab
    }()
    
    private let m_img: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HCOLOR("F9F9F9")
        img.image = LOIMG("goods1")
        return img
    }()
    
    private let hourLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .center)
        lab.backgroundColor = MAINCOLOR
        lab.layer.cornerRadius = 2
        lab.textAlignment = .center
        lab.text = "00"
        lab.clipsToBounds = true
        return lab
    }()
    
    private let minLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .center)
        lab.backgroundColor = MAINCOLOR
        lab.layer.cornerRadius = 2
        lab.textAlignment = .center
        lab.text = "00"
        lab.clipsToBounds = true
        return lab
    }()
    
    
    private let secLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .center)
        lab.backgroundColor = MAINCOLOR
        lab.layer.cornerRadius = 2
        lab.textAlignment = .center
        lab.text = "00"
        lab.clipsToBounds = true
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(11), .center)
        lab.text = ":"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(11), .center)
        lab.text = ":"
        return lab
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Burger combo"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(15), .left)
        lab.text = "10.9"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(10), .left)
        lab.text = "£"
        return lab
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(wheelView)
        wheelView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(R_W(185))
            $0.height.equalTo(SET_H(145, 185))
            $0.top.equalToSuperview()
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(wheelView.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(wheelView)
        }
    
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalToSuperview().offset(5)
        }
        
        backView.addSubview(secLab)
        secLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.right.equalToSuperview().offset(-7)
            $0.centerY.equalTo(tlab)
        }
        
        backView.addSubview(minLab)
        minLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.right.equalTo(secLab.snp.left).offset(-7)
            $0.centerY.equalTo(tlab)
        }
        
        backView.addSubview(hourLab)
        hourLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.right.equalTo(minLab.snp.left).offset(-7)
            $0.centerY.equalTo(tlab)
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalTo(hourLab.snp.right)
            $0.right.equalTo(minLab.snp.left)
            $0.centerY.equalTo(hourLab)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(minLab.snp.right)
            $0.right.equalTo(secLab.snp.left)
            $0.centerY.equalTo(hourLab)
        }
        
        backView.addSubview(m_img)
        m_img.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.right.equalToSuperview().offset(-7)
            $0.top.equalToSuperview().offset(R_H(30))
            $0.bottom.equalToSuperview().offset(-R_H(40))
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalTo(m_img.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-7)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(13)
            $0.top.equalTo(nameLab.snp.bottom).offset(3)
        }
        
        backView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab.snp.bottom).offset(-2)
            $0.left.equalToSuperview().offset(7)
        }
        
    }
    
    
}
