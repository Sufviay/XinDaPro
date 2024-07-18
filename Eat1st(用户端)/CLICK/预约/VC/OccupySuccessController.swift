//
//  OccupySuccessController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/12.
//

import UIKit

class OccupySuccessController: BaseViewController {

    
    private let successImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("success-1")
        return img
    }()
    
    private let successLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .center)
        lab.text = "Successful submission"
        return lab
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "OK", FONTCOLOR, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    
    override func setViews() {
        
        naviBar.isHidden = true
        
        view.addSubview(successImg)
        successImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-150)
            $0.size.equalTo(CGSize(width: 155, height: 150))
        }
        
        view.addSubview(successLab)
        successLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(successImg.snp.bottom).offset(5)
        }
        

        view.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 165, height: 45))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(successLab.snp.bottom).offset(50)
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
    }

    
    @objc private func clickConfirmAction() {
        navigationController?.popViewController(animated: true)
    }

}
