//
//  MenuNavBarView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/6.
//

import UIKit

class MenuNavBarView: UIView {

    
    var backBlock: VoidBlock?
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(18), .left)
        lab.text = "Home"
        return lab
    }()
    
    
//    //钱包
//    let walletLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(15), .right)
//        lab.isHidden = true
//        lab.isUserInteractionEnabled = true
//        return lab
//    }()
//    
//    let walletImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("wallet-1")
//        img.isHidden = true
//        return img
//    }()
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.left.equalToSuperview().offset(60)
        }
        
//        self.addSubview(walletLab)
//        walletLab.snp.makeConstraints {
//            $0.centerY.equalTo(titlab)
//            $0.right.equalToSuperview().offset(-15)
//        }
        
//        self.addSubview(walletImg)
//        walletImg.snp.makeConstraints {
//            $0.centerY.equalTo(titlab)
//            $0.right.equalTo(walletLab.snp.left).offset(-3)
//        }
        
//        let walletTap = UITapGestureRecognizer(target: self, action: #selector(walletTapAction))
//        walletLab.addGestureRecognizer(walletTap)
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickBackAction() {
        self.backBlock?("")
    }
    
    @objc private func walletTapAction() {
        let walletVC = WalletController()
        PJCUtil.currentVC()?.navigationController?.pushViewController(walletVC, animated: true)
    }
    
    
}
