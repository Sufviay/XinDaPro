//
//  DishDetailMsgCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailMsgCell: BaseTableViewCell {


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Menu numbering"
        return lab
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(35)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        self.titleLab.text = titStr
        self.msgLab.text = msgStr
        
        if titStr == "Price" {
            self.msgLab.textColor = HCOLOR("#6B7DFD")
        } else {
            self.msgLab.textColor = HCOLOR("666666")
        }
        
    }
    
}


class DishDetailPriceCell: BaseTableViewCell {


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Price"
        return lab
    }()
    
    private let disPriceLab: UILabel = {
        let lab = UILabel()
        //666666
        lab.setCommentStyle(HCOLOR("#6B7DFD"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let oldPriceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#999999")
        return view
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(disPriceLab)
        disPriceLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(oldPriceLab)
        oldPriceLab.snp.makeConstraints {
            $0.centerY.equalTo(disPriceLab)
            $0.left.equalTo(disPriceLab.snp.right).offset(5)
        }
        
        oldPriceLab.addSubview(line)
        line.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
    
    func setCellData(model: DishDetailModel, type: String) {
        
        
        if type == "1" {
            self.titleLab.text = "Delivery Price"
        }
        if type == "2" {
            self.titleLab.text = "Dine-in Price"
        }
        
        if model.discountType == "2" {
            //有优惠
            
            if type == "1" {
                
                self.oldPriceLab.text = "£\(model.deliPrice)"
                if model.deliPrice == "0" || model.deliPrice == "" {
                    self.oldPriceLab.isHidden = true
                } else {
                    self.oldPriceLab.isHidden = false
                }
            }
            if type == "2" {
                self.oldPriceLab.text = "£\(model.dinePrice)"
                if model.dinePrice == "0" || model.dinePrice == "" {
                    self.oldPriceLab.isHidden = true
                } else {
                    self.oldPriceLab.isHidden = false
                }

            }
            
            self.disPriceLab.text = "£\(model.discountPrice)"
            self.disPriceLab.textColor = HCOLOR("#6B7DFD")
        } else {
            self.oldPriceLab.isHidden = true
            self.oldPriceLab.text = ""
            if type == "1" {
                self.disPriceLab.text = "£\(model.deliPrice)"
            }
            if type == "2" {
                self.disPriceLab.text = "£\(model.dinePrice)"
            }
            self.disPriceLab.textColor = HCOLOR("#666666")
        }
        
    }
    
}



class DishDetailOptionMsgCell: BaseTableViewCell {


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Menu numbering"
        return lab
    }()
    
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(35)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        self.titleLab.text = titStr
        self.msgLab.text = msgStr
    }
    
}

