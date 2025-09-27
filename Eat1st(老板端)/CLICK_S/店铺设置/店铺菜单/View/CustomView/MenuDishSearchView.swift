//
//  MenuDishSearchView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit

class MenuDishSearchView: UIView {
    
    var doSearchBlock: VoidStringBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Search".local, MAINCOLOR, TXT_1, .clear)
        return but
    }()
    
    private let s_Img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("menu_search")
        return img
    }()
    
    private let inputTF: UITextField = {
        let tf = UITextField()
        tf.setPlaceholder("Search for dish".local, color: TFHOLDCOLOR)
        tf.textColor = TXTCOLOR_1
        tf.font = TXT_1
        return tf
    }()
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 60), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        self.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalTo(backView)
            $0.left.equalTo(backView.snp.right)
            $0.right.equalToSuperview()
        }
        
        backView.addSubview(s_Img)
        s_Img.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
        }
        
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickSearchAction() {
        doSearchBlock?(self.inputTF.text ?? "")
    }
    
    
}
