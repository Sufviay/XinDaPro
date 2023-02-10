//
//  MenuDiscountCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/6.
//

import UIKit

class MenuDiscountCell: BaseTableViewCell, SystemAlertProtocol {
    
    
    var clickBlock: VoidBlock?
    
    private let discountImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("discount")
        return img
    }()
    
    private let firstImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("scale_back")
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
    
//    private let xlBut: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("discount_xl"), for: .normal)
//        return but
//    }()
//
//    private let msgLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("666666"), SFONT(10), .left)
//        lab.lineBreakMode = .byTruncatingTail
//        lab.text = "Every day, the first 30 orders in the store will enjoy 50% discount..."
//        return lab
//    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(discountImg)
        discountImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 18))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        
        contentView.addSubview(firstImg)
        firstImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 126, height: 18))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(95)
        }
        
        firstImg.addSubview(scaleLab)
        scaleLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            
        }
        

        
        contentView.addSubview(exchangeImg)
        exchangeImg.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo(105)
        }
        
        
        exchangeImg.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 8))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        exchangeImg.addSubview(exchangeLab)
        exchangeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(33)
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickTapAction))
        self.exchangeImg.addGestureRecognizer(tap)
        
        
//        contentView.addSubview(xlBut)
//        xlBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 20, height: 20))
//            $0.centerY.equalToSuperview()
//            $0.right.equalToSuperview().offset(-25)
//        }
//
//        contentView.addSubview(msgLab)
//        msgLab.snp.makeConstraints {
//            $0.left.equalTo(discountImg.snp.right).offset(10)
//            $0.right.equalToSuperview().offset(-50)
//            $0.centerY.equalToSuperview()
//        }
//
//        xlBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
    }
    
//    @objc private func clickAction() {
//        self.showSystemAlert("DISCOUNT", self.msgLab.text ?? "", "Confirm") {}
//    }
//
//
//    func setCellData(msg: String) {
//        self.msgLab.text = msg
//
//        //获取UIlabel的行数
//        let h = msg.getTextHeigh(SFONT(10), S_W - 145)
//        let lineNum = Int(ceil(h / msgLab.font.lineHeight))
//
//        if lineNum > 1 {
//            self.xlBut.isHidden = false
//        } else {
//            self.xlBut.isHidden = true
//        }
//    }

    
    
    @objc func clickTapAction() {
        self.clickBlock?("")
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
                        $0.left.equalToSuperview().offset(15)
                        $0.centerY.equalToSuperview()
                    }
                    
                    self.firstImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 126, height: 18))
                        $0.left.equalToSuperview().offset(95)
                        $0.centerY.equalToSuperview()

                    }
                } else {
                    if model.isFirstDiscount! {
                        //都存在
                        self.discountImg.isHidden = false
                        self.firstImg.isHidden = false
                        
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(15)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 126, height: 18))
                            $0.left.equalToSuperview().offset(95)
                            $0.centerY.equalToSuperview()

                        }
                    } else {
                        //只存在整单优惠
                        self.discountImg.isHidden = false
                        self.firstImg.isHidden = true
                        
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(15)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 126, height: 18))
                            $0.left.equalToSuperview().offset(95)
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
                    $0.left.equalToSuperview().offset(15)
                    $0.centerY.equalToSuperview()
                }
                
                self.firstImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 126, height: 18))
                    $0.left.equalToSuperview().offset(95)
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
                        $0.left.equalToSuperview().offset(15)
                        $0.centerY.equalToSuperview()
                    }
                    
                    self.firstImg.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 126, height: 18))
                        $0.left.equalToSuperview().offset(95)
                        $0.centerY.equalToSuperview()
                    }
                    
                } else {
                    
                    if model.isFirstDiscount! {
                        //存在首单
                        self.firstImg.isHidden = false
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(15)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 126, height: 18))
                            $0.left.equalToSuperview().offset(15)
                            $0.centerY.equalToSuperview()
                        }
                        
                    } else {
                        //都不存在
                        self.firstImg.isHidden = true
                        self.discountImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 70, height: 18))
                            $0.left.equalToSuperview().offset(15)
                            $0.centerY.equalToSuperview()
                        }
                        
                        self.firstImg.snp.remakeConstraints {
                            $0.size.equalTo(CGSize(width: 126, height: 18))
                            $0.left.equalToSuperview().offset(95)
                            $0.centerY.equalToSuperview()
                        }
                    }
                }


            } else {
                //都不存在
                self.firstImg.isHidden = true
                self.discountImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 70, height: 18))
                    $0.left.equalToSuperview().offset(15)
                    $0.centerY.equalToSuperview()
                }
                
                self.firstImg.snp.remakeConstraints {
                    $0.size.equalTo(CGSize(width: 126, height: 18))
                    $0.left.equalToSuperview().offset(95)
                    $0.centerY.equalToSuperview()
                }
            }
            
            
        }
        
    }
    
}
