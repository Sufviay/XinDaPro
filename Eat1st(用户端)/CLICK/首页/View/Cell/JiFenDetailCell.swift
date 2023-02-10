//
//  JiFenDetailCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/8.
//

import UIKit

class JiFenDetailCell: BaseTableViewCell {
    
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(14), .left)
        lab.text = "consumption"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .left)
        lab.text = "2022-01-10 01:21:51"
        return lab
    }()
    
    private let jifenLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .right)
        lab.text = "+100"
        lab.isHidden = false
        return lab
    }()
    
    
    private let expNumbLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F86143"), BFONT(15), .right)
        lab.text = "100"
        lab.isHidden = true
        return lab
    }()
    
    private let expLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F86143"), BFONT(10), .right)
        lab.text = "Expire"
        lab.isHidden = true
        return lab
    }()
    
    private let getJiFenLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(10), .right)
        lab.text = "+100"
        lab.isHidden = true
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("s_next")
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 11, height: 11))
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(jifenLab)
        jifenLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        
        contentView.addSubview(getJiFenLab)
        getJiFenLab.snp.makeConstraints {
            $0.centerY.equalTo(timeLab)
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(expLab)
        expLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab).offset(2)
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(expNumbLab)
        expNumbLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.right.equalTo(expLab.snp.left).offset(-2)
        }
        
        
        
    }
    
    
    func setCellData(model: JiFenDetalModel, type: String) {
        
        self.titlab.text = model.name
        self.timeLab.text = model.time
        
        if model.orderID != "" {
            self.nextImg.isHidden = false
        } else {
            self.nextImg.isHidden = true
        }
        
        
        //1订单消费，2积分兑换，3投诉扣减，4平台补回，5过期失效
        if model.type == "1" || model.type == "4"  {
            self.jifenLab.textColor = HCOLOR("#000000")
            self.jifenLab.text = "+\(model.number)"
            
            self.getJiFenLab.textColor = HCOLOR("#000000")
            self.getJiFenLab.text = "+\(model.number)"

        } else if model.type == "5" || model.type == "3" {
            //过期
            self.jifenLab.textColor = HCOLOR("#AAAAAA")
            self.jifenLab.text = "-\(model.number)"
            
            self.getJiFenLab.textColor = HCOLOR("#AAAAAA")
            self.getJiFenLab.text = "-\(model.number)"
            
            
        } else {
            self.jifenLab.textColor = HCOLOR("#F86143")
            self.jifenLab.text = "-\(model.number)"
            
            self.getJiFenLab.textColor = HCOLOR("#F86143")
            self.getJiFenLab.text = "-\(model.number)"
        }
        
        
        
        
        if type == "2" && model.useNum != 0 && model.useNum != model.number {
            
            self.jifenLab.isHidden = true
            
            self.getJiFenLab.isHidden = false
            self.expLab.isHidden = false
            self.expNumbLab.isHidden = false
            self.expNumbLab.text = "\(model.number - model.useNum)"
                
                
            
        } else {
            
            self.jifenLab.isHidden = false
            
            self.getJiFenLab.isHidden = true
            self.expLab.isHidden = true
            self.expNumbLab.isHidden = true
            self.expNumbLab.text = ""
            
        }
        
        
    }
    

}
