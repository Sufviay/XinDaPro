//
//  CountSelectView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class CountSelectView: UIView {
    
    var countBlock: VoidBlock?
    
    ///是否可以为0
    var canBeZero: Bool = true
    
    //最大的数字
    var maxCount: Int = 0
    
    var count: Int = 0 {
        didSet {
            self.countLab.text = String(count)
            if count == 0 {
                self.jianBut.isHidden = true
                self.countLab.isHidden = true
            } else {
                self.jianBut.isHidden = false
                self.countLab.isHidden = false
            }
        }
    }

    
    var canClick: Bool = true {
        didSet {
            self.jiaBut.isEnabled = canClick
            self.jianBut.isEnabled = canClick
        }
    }
    
    private let jiaBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_+"), for: .normal)
        return but
    }()
    
    
    private let jianBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_-"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.isHidden = true
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        self.addSubview(jiaBut)
        jiaBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(countLab.snp.right)
            $0.centerY.equalTo(countLab)
        }
        
        self.addSubview(jianBut)
        jianBut.snp.makeConstraints {
            $0.size.equalTo(jiaBut)
            $0.right.equalTo(countLab.snp.left)
            $0.centerY.equalTo(jiaBut)
        }
        
        jiaBut.addTarget(self, action: #selector(clickJiaAction), for: .touchUpInside)
        jianBut.addTarget(self, action: #selector(clickJianAction), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickJiaAction() {
        
        if PJCUtil.checkLoginStatus() {
            if maxCount == 0 {
                self.count += 1
                self.countBlock?(count)
            } else {
                if self.count < maxCount {
                    self.count += 1
                    self.countBlock?(count)
                }
            }

        }
    
    }
    
    @objc private func clickJianAction() {
        if PJCUtil.checkLoginStatus() {
            if canBeZero {
                self.count -= 1
                self.countBlock?(count)
            } else {
                if self.count != 1 {
                    self.count -= 1
                    self.countBlock?(count)
                }
            }
        }
    }
}



class CountSelect_NoC_View: UIView {
    
    var countBlock: VoidBlock?
    
    
    var count: Int = 0 {
        didSet {
            self.countLab.text = String(count)
            if count == 0 {
                self.jianBut.isHidden = true
                self.countLab.isHidden = true
            } else {
                self.jianBut.isHidden = false
                self.countLab.isHidden = false
            }
        }
    }

    

    
    private let jiaBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_+"), for: .normal)
        return but
    }()
    
    
    private let jianBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_-"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.isHidden = true
        return lab
    }()
    
    var canClick: Bool = true {
        didSet {
            self.jiaBut.isEnabled = canClick
            self.jianBut.isEnabled = canClick
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        self.addSubview(jiaBut)
        jiaBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(countLab.snp.right)
            $0.centerY.equalTo(countLab)
        }
        
        self.addSubview(jianBut)
        jianBut.snp.makeConstraints {
            $0.size.equalTo(jiaBut)
            $0.right.equalTo(countLab.snp.left)
            $0.centerY.equalTo(jiaBut)
        }
        
        jiaBut.addTarget(self, action: #selector(clickJiaAction), for: .touchUpInside)
        jianBut.addTarget(self, action: #selector(clickJianAction), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickJiaAction() {
        
        if PJCUtil.checkLoginStatus() {
            let dic: [String: Any] = ["type": "+", "num": count + 1]
            self.countBlock?(dic)
        }
    
    }
    
    @objc private func clickJianAction() {
        if PJCUtil.checkLoginStatus() {
            let dic: [String: Any] = ["type": "-", "num": count - 1]
            self.countBlock?(dic)
        }
    }
    
    
}

