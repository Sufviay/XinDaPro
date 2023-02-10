//
//  MessageRichCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit

class MessageRichCell: BaseTableViewCell {


    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let richView: RichTextView = {
        let view = RichTextView(frame: .zero, fromVC: PJCUtil.currentVC()!)
        view.isScrollEnabled = false
        return view
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(richView)
        richView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setCellData(model: MessageModel) {
        self.richView.richText = model.content
    }
    
}
