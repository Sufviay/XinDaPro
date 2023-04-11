//
//  StoreTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/28.
//

import UIKit

class StoreTableCell: BaseTableViewCell {

    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        
        return view
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        //这样会导致阴影设置无效
        view.layer.masksToBounds = true
        return view
    }()

    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.image = LOIMG("Please wait …")
        return img
    }()
    
    private let discountImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let firstBackImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("discount_backImg")
        return img
    }()
    
    private let firstScaleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(11), .center)
        lab.text = "25%OFF"
        return lab
    }()
    
    
    
    private let zhanWeiImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Greggs-Milton Keynes"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = "Fried chicken burger"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let disLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
        lab.text = "1.1miles"
        return lab
    }()
    
//    private let timeLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
//        lab.text = "55mins"
//        return lab
//    }()
    
//    private let s_img1: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("first_time")
//        return img
//    }()
//
    
    private let s_img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_dis")
        return img
    }()

    private let psMoneuLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = "Delivery from £60"
        return lab
    }()
    
    private let qsMoneuLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.text = "No minimum order"
        return lab
    }()
    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 10))
        view.isCanTap = false
        return view
    }()
    
    
    

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
        }
        
        shadowView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        backView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-105)
            //$0.height.equalTo(R_W(355) * (9/16))
            //$0.height.equalTo(SET_H(225, 355))
        }
        
        picImg.addSubview(discountImg)
        discountImg.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 145, height: 25))
        }
        
        
        picImg.addSubview(firstBackImg)
        firstBackImg.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 145, height: 25))
        }
        
        firstBackImg.addSubview(firstScaleLab)
        firstScaleLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        picImg.addSubview(zhanWeiImg)
        zhanWeiImg.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 145, height: 25))
        }
        
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            //$0.top.equalTo(picImg.snp.bottom).offset(23)
            $0.bottom.equalToSuperview().offset(-70)
            $0.right.equalToSuperview().offset(-80)
        }
        
        
        backView.addSubview(starView)
        starView.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 70, height: 10))
        }

        
        backView.addSubview(disLab)
        disLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-7)
            $0.top.equalTo(nameLab.snp.bottom).offset(10)
        }
        
        
        backView.addSubview(s_img2)
        s_img2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 13))
            $0.centerY.equalTo(disLab)
            $0.right.equalTo(disLab.snp.left).offset(-2)
        }

//        backView.addSubview(timeLab)
//        timeLab.snp.makeConstraints {
//            $0.right.equalTo(s_img2.snp.left).offset(-8)
//            $0.centerY.equalTo(disLab)
//        }
//
//        backView.addSubview(s_img1)
//        s_img1.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 13, height: 13))
//            $0.centerY.equalTo(s_img2)
//            $0.right.equalTo(timeLab.snp.left).offset(-2)
//        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalTo(nameLab.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-150)
            //$0.right.equalTo(s_img1.snp.left).offset(-15)
        }
        
        backView.addSubview(psMoneuLab)
        psMoneuLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
        }
        
        backView.addSubview(qsMoneuLab)
        qsMoneuLab.snp.makeConstraints {
            $0.left.equalTo(psMoneuLab.snp.right).offset(10)
            $0.centerY.equalTo(psMoneuLab)
        }
        
        
    }
 
    
    func setCellData(model: StoreInfoModel) {
        
        self.picImg.sd_setImage(with: URL(string: model.coverImg)) //setImage(imageStr: model.coverImg)
        self.nameLab.text = model.name
        self.desLab.text = model.tags
        self.disLab.text = model.distance
        self.psMoneuLab.text = model.deliveryFeeStr
        self.qsMoneuLab.text = model.minOrderStr
//        self.timeLab.text = model.minTime
        self.starView.setPointValue = Int(ceil(model.star))
        self.firstScaleLab.text = model.firstDiscountScale
        
        
        if UserDefaults.standard.isLogin {
            
            if model.isFirstDiscount == nil {
                                
                self.discountImg.isHidden = true
                self.firstBackImg.isHidden = true
            } else {
                if model.firstDiscountIsOpen {
                    if model.isFirstDiscount! {
                        self.discountImg.isHidden = true
                        self.firstBackImg.isHidden = false
                        
                    } else {
                        self.firstBackImg.isHidden = true
                        
                        if model.discountImgUrl == "" {
                            self.discountImg.isHidden = true
                            
                        } else {
                            self.discountImg.isHidden = false
                            
                            self.discountImg.sd_setImage(with: URL(string: model.discountImgUrl), placeholderImage: LOIMG("discount_img"))
                        }
                    }
                    
                } else {
                    self.firstBackImg.isHidden = true
                    if model.discountImgUrl == "" {
                        self.discountImg.isHidden = true
                        
                    } else {
                        self.discountImg.isHidden = false
                        self.discountImg.sd_setImage(with: URL(string: model.discountImgUrl), placeholderImage: LOIMG("discount_img"))
                    }
                }
                
            }
            
        } else {
            self.firstBackImg.isHidden = true
            
            if model.discountImgUrl == "" {
                self.discountImg.isHidden = true
                
            } else {
                self.discountImg.isHidden = false
                
                self.discountImg.sd_setImage(with: URL(string: model.discountImgUrl), placeholderImage: LOIMG("discount_img"))
            }
            
        }
        

        
        if model.leftImgUrl == "" {
            self.zhanWeiImg.isHidden = true
        } else {
            self.zhanWeiImg.isHidden = false
        }
        
        if model.leftImgUrl != "" {
            
            self.zhanWeiImg.sd_setImage(with: URL(string: model.leftImgUrl))
            
            //self.zhanWeiImg.sd_setImage(with: URL(string: model.leftImgUrl), placeholderImage: nil, options: .fromLoaderOnly, context: [SDWebImageContextOption.storeCacheType: "SDImageCacheTypeNone"])
        }
        
    }
    
}
