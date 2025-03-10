//
//  DataInfoCollectionCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit

class DataInfoCollectionCell: UICollectionViewCell {
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F8FF")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.text = "未结账收入"
        lab.numberOfLines = 2
        return lab
    }()
    
    private let numberlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), BFONT(22), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "9999"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), SFONT(10), .left)
        lab.text = "较上周二"
        lab.isHidden = true
        return lab
    }()
    
    private let simg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("up")
        img.isHidden = true
        return img
    }()
    
    private let tblab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#E9522F"), SFONT(10), .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "99999"
        lab.isHidden = true
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
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(numberlab)
        numberlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(35)
            //$0.top.equalTo(titlab.snp.bottom).offset(3)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(50)
            $0.bottom.equalToSuperview().offset(-15)
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
    
    
    func setCellData(titStr: String, number: String, compareNum: String, floatingType: String, week: String) {
        
        titlab.text = titStr
        numberlab.text = number
        
        
        
        
        if titStr == "Unpaid Amount".local || titStr == "Unpaid Order".local {
            numberlab.textColor = HCOLOR("#465DFD")
            numberlab.font = BFONT(28)
            
            tlab.isHidden = true
            simg.isHidden = true
            tblab.isHidden = true
            
        } else {
            numberlab.textColor = HCOLOR("#222222")
            numberlab.font = BFONT(22)
            
            tlab.isHidden = false
            simg.isHidden = false
            tblab.isHidden = false
            
            
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
    
    
}
