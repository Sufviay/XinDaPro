//
//  StoreIntroduceButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/10/26.
//

import UIKit

class StoreIntroduceButCell: BaseTableViewCell {


    var clickBlock: VoidBlock?
    
    private var type: String = "De" {
        didSet {
            if type == "De" {
                self.line1.isHidden = false
                self.line2.isHidden = true

            }
            if type == "Co" {
                self.line1.isHidden = true
                self.line2.isHidden = false
            }
        }
    }

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()

    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Opening times"
        return lab
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    

    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.isHidden = true
        return view
    }()
    
    private let DeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, SFONT(14), .clear)
        return but
    }()
    
    private let CoBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Collection", FONTCOLOR, SFONT(14), .clear)
        return but
    }()


    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(DeBut)
        DeBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(50)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(CoBut)
        CoBut.snp.makeConstraints {
            $0.left.equalTo(DeBut.snp.right).offset(40)
            $0.top.equalToSuperview().offset(50)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.left.right.equalTo(DeBut)
            $0.top.equalTo(DeBut.snp.bottom)
        }
        
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.left.right.equalTo(CoBut)
            $0.top.equalTo(CoBut.snp.bottom)
        }
        
        DeBut.addTarget(self, action: #selector(clickDeButAciton), for: .touchUpInside)
        CoBut.addTarget(self, action: #selector(clickCoButAciton), for: .touchUpInside)
    }
    
    
    @objc func clickCoButAciton() {
        if type != "Co" {
            self.type = "Co"
            clickBlock?("Co")
        }
    }
    
    @objc func clickDeButAciton() {
        if type != "De" {
            self.type = "De"
            
            clickBlock?("De")
        }
        
        
    }
    
    func setCellData(type: String)  {
        self.type = type
    }
}
