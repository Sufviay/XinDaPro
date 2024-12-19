//
//  GiftTakeAlertController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/14.
//

import UIKit
import RxSwift
import SwiftyJSON


class GiftTakeAlertController: UIViewController {
    
    private let bag = DisposeBag()
    
    var giftID: String = ""
    var jsonData: JSON! {
        didSet {
            storeNameLab.text = jsonData["data"]["storeName"].stringValue
            namelab.text = jsonData["data"]["giftUserName"].stringValue
            timeLab.text = jsonData["data"]["createTime"].stringValue
            moneyLab.text = D_2_STR(jsonData["data"]["amount"].doubleValue)
        }
    }
    
    private let backView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("takeBack")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let receiveBut: UIButton = {
        let but = UIButton()
        but.setBackgroundImage(LOIMG("takeBut"), for: .normal)
        but.setTitle("Receive", for: .normal)
        but.setTitleColor(.white, for: .normal)
        but.titleLabel?.font = BFONT(15)
        return but
    }()
    
    private let namelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(11), .right)
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
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(370), height: SET_H(380, 370)))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        backView.addSubview(receiveBut)
        receiveBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(170), height: SET_H(47, 170)))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-((55 / 380) * SET_H(380, 370)))
        }
        
        backView.addSubview(namelab)
        namelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(98))
            $0.right.equalToSuperview().offset(-R_W(90))
            $0.top.equalToSuperview().offset((125 / 380) * SET_H(380, 370))
        }
        
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-R_W(95))
            $0.top.equalToSuperview().offset((153 / 380) * SET_H(380, 370))
        }
        
        
        backView.addSubview(storeNameLab)
        storeNameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(98))
            $0.right.equalToSuperview().offset(-R_W(95))
            $0.top.equalToSuperview().offset((185 / 380) * SET_H(380, 370))
        }
        
        
        backView.addSubview(jinBinImg)
        jinBinImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(22), height: R_W(22)))
            $0.left.equalToSuperview().offset(R_W(135))
            $0.top.equalToSuperview().offset((222 / 380) * SET_H(380, 370))
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(jinBinImg)
            $0.left.equalTo(jinBinImg.snp.right).offset(5)
        }
        
        backView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.left.equalTo(jinBinImg)
            $0.bottom.equalTo(jinBinImg.snp.top).offset(-3)
        }
        
        receiveBut.addTarget(self, action: #selector(clickReceiveAction), for: .touchUpInside)
        
    }
    
    @objc private func clickReceiveAction() {
        doTaken_Net()
    }
}

extension GiftTakeAlertController {
        
    
    //MARK: - 领取礼品券
    private func doTaken_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.doTakeGift(id: giftID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            dismiss(animated: true) {
                let successVC = GiftTakeSuccessAlert()
                successVC.transitioningType = .popup
                PJCUtil.currentVC()?.present(successVC, animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
}
