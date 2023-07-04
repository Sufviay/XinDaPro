//
//  MenuTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit

class MenuTagView: UIView {

    
    
    var clickBlock: VoidStringBlock?
    
    
    
    private var type: String = "on" {
        didSet {
            if type == "dis" {
                self.line1.isHidden = false
                self.line2.isHidden = true
                self.line3.isHidden = true
                self.line4.isHidden = true
                self.but1.setTitleColor(FONTCOLOR, for: .normal)
                self.but1.titleLabel?.font = BFONT(14)
                self.but2.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but2.titleLabel?.font = SFONT(14)
                self.but3.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but3.titleLabel?.font = SFONT(14)
                self.but4.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but4.titleLabel?.font = SFONT(14)

            }
            
            if type == "add" {
                self.line2.isHidden = false
                self.line1.isHidden = true
                self.line3.isHidden = true
                self.line4.isHidden = true
                self.but2.setTitleColor(FONTCOLOR, for: .normal)
                self.but2.titleLabel?.font = BFONT(14)
                self.but1.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but1.titleLabel?.font = SFONT(14)
                self.but3.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but3.titleLabel?.font = SFONT(14)
                self.but4.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but4.titleLabel?.font = SFONT(14)
            }
            
            if type == "fre" {
                self.line2.isHidden = true
                self.line1.isHidden = true
                self.line3.isHidden = false
                self.line4.isHidden = true
                self.but3.setTitleColor(FONTCOLOR, for: .normal)
                self.but3.titleLabel?.font = BFONT(14)
                self.but1.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but1.titleLabel?.font = SFONT(14)
                self.but2.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but2.titleLabel?.font = SFONT(14)
                self.but4.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but4.titleLabel?.font = SFONT(14)
            }
            
            if type == "com" {
                self.line2.isHidden = true
                self.line1.isHidden = true
                self.line3.isHidden = true
                self.line4.isHidden = false
                self.but4.setTitleColor(FONTCOLOR, for: .normal)
                self.but4.titleLabel?.font = BFONT(14)
                self.but1.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but1.titleLabel?.font = SFONT(14)
                self.but2.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but2.titleLabel?.font = SFONT(14)
                self.but3.setTitleColor(HCOLOR("#6F7FAF"), for: .normal)
                self.but3.titleLabel?.font = SFONT(14)
            }
            
        }
    }

    private let but1: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Dishes", FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let but2: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Additional", HCOLOR("#6F7FAF"), SFONT(14), .clear)
        return but
    }()
    
    private let but3: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Gifts", HCOLOR("#6F7FAF"), SFONT(14), .clear)
        return but
    }()
    
    
    private let but4: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Combo", HCOLOR("#6F7FAF"), SFONT(14), .clear)
        return but
    }()

    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()

    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()

    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 55), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        
        self.addSubview(but1)
        but1.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(60)
        }
        
        self.addSubview(but4)
        but4.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(but1.snp.right).offset(10)
            $0.width.equalTo(60)
        }
        
        self.addSubview(but2)
        but2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(80)
            $0.left.equalTo(but4.snp.right).offset(10)
        }
        
        self.addSubview(but3)
        but3.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(60)
            $0.left.equalTo(but2.snp.right).offset(10)
        }

        
        
        self.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalTo(but1)
        }
        
        
        self.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalTo(but2)
        }
        
        
        self.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalTo(but3)
        }
        
        self.addSubview(line4)
        line4.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 4))
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalTo(but4)
        }
        

        but1.addTarget(self, action: #selector(clickbut1Action), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickbut2Action), for: .touchUpInside)
        but3.addTarget(self, action: #selector(clickbut3Action), for: .touchUpInside)
        but4.addTarget(self, action: #selector(clickbut4Action), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickbut1Action() {
        
        if self.type != "dis" {
            self.type = "dis"
            clickBlock?(type)
        }
        
    }
    
    @objc private func clickbut2Action() {
        if self.type != "add" {
            self.type = "add"
            clickBlock?(type)
        }
    }

    @objc private func clickbut3Action() {
        if self.type != "fre" {
            self.type = "fre"
            clickBlock?(type)
        }
    }
    
    @objc private func clickbut4Action() {
        if self.type != "com" {
            self.type = "com"
            clickBlock?(type)
        }
    }


}
