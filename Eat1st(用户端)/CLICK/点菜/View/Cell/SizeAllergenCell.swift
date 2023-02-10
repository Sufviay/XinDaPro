//
//  SizeAllergenCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/21.
//

import UIKit

class SizeAllergenCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("allergen")
        return img
    }()

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Allergen: peanuts、peanuts、peanuts"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    func setCellData(str: String) {
        self.titLab.text = "Allergen: \(str)"
    }
    
    
}
