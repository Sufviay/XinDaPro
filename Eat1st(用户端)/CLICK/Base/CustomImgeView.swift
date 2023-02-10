//
//  CustomImgeView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/14.
//

import UIKit

class CustomImgeView: UIView {


    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("holderImg")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let textLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(15), .center)
        lab.text = "Please wait …"
        return lab
    }()
    
    private let frontImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.isUserInteractionEnabled = true
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = MAINCOLOR
        
        self.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(logoImg.snp.width).multipliedBy(0.45)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-5)
        }
        
        self.addSubview(textLab)
        textLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImg.snp.bottom).offset(5)
        }
        
        self.addSubview(frontImg)
        frontImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    func setTitleFont(fontNum: CGFloat) {
        self.textLab.font = BFONT(fontNum)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(imageStr: String) {
        
        self.frontImg.sd_setImage(with: URL(string: imageStr)) { img, error, Type, url in
            
            if error == nil {
                self.backgroundColor = .clear
                self.logoImg.isHidden = true
                self.textLab.isHidden = true
            }
        }
    }
    
}
