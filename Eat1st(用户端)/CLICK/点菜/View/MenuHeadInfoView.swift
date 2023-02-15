//
//  MenuHeadInfoView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/13.
//

import UIKit

class MenuHeadInfoView: UIView {
    
    
    var clickBlock: VoidBlock?
    
    var clickPLBlock: VoidBlock?
    
    var clickCheckPSBlock: VoidBlock?
    
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "----"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let deslab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "--"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let desBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_about"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let plCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
        lab.text = "--"
        lab.isUserInteractionEnabled = true
        return lab
    }()

    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: 90, height: 14))
        view.isCanTap = false
        view.isHidden = true
        return view
    }()
    
    private let psMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
        lab.text = "--"
        return lab
    }()
    
    private let checkPSBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("s_about"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let qsLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "--"
        return lab
    }()

    
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(25)

        }
        
        self.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(logoImg.snp.right).offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-50)
        }
        
        self.addSubview(deslab)
        deslab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-80)
        }
        
        self.addSubview(desBut)
        desBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
        }
        
        self.addSubview(plCountLab)
        plCountLab.snp.makeConstraints {
            $0.top.equalTo(deslab.snp.bottom).offset(10)
            $0.left.equalTo(logoImg.snp.right).offset(130)
        }
    
        
        self.addSubview(starView)
        starView.snp.makeConstraints {
            $0.centerY.equalTo(plCountLab)
            $0.left.equalToSuperview().offset(70)
            $0.size.equalTo(CGSize(width: 90, height: 14))
        }
        
        
        self.addSubview(qsLab)
        qsLab.snp.makeConstraints {
            $0.left.equalTo(deslab)
            $0.top.equalTo(starView.snp.bottom).offset(5)
        }

        
        self.addSubview(psMoneyLab)
        psMoneyLab.snp.makeConstraints {
            $0.left.equalTo(deslab)
            $0.top.equalTo(qsLab.snp.bottom).offset(5)

        }

        self.addSubview(checkPSBut)
        checkPSBut.snp.makeConstraints {

            $0.centerY.equalTo(psMoneyLab)
            $0.left.equalTo(psMoneyLab.snp.right).offset(3)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }


        
        
        let reviewsTap = UITapGestureRecognizer(target: self, action: #selector(clickReviewsAction))
        self.plCountLab.addGestureRecognizer(reviewsTap)
        
        desBut.addTarget(self, action: #selector(clickCheckAction), for: .touchUpInside)
        checkPSBut.addTarget(self, action: #selector(clickCheckPSFee), for: .touchUpInside)
        
    }
    
    @objc private func clickCheckAction() {
        self.clickBlock?("")
    }
    
    
    @objc private func clickReviewsAction() {
        self.clickPLBlock?("")
    }
    
    @objc private func clickCheckPSFee() {
        print("aaaaaa")
        self.clickCheckPSBlock?("")
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(model: StoreInfoModel) {
        self.desBut.isHidden = false
        self.nameLab.text = model.name
        self.deslab.text = model.tags
        self.starView.isHidden = false
        self.starView.setPointValue = Int(ceil(model.star))
        self.plCountLab.text = "view \(model.evaluateNum) reviews"
        self.logoImg.sd_setImage(with: URL(string: model.logoImg), completed: nil)
        
        self.qsLab.text = model.minOrderStr

        if model.maxDelivery == 0 {
            if model.minDelivery == 0 {
                //没有起送费
                self.psMoneyLab.text = "No delivery fee"
                self.psMoneyLab.textColor = HCOLOR("#666666")
                self.checkPSBut.isHidden = true
            } else {
                //设置的配送费
                self.psMoneyLab.text = "Delivery £\(model.minDelivery)"
                self.psMoneyLab.textColor = HCOLOR("#666666")
                self.checkPSBut.isHidden = true
            }
        } else {
            self.psMoneyLab.text = "Delivery from £\(model.minDelivery)-£\(model.maxDelivery)"
            self.psMoneyLab.textColor = MAINCOLOR
            self.checkPSBut.isHidden = false
        }
    
    }
    
}
