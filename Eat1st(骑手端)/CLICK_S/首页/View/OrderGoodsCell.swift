//
//  OrderGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderGoodsCell: BaseTableViewCell {

    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Dish Name 1"
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
        lab.text = "10.9"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(14), .right)
        lab.text = "x2"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "options,options,options,options"
        return lab
    }()
    
    
    private let giveOneBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFD645").withAlphaComponent(0.12)
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    private let freeMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(8), .left)
        lab.text = "£0.00"
        return lab
    }()
    
    private let freeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("free")
        return img
    }()
    
    private let freeCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(10), .right)
        lab.text = "x2"
        return lab
    }()

    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 60))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(3)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
            
        contentView.addSubview(giveOneBackView)
        giveOneBackView.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-110)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        giveOneBackView.addSubview(freeMoneyLab)
        freeMoneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(6)
        }
        
        giveOneBackView.addSubview(freeImg)
        freeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 11))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(35)
        }
        
        giveOneBackView.addSubview(freeCountLab)
        freeCountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }

        
    }
    
    
    func setCellData(model: OrderDishModel) {
        
        if model.isGiveOne {
            giveOneBackView.isHidden = false
            
        } else {
            giveOneBackView.isHidden = true
        }
        
        freeCountLab.text = "x\(model.count)"
        countLab.text = "x\(model.count)"
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), completed: nil)
        nameLab.text = model.nameStr
        desLab.text = model.desStr
        self.moneyLab.text = D_2_STR(model.subFee)
    }
    
}




class OrderGiftCell: BaseTableViewCell {
    
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(16), .left)
        lab.text = "Gift"
        return lab
    }()
    
    override func setViews() {
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
}




class OrderGoodsFreeCell: BaseTableViewCell {

    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Dish Name 1"
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    

    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(14), .right)
        lab.text = "x1"
        return lab
    }()
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .right)
        lab.text = "FREE"
        return lab
    }()
        

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 60))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
            $0.bottom.equalToSuperview().offset(-20)
        }
                
        
        contentView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(freeLab.snp.bottom).offset(3)
            $0.right.equalToSuperview().offset(-10)
        }
        
    }
    
    
    func setCellData(model: OrderDishModel) {
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), completed: nil)
        nameLab.text = model.nameStr
    }
    
}




