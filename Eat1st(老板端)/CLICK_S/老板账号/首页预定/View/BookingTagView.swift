//
//  BookingTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class BookingTagView: UIView {
    
    
    var selectTagItemBlock: VoidIntBlock?
    
    
    var selectIdx: Int = 0 {
        didSet {
            
            selectTagItemBlock?(selectIdx)
            
            if selectIdx == 0 {
                
                ListBut.backgroundColor = HCOLOR("#465DFD").withAlphaComponent(0.06)
                ListBut.layer.borderWidth = 1
                listLab.textColor = HCOLOR("#465DFD")
                
                ScheBut.layer.borderWidth = 0
                ScheBut.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
                scheLab.textColor = HCOLOR("#333333")
            }
            
            if selectIdx == 1 {
                ListBut.layer.borderWidth = 0
                ListBut.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
                listLab.textColor = HCOLOR("#333333")
                
                ScheBut.layer.borderWidth = 1
                ScheBut.backgroundColor = HCOLOR("#465DFD").withAlphaComponent(0.06)
                scheLab.textColor = HCOLOR("#465DFD")
            }
        }
    }
    
    
    private let ListBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#465DFD").withAlphaComponent(0.06)
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        but.layer.borderWidth = 1
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let ScheBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        but.layer.cornerRadius = 7
        return but
    }()
    
    
    private let listLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(15), .center)
        lab.text = "Lists"
        return lab
    }()
    
    private let scheLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Schedule"
        return lab
    }()
    
    private let listImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("list")
        return img
    }()
    
    private let scheImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sche")
        return img
    }()

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ListBut)
        ListBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo((S_W - 40) / 2)
        }
        
        addSubview(ScheBut)
        ScheBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(ListBut)
        }
        
        
        ListBut.addSubview(listLab)
        listLab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        ListBut.addSubview(listImg)
        listImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(listLab.snp.left).offset(-15)
        }
        
        ScheBut.addSubview(scheLab)
        scheLab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        ScheBut.addSubview(scheImg)
        scheImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(scheLab.snp.left).offset(-15)
        }

        
        
        ListBut.addTarget(self, action: #selector(clickListBut), for: .touchUpInside)
        ScheBut.addTarget(self, action: #selector(clickScheBut), for: .touchUpInside)
    }
    
    
    @objc private func clickListBut() {
        
        if selectIdx != 0 {
            selectIdx = 0
        }
        
    }
    
    @objc private func clickScheBut() {
        if selectIdx != 1 {
            selectIdx = 1
        }
    }

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
