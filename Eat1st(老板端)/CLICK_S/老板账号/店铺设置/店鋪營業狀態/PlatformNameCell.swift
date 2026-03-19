//
//  PlatformNameCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/3/18.
//

import UIKit

class PlatformNameCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .left)
        lab.text = "Eat1st"
        return lab
    }()
    
    

    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 4, height: 14))
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalTo(line)
            $0.left.equalTo(line.snp.right).offset(8)
        }
        
    }
    
    
    
}


class PlatformSelectCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_2
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    let selectLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "Not have"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        backView.addSubview(selectLab)
        selectLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-50)
        }
        
    }
    
}



class PlatformSwitchCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "Eat1st"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let switchBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off_b"), for: .normal)
        return but
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, SFONT(10), .center)
        lab.text = "CLOSED"
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 3
        lab.backgroundColor = HCOLOR("#F1F1F1")
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.addSubview(switchBut)
        switchBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 60, height: 50))
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(switchBut.snp.left).offset(-5)
            $0.size.equalTo(CGSize(width: 50, height: 20))
        }

        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.right.equalTo(statusLab.snp.left).offset(-10)
        }

        
        switchBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickAction() {
        clickBlock?("")
    }
    
    
    func setCellData(model: platformStatusModel) {
        titlab.text = model.name
        if model.onLine {
            switchBut.setImage(LOIMG("slider_on_b"), for: .normal)
            statusLab.text = "OPEN"
            statusLab.backgroundColor = HCOLOR("#DFFFE5")
            statusLab.textColor = HCOLOR("#4CD26C")
        } else {
            switchBut.setImage(LOIMG("slider_off_b"), for: .normal)
            statusLab.text = "CLOSE"
            statusLab.backgroundColor = HCOLOR("#F1F1F1")
            statusLab.textColor = TXTCOLOR_1
        }
    }
    
}
