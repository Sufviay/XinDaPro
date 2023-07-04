//
//  StoreMidInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreMidInfoCell: BaseTableViewCell {
    
    private var dataModel = StoreInfoModel()
    
    private var tagArr: [String] = ["beef", "fish", "mutton"]
    
    private let color1 = HCOLOR("#FEC501")
    private let color2 = HCOLOR("#FA7268")
    private let color3 = HCOLOR("#448AFF")


    private let midImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_bimg")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = BACKCOLOR
        //img.image = LOIMG("store_logo-1")
        img.clipsToBounds = true
        img.layer.cornerRadius = R_H(50) / 2
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = ""
        return lab
    }()
    
    private let localBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("local_y"), for: .normal)
        return but
    }()
    
    private let phoneBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("phone_y"), for: .normal)
        return but
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(12), .left)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()
    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: R_W(120), y: R_H(200) - 70, width: 85, height: 14))
        view.isCanTap = false
        return view
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    
    private let plCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(13), .left)
        lab.text = "(456)"
        return lab
    }()

    
    override func setViews() {
        
        
        contentView.addSubview(midImg)
        midImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        



        midImg.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_H(50), height: R_H(50)))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(R_H(20))
        }

        midImg.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImg.snp.bottom).offset(10)
        }

        midImg.addSubview(localBut)
        localBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.left.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().offset(-R_H(20))
        }

        midImg.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(localBut)
            $0.centerY.equalTo(localBut)
            $0.right.equalToSuperview().offset(-50)
        }


        let line = UIView()
        line.backgroundColor = HCOLOR("#DDDDDD")
        midImg.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 20))
            $0.centerY.equalTo(phoneBut)
            $0.right.equalTo(phoneBut.snp.left).offset(-15)
        }


        midImg.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalTo(localBut.snp.right).offset(5)
            $0.centerY.equalTo(localBut)
            $0.right.equalTo(line.snp.left).offset(-10)
        }

        midImg.addSubview(starView)

        midImg.addSubview(plCountLab)
        plCountLab.snp.makeConstraints {
            $0.centerY.equalTo(starView)
            $0.left.equalTo(starView.snp.right).offset(10)
        }
        
        contentView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(nameLab.snp.bottom)
            $0.bottom.equalTo(starView.snp.top)
        }

        

        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        localBut.addTarget(self, action: #selector(clickLocalAction), for: .touchUpInside)

    }
    
    
    @objc private func clickPhoneAction()  {
        PJCUtil.callPhone(phone: dataModel.phone)
    }
    
    @objc func clickLocalAction()  {
        PJCUtil.showLoacl(lat: Double(dataModel.lat) ?? 0, lng: Double(dataModel.lng) ?? 0)
    }

    
    
    func setStoreTag() {
        
        tView.subviews.forEach { $0.removeFromSuperview() }
        
        ///限制的宽度
        let A_W: CGFloat = S_W - 160
        ///标签高度
        let tagH: CGFloat = 14
        ///每个标签左右以及上下的距离
        let d_W: CGFloat = 5
    
        ///计算所有标签的长度
        var all_W: CGFloat = 0
        for str in tagArr {
            let w = str.getTextWidth(SFONT(10), tagH) + 20
            all_W += w
        }
        all_W = all_W + CGFloat((tagArr.count - 1)) * d_W
        
        
        
        if all_W < A_W {
            
            let d = (A_W - all_W) / 2
            var t_W: CGFloat = 0
            
            //一行显示的下 标签居中显示
            for (idx, str) in tagArr.enumerated() {
                
                let lab = UILabel()
                lab.text = str
                lab.font = SFONT(10)
                lab.clipsToBounds = true
                lab.layer.cornerRadius = 3
                lab.layer.borderWidth = 1
                lab.textAlignment = .center

                //设置标签颜色
                
                let t = idx % 3
                if t == 0 {
                    lab.textColor = color1
                    lab.layer.borderColor = color1.cgColor
                }
                
                if t == 1 {
                    lab.textColor = color2
                    lab.layer.borderColor = color2.cgColor
                }
                
                if t == 2 {
                    lab.textColor = color3
                    lab.layer.borderColor = color3.cgColor
                }

                
                let strW = str.getTextWidth(SFONT(10), tagH) + 20
                
                tView.addSubview(lab)
                lab.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(80 + d + (CGFloat(idx) * d_W) + t_W)
                    $0.size.equalTo(CGSize(width: strW, height: 14))
                    $0.centerY.equalToSuperview()
                }
                
                t_W += strW
            }
        }
    }
    
    
    func setCellData(model: StoreInfoModel) {
        self.dataModel = model

        self.logoImg.sd_setImage(with: URL(string: self.dataModel.logoImg), completed: nil)
        self.nameLab.text = self.dataModel.name
        self.addressLab.text = self.dataModel.storeAddress
        self.plCountLab.text = "(\(self.dataModel.evaluateNum))"
        self.starView.setPointValue = Int(ceil(self.dataModel.star))
        
        if dataModel.tags == "" {
            self.tagArr = []
        } else {
            self.tagArr = self.dataModel.tags.components(separatedBy: "·")
            self.setStoreTag()
        }
        
        
        
        
    }

    
    
}
