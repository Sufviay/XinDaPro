//
//  GiftBuiedCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/9.
//

import UIKit

class GiftBuiedCell: BaseTableViewCell {

    
    var clickShareBlock: VoidBlock?
    var clickCacnelBlock: VoidBlock?

    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card 1")
        return img
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Gift voucher"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let tImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        lab.text = "555"
        return lab
    }()

    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), BFONT(12), .left)
        lab.text = "2022-01-10 01:21:51"
        return lab
    }()
    
    private let shareBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "SHARE", .white, BFONT(10), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel exchange", MAINCOLOR, SFONT(8), .clear)
        but.clipsToBounds = true
        but.layer.cornerRadius = 5
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()
    
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(5), .left)
        lab.text = "Gift voucher"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let s_numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(10), .left)
        lab.text = "555"
        return lab
    }()
    
    private let alreadyView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("00C57B").withAlphaComponent(0.1)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = HCOLOR("#00C57B").cgColor
        return view
    }()
    
    private let alreadyImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("gifttake")
        return img
    }()
    
    private let alreadyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#00C57B"), SFONT(8), .left)
        lab.text = "Already receive"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(shareBut)
        shareBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 85, height: 25))
            $0.top.equalToSuperview().offset(13)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.right.equalTo(shareBut)
            $0.top.equalTo(shareBut.snp.bottom).offset(4)
            
        }
        
        contentView.addSubview(alreadyView)
        alreadyView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 85, height: 25))
        }
        
        alreadyView.addSubview(alreadyImg)
        alreadyImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(3)
        }
        
        alreadyView.addSubview(alreadyLab)
        alreadyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(alreadyImg.snp.right).offset(2)
        }

        
        contentView.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 85, height: 50))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalTo(cardImg.snp.right).offset(15)
            $0.top.equalTo(cardImg).offset(-3)
            $0.right.equalTo(shareBut.snp.left).offset(-15)
        }
        
        contentView.addSubview(tImg)
        tImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.left.equalTo(tLab)
            $0.top.equalTo(tLab.snp.bottom).offset(4)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalTo(tImg.snp.right).offset(2)
            $0.centerY.equalTo(tImg)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalTo(tLab)
            $0.top.equalTo(tImg.snp.bottom).offset(4)
        }
        

        
        cardImg.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 9, height: 9))
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(10)
        }
        
        cardImg.addSubview(s_numberLab)
        s_numberLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(2)
        }
        
        cardImg.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalTo(sImg.snp.bottom).offset(2)
        }
        
        shareBut.addTarget(self, action: #selector(clickShareAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
    }
    
    
    @objc private func clickShareAction() {
        clickShareBlock?("")
    }
    
    
    @objc private func clickCancelAction() {
        clickCacnelBlock?("")
    }
    
    
    func setCellData(model: GiftVoucherModel) {
        timeLab.text = model.createTime
        s_numberLab.text = D_2_STR(model.amount)
        numberLab.text = D_2_STR(model.amount)
        
        
        if model.giftStatus == "2" {
            //已领取
            tLab.text = model.takeName
            alreadyView.isHidden = false
            shareBut.isHidden = true
            cancelBut.isHidden = true
        } else {
            tLab.text = "Gift voucher"
            alreadyView.isHidden = true
            shareBut.isHidden = false
            cancelBut.isHidden = false
        }
        
    }
    

}
