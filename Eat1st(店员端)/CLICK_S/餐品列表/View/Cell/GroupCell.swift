//
//  GroupCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/15.
//

import UIKit

class GroupCell: UICollectionViewCell {
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F1F1F1")
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    private let enLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#707773"), BFONT(15), .center)
        return lab
    }()
    
    private let cnLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#707773"), BFONT(15), .center)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(enLab)
        enLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(13)
        }
        
        backView.addSubview(cnLab)
        cnLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(enLab.snp.bottom)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: ClassifyModel, isSelect: Bool) {
        enLab.text = model.classifyNameEn
        cnLab.text = model.classifyNameHk
        
        if isSelect {
            backView.backgroundColor = HCOLOR("#FF7F35")
            enLab.textColor = HCOLOR("#FFFFFF")
            cnLab.textColor = HCOLOR("#FFFFFF")
        } else {
            backView.backgroundColor = HCOLOR("#F1F1F1")
            enLab.textColor = HCOLOR("#707773")
            cnLab.textColor = HCOLOR("#707773")
        }
    }
    
}



class GroupFooter: UICollectionReusableView {
    
    
    private let line1: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 40, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(line1)
        line1.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: S_W - 40, height: 0.5))
        }
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
