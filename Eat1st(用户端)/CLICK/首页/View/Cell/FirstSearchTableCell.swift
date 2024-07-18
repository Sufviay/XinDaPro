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
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FEC501")
        return view
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
        //but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        return but
    }()
    
    private let scanBut: FirstCustomBut = {
        let but = FirstCustomBut()
        but.iconImg.image = LOIMG("first_sys")
        but.iconLab.text = "DINE IN"
        but.iconLab.font = BFONT(9)
        but.iconLab.textAlignment = .center
        return but
    }()
    
    private let vipBut: FirstCustomBut = {
        let but = FirstCustomBut()
        but.iconImg.image = LOIMG("first_mem")
        but.iconLab.text = "MEMBERSHIP"
        but.iconLab.font = BFONT(7)
        but.iconLab.textAlignment = .center
        return but
    }()

    
    
    
    override func setViews() {
        self.contentView.backgroundColor = .white
        
        
        contentView.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-135)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        searchBut.addSubview(localBut)
        localBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(searchBut)
            $0.left.equalToSuperview()
        }
        
        searchBut.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 24))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        
        searchBut.addSubview(postCodelab)
        postCodelab.snp.makeConstraints {
            //$0.left.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(50)
            $0.top.equalToSuperview().offset(7)
        }
        
        searchBut.addSubview(searchLab)
        searchLab.snp.makeConstraints {
            //$0.right.equalToSuperview().offset(-50)
            $0.right.equalToSuperview().offset(-40)
            $0.top.equalToSuperview().offset(25)
            //$0.left.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(50)
        }
        
        searchBut.addSubview(searchImg)
        searchImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(vipBut)
        vipBut.snp.makeConstraints {
            $0.centerY.equalTo(searchBut)
            $0.width.equalTo(55)
            $0.height.equalTo(38)
            $0.right.equalToSuperview().offset(-10)
        }

    
        contentView.addSubview(scanBut)
        scanBut.snp.makeConstraints {
            $0.centerY.equalTo(searchBut)
            $0.height.equalTo(38)
            $0.right.equalTo(vipBut.snp.left).offset(-5)
            $0.width.equalTo(55)
        }



        
        
//        contentView.addSubview(localBut)
//        localBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 40, height: 40))
//            $0.centerY.equalTo(searchBut)
//            $0.right.equalToSuperview().offset(-40)
//        }
        
        localBut.addTarget(self, action: #selector(clicklocalAciton), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        scanBut.addTarget(self, action: #selector(clickScanAction), for: .touchUpInside)
        vipBut.addTarget(self, action: #selector(clickCodeAction), for: .touchUpInside)
        
    }
    
    
    //MARK: - 搜索
    @objc private func clickSearchAction() {
        clickBlock?("search")
    }
    
    
    //MARK: - 定位
    @objc private func clicklocalAciton() {
        clickBlock?("local")
    }
    
    //MARK: - 扫一扫
    @objc private func clickScanAction() {
        clickBlock?("scan")
    }
    
    
    @objc private func clickCodeAction() {
        clickBlock?("vip")
    }
    
    
    func setCellData(addressStr: String, postCode: String) {
        self.searchLab.text = addressStr
        self.postCodelab.text = postCode
        
    }
    
    
}



class FirstCustomBut: UIButton {
    
    let iconImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let iconLab: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HCOLOR("#FFF6D4")
        layer.cornerRadius = 10
        layer.borderColor = MAINCOLOR.cgColor
        layer.borderWidth = 1

        addSubview(iconImg)
        iconImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(3)
        }
        
        addSubview(iconLab)
        iconLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
