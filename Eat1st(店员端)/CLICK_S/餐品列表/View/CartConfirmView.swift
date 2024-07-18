//
//  CartConfirmView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit

class CartConfirmView: UIView {
    
    var clickCartBlock: VoidBlock?
    
    var clickConfirmBlock: VoidBlock?

    
    private let cartImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("cart")
        return img
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .black, BFONT(13), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 17.5
        return but
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.clipsToBounds = true
        lab.backgroundColor = HCOLOR("#FF6B52")
        lab.layer.cornerRadius = 8
        lab.setCommentStyle(.white, SFONT(10), .center)
        lab.isHidden = true
        lab.text = "0"
        return lab
    }()
    
    private let t_Lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), BFONT(13), .left)
        lab.text = "Total："
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(17), .left)
        lab.text = "£0"
        return lab
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
        
//        cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 65), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        

        addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 110, height: 35))
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        addSubview(cartImg)
        cartImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 42, height: 42))
            $0.centerY.equalTo(confirmBut)
            $0.left.equalToSuperview().offset(20)
        }
        
        
        cartImg.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.right.equalToSuperview().offset(4)
            $0.top.equalToSuperview().offset(-4)
        }
        
        
        addSubview(t_Lab)
        t_Lab.snp.makeConstraints {
            $0.left.equalTo(cartImg.snp.right).offset(15)
            $0.centerY.equalTo(cartImg)
        }
        
        addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(t_Lab.snp.right).offset(1)
            $0.centerY.equalTo(cartImg)
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfimAction), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickCartAction))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc private func clickConfimAction() {
        clickConfirmBlock?("")
    }
    
    
    @objc private func clickCartAction() {
        clickCartBlock?("")
        
    }
    
    func updateData(price: String, data: CartModel) {
        
        var count: Int = 0
        
        for model in data.dishesList {
            count += model.buyNum
        }
        
        
        if count == 0 {
            countLab.isHidden = true
        } else {
            countLab.isHidden = false
        }
        
        countLab.text = "\(count)"
        moneyLab.text = "£\(price)"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
