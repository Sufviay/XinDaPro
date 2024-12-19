//
//  GiftBeTakenAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/25.
//

import UIKit
import SwiftyJSON

class GiftBeTakenAlert: UIViewController {

    
    var jsonData: JSON! {
        didSet {
            storeNameLab.text = jsonData["data"]["storeName"].stringValue
            namelab.text = jsonData["data"]["giftUserName"].stringValue
            timeLab.text = jsonData["data"]["createTime"].stringValue
            moneyLab.text = D_2_STR(jsonData["data"]["amount"].doubleValue)
        }
    }

    
    
    private let backView1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("takenBack")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let backView2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("giftback 1")
        img.isUserInteractionEnabled = true
        return img
    }()


    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setBackgroundImage(LOIMG("takeBut"), for: .normal)
        but.setTitle("Confirm", for: .normal)
        but.setTitleColor(.white, for: .normal)
        but.titleLabel?.font = BFONT(15)
        return but
    }()
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "Verdana-BoldItalic", size: 18)
        lab.textColor = HCOLOR("#65D57C")
        lab.textAlignment = .center
        lab.text = "RECEIVE FAILURE!"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .center)
        lab.text = "It's already been received"
        return lab
    }()

    
    private let namelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .center)
        lab.text = ""
        return lab
    }()
    
    private let storeNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FFFFFF"), BFONT(11), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
        return lab
    }()
    
    private let jinBinImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()

    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FFFFFF"), BFONT(25), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(13), .left)
        lab.text = "Gift voucher"
        return lab
    }()

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: Keys.giftId)
        
        view.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(265), height: SET_H(365, 265)))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }

        backView1.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: R_W(200), height: SET_H(85, 200)))
            $0.top.equalToSuperview().offset((155 / 365) * SET_H(365, 265))
        }
        
        
        backView1.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(170), height: SET_H(47, 170)))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-((18 / 365) * SET_H(365, 265)))
        }
        
        backView1.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.bottom.equalTo(backView2.snp.top).offset(-R_H(35))
            $0.centerX.equalToSuperview()
        }
        
        backView1.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backView2.snp.top).offset(-R_H(15))
        }
        
        
        backView2.addSubview(storeNameLab)
        storeNameLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset((10 / 85) * SET_H(85, 200))
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView2.addSubview(jinBinImg)
        jinBinImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(22), height: R_W(22)))
            $0.left.equalToSuperview().offset(R_W(55))
            $0.top.equalToSuperview().offset((48 / 85) * SET_H(85, 200))
        }
        
        backView2.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(jinBinImg)
            $0.left.equalTo(jinBinImg.snp.right).offset(5)
        }
        
        backView2.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.left.equalTo(jinBinImg)
            $0.bottom.equalTo(jinBinImg.snp.top).offset(-3)
        }
        
        backView1.addSubview(namelab)
        namelab.snp.makeConstraints {
            $0.top.equalTo(backView2.snp.bottom).offset(R_H(12))
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView1.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backView2.snp.bottom).offset(R_H(30))
        }
        
        
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
    }
    
    
    @objc private func clickConfirmAction() {
        dismiss(animated: true)
    }


    
}
