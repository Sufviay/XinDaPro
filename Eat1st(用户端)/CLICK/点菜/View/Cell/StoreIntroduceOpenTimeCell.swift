//
//  StoreIntroduceOpenTimeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/10/26.
//

import UIKit

class StoreIntroduceOpenTimeCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()

    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Sunday"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .right)
        lab.text = "08:00 - 15:45"
        return lab
    }()


    private let pointView: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    

    
    override func setViews() {
        
        contentView.backgroundColor = .white

        
        contentView.addSubview(pointView)
        pointView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    
    func setCellData(weekStr: String, timeStr: String , isToday: Bool, status: String) {
        self.titLab.text = weekStr
        
        if isToday {
            self.pointView.isHidden = false
        } else {
            self.pointView.isHidden = true
        }
        
        if status == "1" {
            self.timeLab.text = timeStr
        } else {
            self.timeLab.text = "Closed"
        }
    }
    
}
