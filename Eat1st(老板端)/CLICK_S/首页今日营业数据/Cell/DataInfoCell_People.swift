//
//  DataInfoCell_People.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/8.
//

import UIKit

class DataInfoCell_People: UICollectionViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F8FF")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.text = "Customer".local
        return lab
    }()
    

    
    private let numberlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), BFONT(20), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "9999"
        return lab
    }()
    
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("chengren")
        return img
    }()

    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ertong")
        return img
    }()


    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#666666")
        return view
    }()
    
    private let crlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), BFONT(14), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "9999"
        return lab
    }()

    
    private let etlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), BFONT(14), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "9999"
        return lab
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), SFONT(10), .left)
        lab.text = "较上周二"
        return lab
    }()
    
    private let simg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("up")
        return img
    }()
    
    private let tblab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#E9522F"), SFONT(10), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "99999"
        return lab
    }()



    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 15))
            $0.top.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-65)
        }
        
        backView.addSubview(img1)
        img1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 11))
            $0.left.equalTo(line.snp.right).offset(5)
            $0.bottom.equalTo(line.snp.centerY).offset(-1.5)
        }
        
        backView.addSubview(img2)
        img2.snp.makeConstraints {
            $0.left.size.equalTo(img1)
            $0.top.equalTo(line.snp.centerY).offset(1.5)
        }
        
        backView.addSubview(crlab)
        crlab.snp.makeConstraints {
            $0.left.equalTo(img1.snp.right).offset(4)
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalTo(img1)
        }
        
        backView.addSubview(etlab)
        etlab.snp.makeConstraints {
            $0.left.equalTo(img2.snp.right).offset(4)
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalTo(img2)
        }
        
        backView.addSubview(numberlab)
        numberlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalTo(line.snp.left).offset(-10)
            $0.centerY.equalTo(line)
        }
        
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.width.equalTo(50)
        }
        
        backView.addSubview(simg)
        simg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 9))
            $0.centerY.equalTo(tlab)
            $0.left.equalTo(tlab.snp.right)
        }
        
        backView.addSubview(tblab)
        tblab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.left.equalTo(simg.snp.right).offset(2)
            $0.right.equalToSuperview().offset(-20)
        }

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(number: String, crNum: String, etNum: String, compareNum: String ,floatingType: String, week: String) {
        
        
        numberlab.text = number
        crlab.text = crNum
        etlab.text = etNum
        
        tlab.text = "Last ".local + week
        tblab.text = compareNum
        
        //（1上涨，2相等，3下降）
        if floatingType == "1" || floatingType == "2" {
            simg.image = LOIMG("up")
            tlab.textColor = HCOLOR("#E9522F")
            tblab.textColor = HCOLOR("#E9522F")
            
        } else {
            simg.image = LOIMG("down")
            tlab.textColor = HCOLOR("#19B366")
            tblab.textColor = HCOLOR("#19B366")
        }
        
        

        
        
    }
    
    
}
