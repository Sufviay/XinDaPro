//
//  DishDetailBottmView.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/17.
//

import UIKit

class DishDetailBottmView: UIView {
    

    var clickAddBlock: VoidBlock?
    
    private let cartBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("cart"), for: .normal)
        return but
    }()

    
    let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(18), .left)
        lab.text = "0.0"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .right)
        lab.text = "£"
        return lab
    }()
    
    private let sureBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 15
        but.backgroundColor = .white
        but.setCommentStyle(.zero, "Add to order", MAINCOLOR, SFONT(13), .white)
        return but
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = MAINCOLOR
        self.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        
        
        self.addSubview(cartBut)
        cartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(5)
        }
        
        self.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(cartBut)
            $0.left.equalToSuperview().offset(60)
        }
        
        self.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        
        self.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 30))
            $0.centerY.equalTo(cartBut)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        sureBut.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickSureAction() {
        self.clickAddBlock?("")
    }
    
    
    
    func setButTitleType(lunchOrDinner: String, cartID: String) {
        
        if lunchOrDinner == "2" {
            self.backgroundColor = HCOLOR("#CCCCCC")
            self.sureBut.setTitleColor(HCOLOR("#CCCCCC"), for: .normal)
            self.sureBut.isEnabled = false
            self.sureBut.setTitle("For Dinner only", for: .normal)
        } else {
            self.backgroundColor = MAINCOLOR
            self.sureBut.setTitleColor(MAINCOLOR, for: .normal)
            self.sureBut.isEnabled = true
            
            if cartID == "" {
                self.sureBut.setTitle("Add to order", for: .normal)
            } else {
                self.sureBut.setTitle("Update to order", for: .normal)
            }
            
            
        }
    }
    
}
