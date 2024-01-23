//
//  DishDetailAllregenCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/17.
//

import UIKit

class DishDetailAllregenCell: BaseTableViewCell {

    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinggao")
        return img
    }()
    
  
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.text = "Allergen:"
        return lab
    }()
    
    private let allergenlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("##080808"), BFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 60, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()
    


    override func setViews() {
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 11))
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(5)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(6)
        }
        
        contentView.addSubview(allergenlab)
        allergenlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-25)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
    
    
    func setCellData(allergenStr: String) {
        allergenlab.text = allergenStr
    }
    
}
