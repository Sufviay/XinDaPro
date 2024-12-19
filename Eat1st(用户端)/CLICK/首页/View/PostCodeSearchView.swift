//
//  PostCodeSearchView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class PostCodeSearchView: UIView {

    
    var backBlock: VoidBlock?
    var searchBlock: VoidStringBlock?
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("nav_back")
        return img
    }()
    
    private let searchBack: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35 / 2
        view.backgroundColor = HCOLOR("#F2F2F2")
        return view
    }()
    
    private let searchImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("search_b")
        return img
    }()
    
    private lazy var searchTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.backgroundColor = .clear
        tf.font = SFONT(14)
        tf.setPlaceholder("Enter PostCode search", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Search", FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(searchBack)
        searchBack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-75)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(35)
        }
        
        searchBack.addSubview(searchImg)
        searchImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        searchBack.addSubview(searchTF)
        searchTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        self.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        backBut.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.center.equalToSuperview()
        }

        self.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.right.equalToSuperview()
            $0.width.equalTo(75)
            $0.height.equalTo(44)
        }
        
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        backBut.addTarget(self, action: #selector(clickBackAciton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickBackAciton() {
        backBlock?("")
    }
    
    
    @objc private func clickSearchAction() {
        searchBlock?(searchTF.text ?? "")
    }

}
