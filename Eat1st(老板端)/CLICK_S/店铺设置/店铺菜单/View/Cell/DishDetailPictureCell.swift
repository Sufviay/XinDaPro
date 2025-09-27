//
//  DishDetailPictureCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailPictureCell: BaseTableViewCell, CommonToolProtocol, SDPhotoBrowserDelegate {
    
    private var picUrl: String = ""
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Dish detail picture".local
        return lab
    }()

    private let picImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = BACKCOLOR_2
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        return img
    }()

    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 128, height: 85))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
        }
        
        picImg.addSubview(tView)
        tView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAciton))
        tView.addGestureRecognizer(tap)

    }
    
    
    @objc private func tapAciton() {
        self.showImage(picImg)
    }

    
    func setCellData(picUrl: String) {
        self.picUrl = picUrl
        self.picImg.sd_setImage(with: URL(string: picUrl))
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        if picUrl == "" {
            return nil
        } else {
            return URL(string: picUrl)
        }
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }

}
