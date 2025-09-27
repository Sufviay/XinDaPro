//
//  CancelReasonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/14.
//

import UIKit

class CancelReasonCell: BaseTableViewCell {

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Cancel the reason："
        return lab
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "I cannot receive takeout due to other matters"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)

        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(30)
        }
        
    }
    
    
    
    func setCellData(reason: String) {
        contentLab.text = reason
    }
    
    
}
