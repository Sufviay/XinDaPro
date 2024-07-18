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
//    
//    var payBlock: VoidBlock?
//    
//    var amountBlock: VoidBlock?
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    let searchBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F6F6F6")
        but.clipsToBounds = true
        but.layer.cornerRadius = 15
        return but
    }()
    

    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("search 1")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let searchLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(11), .left)
        lab.text = "Search for dishes"
        return lab
    }()
    
    
//    private let payBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        but.isHidden = true
//        return but
//    }()
//    
//    
//    private let payImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("pay")
//        return img
//    }()
//    
//    private let payLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(8), .center)
//        lab.text = "PAY"
//        return lab
//    }()
//    
//    private let amountBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = HCOLOR("#FAFAFA")
//        but.clipsToBounds = true
//        but.layer.cornerRadius = 15
//        but.isHidden = true
//        return but
//    }()
//    
//    
//    private let amountImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("jinbi")
//        return img
//    }()
//    
//    private let amountNext: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("jf_next")
//        return img
//    }()
//    
//    private let amountLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(15), .right)
//        lab.text = "1000"
//        return lab
//    }()
    

    ///积分
    private let jifenView: JiFenView = {
        let view = JiFenView()
        return view
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
            $0.left.equalToSuperview().offset(55)
            $0.height.equalTo(30)
            $0.right.equalToSuperview().offset(-165)
        }
        
                
        searchBut.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 38, height: 20))
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        searchBut.addSubview(searchLab)
        searchLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(13)
        }
        
        
        self.addSubview(jifenView)
        jifenView.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 70, height: 24))
        }

        
        
//        self.addSubview(payBut)
//        payBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 50, height: 40))
//            $0.right.equalToSuperview().offset(-5)
//            $0.centerY.equalTo(backBut)
//        }
//        
//        payBut.addSubview(payImg)
//        payImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 21, height: 21))
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(5)
//        }
//        
//        payBut.addSubview(payLab)
//        payLab.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(payImg.snp.bottom).offset(2)
//        }
//        
//        
//        self.addSubview(amountBut)
//        amountBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 100, height: 30))
//            $0.centerY.equalTo(backBut)
//            $0.right.equalTo(payBut.snp.left).offset(0)
//        }
//        
//        amountBut.addSubview(amountImg)
//        amountImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 17, height: 17))
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(5)
//        }
//        
//        amountBut.addSubview(amountNext)
//        amountNext.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 5, height: 10))
//            $0.centerY.equalToSuperview()
//            $0.right.equalToSuperview().offset(-5)
//        }
//        
//        
//        amountBut.addSubview(amountLab)
//        amountLab.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.right.equalToSuperview().offset(-20)
//        }
//        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
//        amountBut.addTarget(self, action: #selector(clickAmountAction), for: .touchUpInside)
//        payBut.addTarget(self, action: #selector(clickPayAction), for: .touchUpInside)
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
//    
//    
//    @objc private func clickPayAction() {
//        payBlock?("")
//    }
//    
//    
//    @objc private func clickAmountAction() {
//        amountBlock?("")
//    }
    
    func setData(amount: String) {
        if amount == "0" {
            jifenView.isHidden = true
        } else {
            
            jifenView.isHidden = false
            
            
            self.jifenView.setData(number: amount)
            let w = amount.getTextWidth(BFONT(14), 24)

            self.jifenView.snp.updateConstraints {
                $0.size.equalTo(CGSize(width: w + 10 + 26, height: 24))
            }
        }
    }
}
