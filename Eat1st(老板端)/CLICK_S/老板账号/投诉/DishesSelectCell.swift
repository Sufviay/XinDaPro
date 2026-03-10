//
//  DishesSelectCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/30.
//

import UIKit

class DishesSelectCell: BaseTableViewCell {
    
    var clickCountBlock: VoidIntBlock?

    private let picImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = BACKCOLOR_2
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, BFONT(14), .left)
        lab.text = "Spicy burger Spicy burger Spicy burger Spicy burger Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), SFONT(13), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(15), .right)
        lab.text = "4.8"
        return lab
    }()
    
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 0
        return lab
    }()

    

    private lazy var selectView: CountSelectView = {
        let view = CountSelectView()
        view.countBlock = { [unowned self] (count) in
            print(count as! Int)
            clickCountBlock?(count as! Int)
            
        }
        return view
    }()

    

    
    
    
    
    override func setViews() {
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.left.equalToSuperview().offset(20)
        }
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(85)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(10)
        }
        
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        

        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(moneyLab.snp.bottom).offset(15)
        }

        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(85)
            $0.right.equalToSuperview().offset(-110)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
    
    }
    
    
    
    func setCellData(model: OrderDishModel) {
        picImg.sd_setImage(with: URL(string: model.imageUrl))
        nameLab.text = model.nameStr
        moneyLab.text = model.dishesPrice
        desLab.text = model.desStr
        
        selectView.maxCount = model.plaintNum
        selectView.count = model.selectCount

    }

}
