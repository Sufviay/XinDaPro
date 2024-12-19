//
//  GiftRedeemTagView.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/6.
//

import UIKit

class GiftRedeemTagView: UIView {

    
    
    private var type: String = ""
    
    
    var clickTypeBlock: VoidStringBlock?
    
    private let but1: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        return but
    }()
    
    private let but2: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        return but
    }()

    private let but3: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        return but
    }()

    
    private let lab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.text = "All"
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1.5
        view.isHidden = false
        return view
    }()
    
    private let lab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), BFONT(12), .center)
        lab.text = "Already exchanged"
        return lab
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1.5
        view.isHidden = true
        return view
    }()
    
    private let lab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), BFONT(12), .center)
        lab.text = "Already received"
        return lab
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1.5
        view.isHidden = true
        return view
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
        addSubview(but1)
        but1.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo((S_W - 30) / 5)
        }

        
        addSubview(but2)
        but2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(but1.snp.right)
            $0.width.equalTo(((S_W - 30) * 4 / 5) / 2)
        }
        
        
        addSubview(but3)
        but3.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(but2)
        }

        
        but1.addSubview(lab1)
        lab1.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        but2.addSubview(lab2)
        lab2.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        but3.addSubview(lab3)
        lab3.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        but1.addSubview(line1)
        line1.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(3)
        }
        
        but2.addSubview(line2)
        line2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(3)
        }
        
        but3.addSubview(line3)
        line3.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(3)
        }
        
        but1.addTarget(self, action: #selector(clickBut1Action), for: .touchUpInside)
        but2.addTarget(self, action: #selector(clickBut2Action), for: .touchUpInside)
        but3.addTarget(self, action: #selector(clickBut3Action), for: .touchUpInside)
        
    }
    
    
    
    @objc private func clickBut1Action() {
        if type != "" {
            line1.isHidden = false
            lab1.textColor = FONTCOLOR
            lab1.font = BFONT(14)
            
            line2.isHidden = true
            lab2.textColor = HCOLOR("666666")
            lab2.font = BFONT(12)

            line3.isHidden = true
            lab3.textColor = HCOLOR("666666")
            lab3.font = BFONT(12)
            type = ""
            clickTypeBlock?("")
        }
    }
    
    @objc private func clickBut2Action() {
        
        if type != "1" {
            line2.isHidden = false
            lab2.textColor = FONTCOLOR
            lab2.font = BFONT(14)
            
            line1.isHidden = true
            lab1.textColor = HCOLOR("666666")
            lab1.font = BFONT(12)

            line3.isHidden = true
            lab3.textColor = HCOLOR("666666")
            lab3.font = BFONT(12)
            type = "1"
            clickTypeBlock?("1")
        }

        
    }
    
    @objc private func clickBut3Action() {
        if type != "2" {
            line3.isHidden = false
            lab3.textColor = FONTCOLOR
            lab3.font = BFONT(14)
            
            line2.isHidden = true
            lab2.textColor = HCOLOR("666666")
            lab2.font = BFONT(12)

            line1.isHidden = true
            lab1.textColor = HCOLOR("666666")
            lab1.font = BFONT(12)
            type = "2"
            
            clickTypeBlock?("2")
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
