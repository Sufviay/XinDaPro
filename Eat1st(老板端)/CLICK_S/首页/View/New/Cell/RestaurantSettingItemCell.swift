//
//  RestaurantSettingItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/8.
//

import UIKit

class RestaurantSettingItemCell: BaseTableViewCell {


    private let sImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(17), .left)
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("set_next")
        return img
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    override func setViews() {
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.top.equalTo(sImg).offset(-2)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.top.equalTo(nameLab.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-70)
        }
        
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        
    }
    
    
    func setCellData(imgStr: String, nameStr: String, desStr: String) {
        self.nameLab.text = nameStr
        self.desLab.text = desStr
        self.sImg.image = LOIMG(imgStr)
    }
    
    
}
