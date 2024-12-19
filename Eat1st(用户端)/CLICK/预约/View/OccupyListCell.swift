//
//  OccupyListCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/12.
//

import UIKit

class OccupyListCell: BaseTableViewCell {

    var cancelBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let statusImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("yuyue_success")
        return img
    }()
    
    private let storeNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "McDonald's® London"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
        lab.text = "Name:"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
        lab.text = "phone:"
        return lab
    }()

    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
        lab.text = "Date:"
        return lab
    }()
    
//    private let tlab4: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
//        lab.text = "Eamil:"
//        return lab
//    }()

    
    private let tlab5: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
        lab.text = "Party:"
        return lab
    }()
    
    private let namelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(13), .left)
        lab.text = "Mr. Zhang"
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.text = "2022-01-20 08:00PM"
        return lab
    }()
    
    private let numLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.text = "10"
        return lab
    }()

    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(13), .left)
        lab.text = "01933 403500"
        return lab
    }()
//    
//    private let emailLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(13), .left)
//        lab.text = ""
//        return lab
//    }()

    
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", .black, BFONT(10), MAINCOLOR)
        but.layer.cornerRadius = 5
        but.clipsToBounds = true
        return but
    }()

    
    
    

    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(statusImg)
        statusImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        backView.addSubview(storeNameLab)
        storeNameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalTo(statusImg.snp.left).offset(-10)
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(tlab1.snp.bottom).offset(7)
        }

        
        backView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(tlab2.snp.bottom).offset(7)
        }
        
//        backView.addSubview(tlab4)
//        tlab4.snp.makeConstraints {
//            $0.left.equalTo(tlab1)
//            $0.top.equalTo(tlab3.snp.bottom).offset(7)
//        }
        
        backView.addSubview(tlab5)
        tlab5.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(tlab3.snp.bottom).offset(7)
        }


        backView.addSubview(namelab)
        namelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.centerY.equalTo(tlab1)
        }
        
        backView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.left.equalTo(namelab)
            $0.centerY.equalTo(tlab2)
        }

        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalTo(namelab)
            $0.centerY.equalTo(tlab3)
        }
        
//        backView.addSubview(emailLab)
//        emailLab.snp.makeConstraints {
//            $0.left.equalTo(namelab)
//            $0.centerY.equalTo(tlab4)
//        }
//        
        backView.addSubview(numLab)
        numLab.snp.makeConstraints {
            $0.left.equalTo(namelab)
            $0.centerY.equalTo(tlab5)
        }
        

        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 20))
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(80)
        }
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
    }
    
    
    @objc private func clickCancelAction() {
        cancelBlock?("")
    }
    
    
    func setCellData(model: OccupyListModel) {
        storeNameLab.text = model.storeName
        namelab.text = model.name
        phoneLab.text = model.phone == "" ? "--" : model.phone
        numLab.text = model.reserveNum
        timeLab.text = "\(model.reserveDate)  \(model.reserveTime)"
        //emailLab.text = model.email == "" ? "--" : model.email
        
        if model.reserveStatus == "1" {
            cancelBut.isHidden = false
            statusImg.isHidden = true
        }
        if model.reserveStatus == "2" {
            //拒绝
            cancelBut.isHidden = true
            statusImg.isHidden = false
            statusImg.image = LOIMG("yuyue_unsuccess")
        }
        if model.reserveStatus == "3" {
            //取消
            cancelBut.isHidden = true
            statusImg.isHidden = false
            statusImg.image = LOIMG("yuyue_cancel")
        }
        if model.reserveStatus == "4" {
            //成功
            cancelBut.isHidden = true
            statusImg.isHidden = false
            statusImg.image = LOIMG("yuyue_success")
        }
        
    }
    
}
