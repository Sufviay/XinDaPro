//
//  PrinterDishesCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/2/6.
//

import UIKit

class PrinterDishesCell: BaseTableViewCell {

    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "Name"
        lab.numberOfLines = 0
        return lab
    }()
        
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    override func setViews() {
        

        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(namelab1.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-20)

        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setCellData(name1: String, name2: String) {
        self.namelab1.text = name1
        self.namelab2.text = name2
    }

    
}
