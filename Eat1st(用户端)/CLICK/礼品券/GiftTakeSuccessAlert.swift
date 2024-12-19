//
//  GiftTakeSuccessAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/14.
//

import UIKit

class GiftTakeSuccessAlert: UIViewController {
    
    
    private let backView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("takeSuccess")
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
        lab.textColor = HCOLOR("#F05A11")
        lab.textAlignment = .center
        lab.text = "CONGRATULATIONS!"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .center)
        lab.text = "Received successfully"
        return lab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(265), height: SET_H(290, 265)))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
    
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(170), height: SET_H(47, 170)))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-((25 / 290) * SET_H(290, 265)))
        }
        
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmBut.snp.top).offset(-R_H(30))
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmBut.snp.top).offset(-R_H(55))
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        

    }
    
    
    
    @objc private func clickConfirmAction() {
        dismiss(animated: true)
    }



}
