//
//  OrderShowMoreCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderShowMoreCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    private var isShow: Bool = false {
        didSet {
            if isShow {
                self.showBut.setTitle("Hidden", for: .normal)
            } else {
                self.showBut.setTitle("Show More", for: .normal)
            }
        }
    }

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 50), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)
        return view
    }()
    
    private let showBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Show more", MAINCOLOR, SFONT(14), .clear)
        return but
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
            
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()

        }
        
        backView.addSubview(showBut)
        showBut.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        showBut.addTarget(self, action: #selector(clickMoreButAction), for: .touchUpInside)
    }
    
    func setCellData(state: Bool) {
        self.isShow = state
    }
    
    @objc private func clickMoreButAction() {
        if isShow {
            self.isShow = false
            clickBlock?(isShow)
        } else {
            self.isShow = true
            clickBlock?(isShow)
        }
        
    }
    
}


