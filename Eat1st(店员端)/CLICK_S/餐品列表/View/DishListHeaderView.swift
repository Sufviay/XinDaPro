//
//  DishListHeaderView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/3.
//

import UIKit

class DishListHeaderView: UIView {

    
    var clickHomeBlock: VoidBlock?
    var clickMenuBlock: VoidBlock?
    var clickScanBlock: VoidBlock?
    var clickShouqiBlock: VoidBlock?

    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(17), .center)
        lab.text = "Talble11"
        return lab
    }()
    
    private let menuBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("shaixuan"), for: .normal)
        but.setTitle("Menu", for: .normal)
        but.titleLabel?.font = BFONT(11)
        but.setTitleColor(.white, for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return but
    }()
    
    
    private let homeBut: TopButton = {
        let but = TopButton()
        but.iconImg.image = LOIMG("home")
        but.iconLab.text = "Home"
        but.iconLab.textColor = .white
        but.iconLab.font = SETFONT(9)
        return but
    }()
    
    private let shouqiBut: TopButton = {
        let but = TopButton()
        but.iconImg.image = LOIMG("shouqi 1")
        but.iconLab.text = "收起"
        but.iconLab.textColor = .white
        but.iconLab.font = SETFONT_B(9)
        return but
    }()
    
    
    private let sysBut: TopButton = {
        let but = TopButton()
        but.iconImg.image = LOIMG("sys")
        but.iconLab.text = "Scan"
        but.iconLab.textColor = .white
        but.iconLab.font = SETFONT_B(9)
        but.isHidden = true
        return but
    }()


    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HCOLOR("#2F3446")
        
        addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.height.equalTo(NAV_H())
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(menuBut)
        menuBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 60, height: 44))
            $0.centerY.equalTo(titLab)
        }
        
        addSubview(homeBut)
        homeBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(titLab)
            $0.height.equalTo(40)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.equalTo(50)
            } else {
                $0.width.equalTo(40)
            }
        }
        
        addSubview(shouqiBut)
        shouqiBut.snp.makeConstraints {
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.right.equalTo(homeBut.snp.left).offset(-10)
            } else {
                $0.right.equalTo(homeBut.snp.left).offset(-2)
            }
            
            $0.centerY.equalTo(titLab)
            $0.size.equalTo(homeBut)
        }

        addSubview(sysBut)
        sysBut.snp.makeConstraints {
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.right.equalTo(shouqiBut.snp.left).offset(-10)
            } else {
                $0.right.equalTo(shouqiBut.snp.left).offset(-2)
            }

            $0.centerY.equalTo(titLab)
            $0.size.equalTo(homeBut)
        }
        
        
        menuBut.addTarget(self, action: #selector(clickMenuAction), for: .touchUpInside)
        homeBut.addTarget(self, action: #selector(clickHomeAction), for: .touchUpInside)
        shouqiBut.addTarget(self, action: #selector(clickShouqiAction), for: .touchUpInside)
        sysBut.addTarget(self, action: #selector(clickSysAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickMenuAction() {
        clickMenuBlock?("")
    }
    
    @objc private func clickHomeAction() {
        clickHomeBlock?("")
    }
    
    
    @objc private func clickShouqiAction() {
        clickShouqiBlock?("")
    }

    
    @objc private func clickSysAction() {
        clickScanBlock?("")
    }


}



class TopButton: UIButton {
    
    let iconImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let iconLab: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        addSubview(iconImg)
        iconImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(3)
        }
        
        addSubview(iconLab)
        iconLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
