//
//  BookingListContentCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class BookingListContentCell: BaseTableViewCell {


    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, BFONT(18), .left)
        lab.text = "Ms zhang"
        return lab
    }()
    
    private let statusImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("book_success")
        return img
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Date:"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Party:"
        return lab
    }()
    
//    private let tlab3: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
//        lab.text = "Table:"
//        return lab
//    }()
    
    
    private let tlab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Contact way:"
        return lab
    }()
    
    
    private let tlab5: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Email:"
        return lab
    }()
    
    
    private let tlab6: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Create time:"
        return lab
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .right)
        lab.text = "2022-06-08 08:00PM"
        return lab
    }()
    
    
    private let partyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .right)
        lab.text = "10"
        return lab
    }()
    
    
//    private let tableLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
//        lab.text = "04"
//        return lab
//    }()

    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = "01933 403500"
        return lab
    }()


    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = "136000000000@163.com"
        return lab
    }()

    
    private let createTimeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = "2022-06-08"
        return lab
    }()

    


    



    
    override func setViews() {
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(65)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(90)
        }
        
//        contentView.addSubview(tlab3)
//        tlab3.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalToSuperview().offset(115)
//        }
//
        
        contentView.addSubview(tlab4)
        tlab4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(115)
        }


        contentView.addSubview(tlab5)
        tlab5.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(140)
        }

        
        contentView.addSubview(tlab6)
        tlab6.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(165)
        }
        
        contentView.addSubview(statusImg)
        statusImg.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.size.equalTo(CGSize(width: 55, height: 19))
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        contentView.addSubview(partyLab)
        partyLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-20)
        }

//        contentView.addSubview(tableLab)
//        tableLab.snp.makeConstraints {
//            $0.centerY.equalTo(tlab3)
//            $0.right.equalToSuperview().offset(-20)
//        }

        
        contentView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab4)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab5)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(createTimeLab)
        createTimeLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab6)
            $0.right.equalToSuperview().offset(-20)
        }

    
    }
    
    
    
    func setCellDate(model: BookingContentModel) {
        if model.reserveStatus == "2" {
            //拒绝
            statusImg.isHidden = false
            statusImg.image = LOIMG("book_rej")
        }
        else if model.reserveStatus == "3" {
            //取消
            statusImg.isHidden = false
            statusImg.image = LOIMG("book_cancel")
        }
        else if model.reserveStatus == "4" {
            //成功
            statusImg.isHidden = false
            statusImg.image = LOIMG("book_success")
        }
        else if model.reserveStatus == "5" {
            //checkin
            statusImg.isHidden = false
            statusImg.image = LOIMG("book_checked In")
        }
        else {
            statusImg.isHidden = true
        }
        
        nameLab.text = model.name
        dateLab.text = "\(model.reserveDate) \(model.reserveTime)"
        partyLab.text = model.reserveNum
        //tableLab.text = model.deskName
        phoneLab.text = model.phone
        emailLab.text = model.email == "" ? "--" : model.email
        createTimeLab.text = model.createTime
        
    }
    
    
}
