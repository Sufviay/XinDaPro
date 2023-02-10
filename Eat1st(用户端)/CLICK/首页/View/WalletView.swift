//
//  WalletView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/1/28.
//

import UIKit

class WalletView: UIView {


    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 23 / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    private let walletImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("wallet")
        return img
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(11), .right)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(23)
            $0.centerY.equalToSuperview()
        }

        self.addSubview(walletImg)
        walletImg.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: 32, height: 32))
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(tView.snp.right).offset(-10)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickWalletAciton))
        self.addGestureRecognizer(tap)
        
        self.isHidden = true
        
    }
    
    
    @objc private func clickWalletAciton() {
        
        PJCUtil.currentVC()?.navigationController?.pushViewController(WalletController(), animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(money: String) {
        self.moneyLab.text = money
    }
}
