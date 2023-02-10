//
//  StoreSalesCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit

class StoreSalesCell: BaseTableViewCell {


    private let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#1E1F31"), BFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "Sweet & Sour Chicken Balls"
        return lab
    }()
    
    private let salesLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFA400"), BFONT(13), .left)
        lab.text = "£248"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#1E1F31"), BFONT(13), .left)
        lab.text = "46"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(10), .left)
        lab.text = "sales"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(10), .left)
        lab.text = "orders"
        return lab
    }()


    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()
    
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-50)
        }
        
        contentView.addSubview(salesLab)
        salesLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(8)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalTo(salesLab.snp.right).offset(2)
            $0.bottom.equalTo(salesLab).offset(-2)
        }
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalTo(tlab1.snp.right).offset(15)
            $0.bottom.equalTo(salesLab)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(orderLab.snp.right).offset(2)
            $0.bottom.equalTo(tlab1)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
    func setCellData(model: StoreSalesModel) {
        self.nameLab.text = model.storeName
        self.picImg.sd_setImage(with: URL(string: model.imgUrl))
        self.salesLab.text = "£\(D_2_STR(model.salesAmount))"
        self.orderLab.text = "\(model.salesNum)"
    }
  
    
    
    func setDishesCellData(model: DishesSalesModel) {
        self.nameLab.text = model.dishName
        self.picImg.sd_setImage(with: URL(string: model.imgUrl))
        self.salesLab.text = "£\(D_2_STR(model.salesAmount))"
        self.orderLab.text = "\(model.salesNum)"
    }
    
    
}
