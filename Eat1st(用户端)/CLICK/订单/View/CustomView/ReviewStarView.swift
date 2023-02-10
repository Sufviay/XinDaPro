//
//  ReviewStarView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/2.
//

import UIKit

class ReviewStarView: UIView {
    
    var clickStarBlock: VoidBlock?
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .center)
        lab.text = "Are you satisfied with our food?"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("review_cp")
        return img
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(12), .left)
        lab.text = "Food Quality"
        return lab
    }()
    
    
    private let star1: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("star_nor"), for: .normal)
        but.tag = 1
        return but
    }()
    
    private let star2: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("star_nor"), for: .normal)
        but.tag = 2
        return but
    }()
    
    private let star3: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("star_nor"), for: .normal)
        but.tag = 3
        return but
    }()

    
    private let star4: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("star_nor"), for: .normal)
        but.tag = 4
        return but
    }()
    
    private let star5: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("star_nor"), for: .normal)
        but.tag = 5
        return but
    }()

    private let pointLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(12), .left)
        lab.text = "0.0"
        return lab
    }()

    
    


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
//        self.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
//        // 阴影偏移，默认(0, -3)
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        // 阴影透明度，默认0
//        self.layer.shadowOpacity = 1
//        // 阴影半径，默认3
//        self.layer.shadowRadius = 3

        
        
//        self.addSubview(titLab)
//        titLab.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(20)
//        }
//
        self.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(55))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        self.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalTo(sImg.snp.right).offset(5)
            $0.centerY.equalTo(sImg)
        }
        
        self.addSubview(star1)
        star1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.centerY.equalTo(sImg)
            $0.left.equalToSuperview().offset(R_W(155))
        }
        
        self.addSubview(star2)
        star2.snp.makeConstraints {
            $0.size.centerY.equalTo(star1)
            $0.left.equalTo(star1.snp.right)
        }
        
        self.addSubview(star3)
        star3.snp.makeConstraints {
            $0.size.centerY.equalTo(star1)
            $0.left.equalTo(star2.snp.right)
        }
        
        self.addSubview(star4)
        star4.snp.makeConstraints {
            $0.size.centerY.equalTo(star1)
            $0.left.equalTo(star3.snp.right)
        }
        
        self.addSubview(star5)
        star5.snp.makeConstraints {
            $0.size.centerY.equalTo(star1)
            $0.left.equalTo(star4.snp.right)
        }
        
        self.addSubview(pointLab)
        pointLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(star5.snp.right).offset(10)
        }



        star1.addTarget(self, action: #selector(clickStar(sender:)), for: .touchUpInside)
        star2.addTarget(self, action: #selector(clickStar(sender:)), for: .touchUpInside)
        star3.addTarget(self, action: #selector(clickStar(sender:)), for: .touchUpInside)
        star4.addTarget(self, action: #selector(clickStar(sender:)), for: .touchUpInside)
        star5.addTarget(self, action: #selector(clickStar(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickStar(sender: UIButton) {
        
        let starTag = sender.tag
        
        self.pointLab.text = "\(starTag).0"
        
        if starTag == 1 {
            star1.setImage(LOIMG("star_sel"), for: .normal)
            star2.setImage(LOIMG("star_nor"), for: .normal)
            star3.setImage(LOIMG("star_nor"), for: .normal)
            star4.setImage(LOIMG("star_nor"), for: .normal)
            star5.setImage(LOIMG("star_nor"), for: .normal)
        }
        
        if starTag == 2 {
            star2.setImage(LOIMG("star_sel"), for: .normal)
            star1.setImage(LOIMG("star_sel"), for: .normal)
            star3.setImage(LOIMG("star_nor"), for: .normal)
            star4.setImage(LOIMG("star_nor"), for: .normal)
            star5.setImage(LOIMG("star_nor"), for: .normal)
        }

        if starTag == 3 {
            star3.setImage(LOIMG("star_sel"), for: .normal)
            star2.setImage(LOIMG("star_sel"), for: .normal)
            star1.setImage(LOIMG("star_sel"), for: .normal)
            star4.setImage(LOIMG("star_nor"), for: .normal)
            star5.setImage(LOIMG("star_nor"), for: .normal)
        }

        
        if starTag == 4 {
            star4.setImage(LOIMG("star_sel"), for: .normal)
            star2.setImage(LOIMG("star_sel"), for: .normal)
            star3.setImage(LOIMG("star_sel"), for: .normal)
            star1.setImage(LOIMG("star_sel"), for: .normal)
            star5.setImage(LOIMG("star_nor"), for: .normal)
        }
        
        if starTag == 5 {
            star5.setImage(LOIMG("star_sel"), for: .normal)
            star2.setImage(LOIMG("star_sel"), for: .normal)
            star3.setImage(LOIMG("star_sel"), for: .normal)
            star4.setImage(LOIMG("star_sel"), for: .normal)
            star1.setImage(LOIMG("star_sel"), for: .normal)
        }
        
        clickStarBlock?(starTag)
        
    }
    
    
    func setData(titStr: String) {
        self.titLab.text = titStr
        if titStr == "Are you satisfied with our food?" {
            self.tLab.text = "Food quality"
            self.sImg.image = LOIMG("review_cp")
        }
        if titStr == "Are you satisfied with our service?" {
            self.tLab.text = "Service"
            self.sImg.image = LOIMG("review_fw")
        }
        
    }
    
}
