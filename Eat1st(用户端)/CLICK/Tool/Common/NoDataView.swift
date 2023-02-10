//
//  NoDataView.swift
//  WinShop
//
//  Created by 岁变 on 8/31/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noData")
        return img
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "This page has no data"
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.size.equalTo(CGSize(width: 165, height: 112))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}



class NoAddressDataView: UIView {
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noLocal")
        return img
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "No location information"
        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.size.equalTo(CGSize(width: R_W(250), height:R_W(250)))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class NOStoreView: UIView {

    
    var clickBlock: VoidBlock?

    let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noData")
        return img
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "This page has no data"
        return lab
    }()

//    private let nolab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(14), .center)
//        lab.text = "No more shops"
//        return lab
//    }()
    
    private let allBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "All Shops", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///1
    var isAll: Bool = true {
        didSet {
            if isAll {
                self.allBut.isHidden = true
                //self.nolab.isHidden = false
            } else {
                self.allBut.isHidden = false
                //self.nolab.isHidden = true
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.size.equalTo(CGSize(width: 165, height: 112))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(20)
        }
        
        self.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.top.equalTo(picImg.snp.bottom).offset(100)
        }
        
//        self.addSubview(nolab)
//        nolab.snp.makeConstraints {
//            $0.centerX.equalTo(picImg)
//            $0.top.equalTo(picImg.snp.bottom).offset(100)
//        }
        
        
        allBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickAllAction() {
        clickBlock?("")
    }
    
}

