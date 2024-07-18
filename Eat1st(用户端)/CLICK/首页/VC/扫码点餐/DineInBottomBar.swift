//
//  DineInBottomBar.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/23.
//

import UIKit

class DineInBottomBar: UIView {

    var clickBlock: VoidStringBlock?
    
    
    private let but1: UIButton = {
        let but = UIButton()
        return but
    }()
    
    
    private let but2: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let but3: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let but4: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#C5C5C5")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#C5C5C5")
        return view
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#C5C5C5")
        return view
    }()


    
    private let lab_E1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "Personal Info"
        return lab
    }()
    
    
    private let lab_E2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "Order Record"
        return lab
    }()
    
    
    private let lab_E3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "Ordered"
        return lab
    }()
    
    private let lab_E4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "Call"
        return lab
    }()
    
    private let lab_C1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .center)
        lab.text = "個人信息"
        return lab
    }()
    
    private let lab_C2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .center)
        lab.text = " 訂單紀錄"
        return lab
    }()
    
    private let lab_C3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .center)
        lab.text = "已選菜品"
        return lab
    }()

    
    private let lab_C4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .center)
        lab.text = "呼叫服務員"
        return lab
    }()


    private let dishNumlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .center)
        lab.text = ""
        lab.backgroundColor = HCOLOR("#FF3C00")
        lab.layer.cornerRadius = 9
        lab.clipsToBounds = true
        lab.isHidden = true
        return lab
    }()
    
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
        // 阴影偏移，默认(0, -3)
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 阴影透明度，默认0
        self.layer.shadowOpacity = 1
        // 阴影半径，默认3
        self.layer.shadowRadius = 3

        
        self.addSubview(but1)
        but1.snp.makeConstraints {
            $0.width.equalTo(S_W / 4)
            $0.left.top.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        self.addSubview(but2)
        but2.snp.makeConstraints {
            $0.size.top.equalTo(but1)
            $0.left.equalTo(but1.snp.right).offset(0)
        }
        
        self.addSubview(but3)
        but3.snp.makeConstraints {
            $0.size.top.equalTo(but1)
            $0.left.equalTo(but2.snp.right).offset(0)
        }
        
        self.addSubview(but4)
        but4.snp.makeConstraints {
            $0.size.top.equalTo(but1)
            $0.left.equalTo(but3.snp.right).offset(0)
        }
        
        
        self.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 25))
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(but1.snp.right)
        }
        
        self.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.centerY.equalTo(line1)
            $0.left.equalTo(but2.snp.right)
        }
        
        self.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.centerY.equalTo(line1)
            $0.left.equalTo(but3.snp.right)
        }
        
        
        but1.addSubview(lab_C1)
        lab_C1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(18)
        }

        
        but1.addSubview(lab_E1)
        lab_E1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lab_C1.snp.bottom).offset(3)
        }
        
       
        but2.addSubview(lab_C2)
        lab_C2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_C1)
        }

        
        but2.addSubview(lab_E2)
        lab_E2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_E1)
        }
        
        
        
        but3.addSubview(lab_C3)
        lab_C3.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_C1)
        }

        
        but3.addSubview(lab_E3)
        lab_E3.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_E1)
        }

        
        but4.addSubview(lab_C4)
        lab_C4.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_C1)
        }

        
        but4.addSubview(lab_E4)
        lab_E4.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lab_E1)
        }
        
        
        
        but3.addSubview(dishNumlab)
        dishNumlab.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.width.equalTo(18)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().offset(5)
        }

        

        but1.addTarget(self, action: #selector(clickBut1), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickBut2), for: .touchUpInside)
        but3.addTarget(self, action: #selector(clickBut3), for: .touchUpInside)
        but4.addTarget(self, action: #selector(clickBut4), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func clickBut1() {
        clickBlock?("grjl")
    }
    
    @objc private func clickBut2() {
        clickBlock?("lsjl")
    }
    
    @objc private func clickBut3() {
        clickBlock?("gwc")
    }
    
    @objc private func clickBut4() {
        clickBlock?("hjfwy")
    }
    
    
    func setBuyCount(number: Int) {
        dishNumlab.text = String(number)
        
        if number == 0 {
            dishNumlab.isHidden = true
        } else {
            dishNumlab.isHidden = false
            let s_w = dishNumlab.text!.getTextWidth(SFONT(11), 18)
            let w = (s_w + 5) > 18 ? (s_w + 5) : 18
            dishNumlab.snp.updateConstraints {
                $0.width.equalTo(w)
            }
        }
    }

}
