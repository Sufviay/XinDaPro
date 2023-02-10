//
//  JiFenView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/10.
//

import UIKit

class JiFenView: UIView {

    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 24 / 2
        return view
    }()
    
    private let jifenImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("JiFen")
        return img
    }()
    
    private let numLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.init(name: "Helvetica-Bold", size: 14)
        lab.textAlignment = .right
        lab.textColor = HCOLOR("333333")
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }

        self.addSubview(jifenImg)
        jifenImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(2)
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.top.equalToSuperview().offset(1)
        }
        
        self.addSubview(numLab)
        numLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(tView.snp.right).offset(-6)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAciton))
        self.addGestureRecognizer(tap)
        
        self.isHidden = true
        
    }
    
    
    @objc private func clickAciton() {
        
        PJCUtil.currentVC()?.navigationController?.pushViewController(JiFenDetailController(), animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(number: String) {
        self.numLab.text = number
    }
}
