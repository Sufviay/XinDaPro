//
//  DeskListHeadView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/11.
//

import UIKit

class DeskListHeadView: UIView {


    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = HCOLOR("#D6D6D6").cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FA634D")
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    private let view3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#00D184")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let view4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let lab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
        lab.text = "Empty table"
        return lab
    }()
    
    private let lab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
        lab.text = "To be processed"
        return lab
    }()
    
    private let lab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
        lab.text = "Under settlement"
        return lab
    }()
    
    private let lab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
        lab.text = "To be occupied"
        return lab
    }()

    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 7
        
        layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        layer.shadowOpacity = 1
        // 阴影半径，默认3
        layer.shadowRadius = 2

        
        
        addSubview(view1)
        view1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(10))
            $0.top.equalToSuperview().offset(12)
            $0.size.equalTo(CGSize(width: 8, height: 8))
        }
        
        addSubview(lab1)
        lab1.snp.makeConstraints {
            $0.centerY.equalTo(view1)
            $0.left.equalTo(view1.snp.right).offset(2)
        }
        
        addSubview(view2)
        view2.snp.makeConstraints {
            $0.size.centerY.equalTo(view1)
            $0.left.equalTo(view1.snp.right).offset(R_W(63))
        }
        
        addSubview(lab2)
        lab2.snp.makeConstraints {
            $0.centerY.equalTo(view1)
            $0.left.equalTo(view2.snp.right).offset(2)
        }
        
        addSubview(view3)
        view3.snp.makeConstraints {
            $0.size.centerY.equalTo(view1)
            $0.left.equalTo(view2.snp.right).offset(R_W(80))
        }
        
        addSubview(lab3)
        lab3.snp.makeConstraints {
            $0.centerY.equalTo(view1)
            $0.left.equalTo(view3.snp.right).offset(2)
        }
        
        
        addSubview(view4)
        view4.snp.makeConstraints {
            $0.size.centerY.equalTo(view1)
            $0.left.equalTo(view3.snp.right).offset(R_W(85))
        }
        
        addSubview(lab4)
        lab4.snp.makeConstraints {
            $0.centerY.equalTo(view1)
            $0.left.equalTo(view4.snp.right).offset(2)
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
