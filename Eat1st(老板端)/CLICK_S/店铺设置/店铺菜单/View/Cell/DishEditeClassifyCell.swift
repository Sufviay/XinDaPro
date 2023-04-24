//
//  DishEditeClassifyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit

class DishEditeClassifyCell: BaseTableViewCell {

    var selectBlock: VoidBlock?

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Category"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F9F9")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let msglab: UILabel  = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        return lab
    }()
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sj_show"), for: .normal)
        return but
    }()

    override func setViews() {
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(msglab)
        msglab.snp.makeConstraints {
            
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 40, height: 30))
        }

        selectBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    func setCellData(c_msg: String) {
        self.msglab.text = c_msg
    }

    
    @objc private func clickAction() {
        selectBlock?("")
    }
    
    

    
    

}
