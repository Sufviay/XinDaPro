//
//  FirstSearchTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class FirstSearchTableCell: BaseTableViewCell {
    
    var clickBlock: VoidStringBlock?


    private let searchBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        but.layer.cornerRadius = 10
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 1
        return but
    }()
    
    private let postCodelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "code"
        return lab
    }()
    
    private let searchLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Enter postcode search"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let searchImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_search_new")
        return img
    }()
    
    private let localBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("first_local_new"), for: .normal)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        return but
    }()
    
    private let scanBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("first_sys"), for: .normal)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return but
    }()


    
    
    override func setViews() {
        self.contentView.backgroundColor = .white
        
        
        contentView.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        searchBut.addSubview(postCodelab)
        postCodelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(7)
        }
        
        searchBut.addSubview(searchLab)
        searchLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(25)
            $0.left.equalToSuperview().offset(10)
        }
        
        searchBut.addSubview(searchImg)
        searchImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(scanBut)
        scanBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(searchBut)
            $0.right.equalToSuperview()
        }
        
        
        
        contentView.addSubview(localBut)
        localBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(searchBut)
            $0.right.equalToSuperview().offset(-40)
        }
        
        localBut.addTarget(self, action: #selector(clicklocalAciton), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        scanBut.addTarget(self, action: #selector(clickScanAction), for: .touchUpInside)
        
    }
    
    
    //MARK: - 搜索
    @objc func clickSearchAction() {
        clickBlock?("search")
    }
    
    
    //MARK: - 定位
    @objc func clicklocalAciton() {
        clickBlock?("local")
    }
    
    //MARK: - 扫一扫
    @objc func clickScanAction() {
        clickBlock?("scan")
    }
    
    
    func setCellData(addressStr: String, postCode: String) {
        self.searchLab.text = addressStr
        self.postCodelab.text = postCode
        
    }
    
    
}
