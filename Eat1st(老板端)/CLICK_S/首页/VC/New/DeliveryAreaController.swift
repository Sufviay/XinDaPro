//
//  DeliveryAreaController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/20.
//

import UIKit

class DeliveryAreaController: HeadBaseViewController {
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(21), .left)
        lab.text = "Your delivery area"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FF8E12"), HCOLOR("#FFC65E"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    private let selectBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let radiusBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Radius", .white, BFONT(11), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let postcodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Postcode", HCOLOR("#ADADAD"), BFONT(11), .clear)
        but.layer.cornerRadius = 5
        return but
    }()
//
//    private let backView: UIView = {
//        let view =
//    }
    

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Delivery area"
    }
    
    override func setViews() {
        setUpUI()
    }

    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(22)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalTo(titlab)
            $0.top.equalTo(titlab.snp.bottom).offset(5)
        }
        
        backView.addSubview(selectBackView)
        selectBackView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 25))
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        selectBackView.addSubview(radiusBut)
        radiusBut.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        
        selectBackView.addSubview(postcodeBut)
        postcodeBut.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        
        
        
    }
    

}
