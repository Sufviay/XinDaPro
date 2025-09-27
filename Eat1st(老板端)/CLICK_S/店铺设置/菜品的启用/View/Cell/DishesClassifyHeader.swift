//
//  DishesClassifyHeader.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/10.
//

import UIKit

class DishesClassifyHeader: UITableViewHeaderFooterView {
    
    var clickBlock: VoidStringBlock?
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    
    let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Chow Mein Dishes"
        lab.numberOfLines = 0
        return lab
    }()
    
    let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_2, .left)
        lab.text = "aaaaa"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.setImage(LOIMG("unsel_f"), for: .normal)
        return but
    }()
    
    
    
    private let showImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_show")
        return img
    }()

    
//    private let t_line: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
    
    
    private let b_line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    
    

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        backBut.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        
        
        backBut.addSubview(b_line)
        b_line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        

        
        backBut.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.bottom.equalTo(backBut.snp.centerY).offset(0)
            $0.left.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-50)
        }
        
        backBut.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.top.equalTo(backBut.snp.centerY).offset(0)
            $0.right.equalToSuperview().offset(-50)
        }
        
            
        backBut.addSubview(showImg)
        showImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
        
        selectBut.addTarget(self, action: #selector(clickSelectAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickAciton() {
        clickBlock?("show")
    }
    
    @objc private func clickSelectAction() {
        clickBlock?("select")
    }
    
    
    func setCellData(model: F_DishModel) {
        
        self.namelab1.text = model.name1
        self.namelab2.text = model.name2
        if model.isShow {
            self.showImg.image = LOIMG("dish_hide")
        } else {
            self.showImg.image = LOIMG("dish_show")
        }
        
        if model.isSelectAll {
            self.selectBut.setImage(LOIMG("sel_f"), for: .normal)
        } else {
            self.selectBut.setImage(LOIMG("unsel_f"), for: .normal)
        }
        
    }
    
    
}
