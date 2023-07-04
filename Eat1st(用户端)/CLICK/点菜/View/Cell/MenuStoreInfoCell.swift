//
//  MenuStoreInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit


let MENU_STORE_NAME_W: CGFloat = S_W - 155
let MENU_STORE_TAGS_W: CGFloat = S_W - 145


class MenuStoreInfoCell: BaseTableViewCell {
    
    
    private var storeModel = StoreInfoModel()

        
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "McDonald's® London"
        lab.numberOfLines = 0
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let detailBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        return but
    }()
    

    private let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "Sandwiches·Breakfast·Lunch"
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: 90, height: 14))
        view.isCanTap = false
        return view
    }()

    private let pointLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
        lab.text = "4.0"
        return lab
    }()

    
    private let plCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(12), .left)
        lab.text = "view 138 reviews"
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    
    private let deQSLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = "no min. order"
        return lab
    }()
    
    private let coQSlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = ",No minimum for collection"
        return lab
    }()
    
    private let psMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
        lab.text = "Delivery from £4.8-£4.8"
        return lab
    }()
    
    
    
    override func setViews() {
    
        contentView.backgroundColor = .white
        
        contentView.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 63, height: 63))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalTo(logoImg.snp.left).offset(-60)
        }
        
        contentView.addSubview(detailBut)
        detailBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.size.equalTo(CGSize(width: 20, height: 15))
            $0.left.equalTo(nameLab.snp.right).offset(10)
        }
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalTo(logoImg.snp.left).offset(-50)
        }
        
        contentView.addSubview(starView)
        starView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(tagLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(pointLab)
        pointLab.snp.makeConstraints {
            $0.centerY.equalTo(starView)
            $0.left.equalTo(starView.snp.right).offset(5)
        }
        
        contentView.addSubview(plCountLab)
        plCountLab.snp.makeConstraints {
            $0.centerY.equalTo(starView)
            $0.left.equalTo(pointLab.snp.right).offset(15)
        }
        
        contentView.addSubview(deQSLab)
        deQSLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(starView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(coQSlab)
        coQSlab.snp.makeConstraints {
            $0.centerY.equalTo(deQSLab)
            $0.left.equalTo(deQSLab.snp.right).offset(1)
        }
        
        contentView.addSubview(psMoneyLab)
        psMoneyLab.snp.makeConstraints {
            $0.left.equalTo(deQSLab)
            $0.top.equalTo(deQSLab.snp.bottom).offset(8)
        }
        

        let reviewsTap = UITapGestureRecognizer(target: self, action: #selector(clickReviewsAction))
        self.plCountLab.addGestureRecognizer(reviewsTap)
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(clickDesAction))
        self.nameLab.addGestureRecognizer(detailTap)
        
        detailBut.addTarget(self, action: #selector(clickDesAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickReviewsAction() {
        let nextVC = StoreReviewsController()
        nextVC.storeID = storeModel.storeID
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc private func clickDesAction() {
        let nextVC = StoreIntroduceController()
        nextVC.storeInfoModel = storeModel
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    

    
    
    
    func setCellData(model: StoreInfoModel) {
        self.storeModel = model
        self.logoImg.sd_setImage(with: URL(string: model.logoImg), placeholderImage: LOIMG("zwt_1"))
        self.nameLab.text = model.name
        self.tagLab.text = model.tags
        self.starView.setPointValue = Int(ceil(model.star))
        self.pointLab.text = String(format: "%.1f", model.star)
        self.plCountLab.text = "view \(model.evaluateNum) reviews"
        self.deQSLab.text = model.minOrderStr
        
        if model.maxDelivery == 0 {
            if model.minDelivery == 0 {
                //没有起送费
                self.psMoneyLab.text = "No delivery fee"
                self.psMoneyLab.textColor = HCOLOR("#666666")
                //self.checkPSBut.isHidden = true
            } else {
                //设置的配送费
                self.psMoneyLab.text = "Delivery £\(model.minDelivery)"
                self.psMoneyLab.textColor = HCOLOR("#666666")
                //self.checkPSBut.isHidden = true
            }
        } else {
            self.psMoneyLab.text = "Delivery from £\(model.minDelivery)-£\(model.maxDelivery)"
            self.psMoneyLab.textColor = MAINCOLOR
            //self.checkPSBut.isHidden = false
        }
    }
    
    
    override func reSetFrame() {
                
        //获取UIlabel的行数
        let h = nameLab.text!.getTextHeigh(BFONT(18), MENU_STORE_NAME_W)
        let lineNum = Int(ceil(h / nameLab.font.lineHeight))

        if lineNum > 1 {
            detailBut.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(17)
                $0.size.equalTo(CGSize(width: 20, height: 15))
                $0.right.equalToSuperview().offset(-110)
            }
        } else {
            
            let w = nameLab.text!.getTextWidth(BFONT(18), nameLab.font.lineHeight)
            detailBut.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 20, height: 15))
                $0.top.equalToSuperview().offset(17)
                $0.left.equalToSuperview().offset(w + 10)
            }
        }
    }
}
