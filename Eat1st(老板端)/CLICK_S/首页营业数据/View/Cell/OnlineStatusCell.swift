//
//  OnlineStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit

class OnlineStatusCell: BaseTableViewCell {


    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_status")
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(18), .left)
        lab.text = "Online Status"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(13), .left)
        lab.text = "You're currently"
        return lab
    }()

    private let setBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Settings", HCOLOR("#1E66FD"), BFONT(11), .white)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let statusImg: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 50, height: 20))
        img.clipsToBounds = true
        img.layer.cornerRadius = 3
        return img
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Open"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(20)
        }
        
        backImg.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        backImg.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-26)
        }
        
        backImg.addSubview(setBut)
        setBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
            $0.size.equalTo(CGSize(width: 95, height: 30))
        }
        
        backImg.addSubview(statusImg)
        statusImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.left.equalTo(tlab2.snp.right).offset(10)
            $0.centerY.equalTo(tlab2)
            
        }
        
        statusImg.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        setBut.addTarget(self, action: #selector(clickSettingAction), for: .touchUpInside)
        
    }
    
    @objc private func clickSettingAction() {
        
        let nextVC = StoreTimeSettingController()
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func setCellData(isOnLine: Bool) {
        if isOnLine {
            self.statusImg.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 50, height: 20))
            self.statusLab.text = "Open"
            self.statusLab.textColor = .white
        } else {
            self.statusImg.image = GRADIENTCOLOR(HCOLOR("#F8F9F9"), HCOLOR("#F8F9F9"), CGSize(width: 50, height: 20))
            self.statusLab.text = "Close"
            self.statusLab.textColor = HCOLOR("#AAAAAA")
        }
    
    }


}


class LiveRepotingCell: BaseTableViewCell {
    
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Live Reporting"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 70, height: 3))
        }
        
    }
    
    
    func setCellData(titStr: String) {
        self.titlab.text = titStr
        
        if titStr == "Live Reporting" || titStr == "Sales".local {
            line.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        }
        if titStr == "Real time order" || titStr == "Expenditure" {
            line.image = GRADIENTCOLOR(HCOLOR("#2C6BF8"), HCOLOR("#6B12CC"), CGSize(width: 70, height: 3))
        }
        
    }
    
}
