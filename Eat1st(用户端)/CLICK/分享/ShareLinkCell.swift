//
//  ShareLinkCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit

class ShareLinkCell: BaseTableViewCell {

    private var urlStr: String = ""
    
        
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let codeImg: UIImageView = {
        let img = UIImageView()
        return img
    }()

    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Share Link"
        return lab
    }()
    
    
    private let copyBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Copy Share Link", .black, BFONT(16), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()

    private let linkBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F4F4F4")
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    private let linkUrlLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    
    override func setViews() {
        
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(codeImg)
        codeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 210, height: 210))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tlab1)
            $0.top.equalTo(codeImg.snp.bottom).offset(15)
        }
        
        
        contentView.addSubview(copyBut)
        copyBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-25)
            $0.height.equalTo(45)
        }
        
        contentView.addSubview(linkBackView)
        linkBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalTo(copyBut.snp.top).offset(-20)
            $0.top.equalTo(codeImg.snp.bottom).offset(40)
        }
        
        linkBackView.addSubview(linkUrlLab)
        linkUrlLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        
        //40 + 210 + 40 + 50 + 70
        
        copyBut.addTarget(self, action: #selector(clickCopyLinkAction), for: .touchUpInside)
        
    }
    
    
    func setCellData(url: String) {
        linkUrlLab.text = url
        urlStr = url
        let ewImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: url, size: CGSize(width: 210, height: 210), qrColor: .black, bkColor: .clear)
        codeImg.image = ewImg
    }
    
    @objc private func clickCopyLinkAction() {
        PJCUtil.wishSeed(str: urlStr)
    }
    
}
