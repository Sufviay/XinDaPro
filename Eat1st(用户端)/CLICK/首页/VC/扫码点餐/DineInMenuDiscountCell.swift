//
//  DineInMenuDiscountCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/17.
//

import UIKit

class DineInMenuDiscountCell: BaseTableViewCell {

    var clickRedeemBlock: VoidBlock?
        
    private let discountImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("discount")
        return img
    }()
    
    private let firstImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("scale_back1")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let scaleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(9), .left)
        lab.text = "55%OFF"
        return lab
    }()
    
    private let exchangeImg: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.image = LOIMG("jf_but")
        return img
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_next")
        return img
    }()
    
    private let exchangeLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.init(name: "Helvetica-Bold", size: 10)
        lab.textColor = HCOLOR("000000")
        lab.text = "Redeem"
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(discountImg)
        discountImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 18))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        
        contentView.addSubview(firstImg)
        firstImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 18))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(85)
        }
        
        firstImg.addSubview(scaleLab)
        scaleLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            
        }
        
                
        contentView.addSubview(exchangeImg)
        exchangeImg.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
            $0.width.equalTo(85)
        }
        
        
        exchangeImg.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 8))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
        
        exchangeImg.addSubview(exchangeLab)
        exchangeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextImg.snp.left).offset(-3)
        }
        
        
        let redeemTap = UITapGestureRecognizer(target: self, action: #selector(clickRedeemAction))
        exchangeImg.addGestureRecognizer(redeemTap)
        
    }

    
    
    @objc private func clickRedeemAction() {
        clickRedeemBlock?("")
    }
    
    
    func setCellData(model: StoreInfoModel) {
        
        self.scaleLab.text = model.firstDiscountScale
        
        self.exchangeImg.isHidden = !model.isOpenJiFen
        
        if model.isDiscount {
            //有折扣
            if model.firstDiscountIsOpen {
                
                if model.isFirstDiscount == nil {
                    //只存在整单优惠
                    self.discountImg.isHidden = false
                    self.firstImg.isHidden = true
                    
                    self.discountImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 70, height: 18))
                        $0.left.equalToSuperview().offset(10)
                        $0.centerY.equalToSuperview()
                    }
                    
                    self.firstImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 80, height: 18))
                        $0.left.equalToSuperview().offset(85)
                        $0.centerY.equalToSuperview()
                    }
                } else {
                    if model.isFirstDiscount! {
                        //都存在
                        self.discountImg.isHidden = false
                        self.firstImg.isHidden = false
                        
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(10)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 80, height: 18))
                            $0.left.equalToSuperview().offset(85)
                            $0.centerY.equalToSuperview()

                        }
                    } else {
                        //只存在整单优惠
                        self.discountImg.isHidden = false
                        self.firstImg.isHidden = true
                        
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(10)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 80, height: 18))
                            $0.left.equalToSuperview().offset(85)
                            $0.centerY.equalToSuperview()

                        }
                    }
                }
                

                
            } else {
                //只存在整单优惠
                
                self.discountImg.isHidden = false
                self.firstImg.isHidden = true
                
                self.discountImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 70, height: 18))
                    $0.left.equalToSuperview().offset(10)
                    $0.centerY.equalToSuperview()
                }
                
                self.firstImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 80, height: 18))
                    $0.left.equalToSuperview().offset(85)
                    $0.centerY.equalToSuperview()
                }
            }
            
        } else {
            //没有整单优惠
            self.discountImg.isHidden = true
            
            if model.firstDiscountIsOpen {
                
                if model.isFirstDiscount == nil {
                    //都不存在
                    self.firstImg.isHidden = true
                    self.discountImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 70, height: 18))
                        $0.left.equalToSuperview().offset(10)
                        $0.centerY.equalToSuperview()
                    }
                    
                    self.firstImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 80, height: 18))
                        $0.left.equalToSuperview().offset(85)
                        $0.centerY.equalToSuperview()
                    }
                    
                } else {
                    
                    if model.isFirstDiscount! {
                        //存在首单
                        self.firstImg.isHidden = false
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(10)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 80, height: 18))
                            $0.left.equalToSuperview().offset(10)
                            $0.centerY.equalToSuperview()
                        }
                        
                    } else {
                        //都不存在
                        self.firstImg.isHidden = true
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(10)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 80, height: 18))
                            $0.left.equalToSuperview().offset(85)
                            $0.centerY.equalToSuperview()
                        }
                    }
                }


            } else {
                //都不存在
                self.firstImg.isHidden = true
                self.discountImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 70, height: 18))
                    $0.left.equalToSuperview().offset(10)
                    $0.centerY.equalToSuperview()
                }
                
                self.firstImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 80, height: 18))
                    $0.left.equalToSuperview().offset(85)
                    $0.centerY.equalToSuperview()
                }
            }
        }
    }
}
