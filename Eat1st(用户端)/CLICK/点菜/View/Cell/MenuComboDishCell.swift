//
//  MenuComboDishCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/17.
//

import UIKit

class MenuComboDishCell: UICollectionViewCell {
    
    private let Cell_W: CGFloat = (S_W - 60) / 3
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F4F4F4")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), BFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unsel")
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(Cell_W - 10)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalTo(goodsImg.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        goodsImg.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.top.equalToSuperview().offset(2)
            $0.right.equalToSuperview().offset(-2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: ComboDishModel, isSelet: Bool) {
        self.nameLab.text = model.dishesName
        self.goodsImg.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: HOLDIMG)
        if isSelet {
            self.selectImg.image = LOIMG("sel")
            self.backView.backgroundColor = HCOLOR("#F4F4F4")
            self.nameLab.textColor = FONTCOLOR
        } else {
            self.selectImg.image = LOIMG("unsel")
            self.backView.backgroundColor = .white
            self.nameLab.textColor = HCOLOR("999999")
        }
    }
}
