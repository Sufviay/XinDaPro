//
//  MenuNavBarView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/6.
//

import UIKit

class MenuNavBarView: UIView {

    
    var backBlock: VoidBlock?
    
    var searchBlock: VoidBlock?
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    let searchBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Search", FONTCOLOR, BFONT(13), .clear)
        return but
    }()
    
    let backView: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F6F6F6")
        but.layer.cornerRadius = 15
        return but
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("search")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let searchLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(13), .left)
        lab.text = "Search for dishes"
        return lab
    }()
    

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.height.equalTo(30)
            $0.right.equalTo(searchBut.snp.left).offset(-10)
            $0.centerY.equalTo(backBut)
        }
        
        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(searchLab)
        searchLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(sImg.snp.right).offset(5)
        }
        
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        backView.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickBackAction() {
        self.backBlock?("")
    }
    
    @objc private func clickSearchAction() {
        self.searchBlock?("")
    }
    
}
