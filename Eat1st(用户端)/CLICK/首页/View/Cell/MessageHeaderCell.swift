//
//  MessageHeaderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit

class MessageHeaderCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.numberOfLines = 0
        return lab
    }()

    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(10), .right)
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.right.equalToSuperview().offset(-14)
        }
        
        backView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-130)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    
    func setCellData(model: MessageModel) {
        self.titleLab.text = model.title
        self.timeLab.text = model.createTime
        self.backView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: model.t_H_detail + 25), byRoundingCorners: [.topLeft, .topRight], radii: 10)
    }
    
    
}


class MessageBottomCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 40), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)
        return view
    }()

    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("msg_next_y")
        return img
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let goLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(13), .left)
        lab.text = "To view"
        return lab
    }()

    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(goLab)
        goLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        
    }
    
    
}
