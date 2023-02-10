//
//  SearchAddressTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class SearchAddressTableCell: BaseTableViewCell {


    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_local")
        return img
    }()
    
    private let postCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "MK5 6AA"
        return lab
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .left)
        lab.numberOfLines = 0
        lab.text = "Foxcovert t Road. Milton Keynes - See addresses"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(postCodeLab)
        postCodeLab.snp.makeConstraints {
            $0.centerY.equalTo(s_img)
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(40)
        }
        
    }
    
    func setCellData(model: PlaceModel) {
        
        let str = model.postCode == "" ? model.placeName : model.postCode
        
        self.postCodeLab.text = str
        self.addressLab.text = model.address
    }
    
    

}
