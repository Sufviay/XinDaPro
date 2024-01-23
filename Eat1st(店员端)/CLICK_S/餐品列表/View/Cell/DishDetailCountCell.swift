//
//  DishDetailCountCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/16.
//

import UIKit

class DishDetailCountCell: BaseTableViewCell {

    
    var countBlock: VoidIntBlock?
    

    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(14), .left)
        return lab
    }()
    
    private lazy var selectView: CountSelectView = {
        let view = CountSelectView()
        view.canBeZero = false
        view.countBlock = { [unowned self] (count) in
            countBlock?(count as! Int)
        }
        return view
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(moneylab)
        }

        
    }
    
    
    func setCellData(money: String, buyNum: Int) {
        moneylab.text = "£\(money)"
        selectView.count = buyNum
    }

}
