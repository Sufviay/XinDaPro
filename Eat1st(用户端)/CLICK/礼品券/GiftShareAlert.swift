//
//  GiftShareAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/9.
//

import UIKit

class GiftShareAlert: UIView, UIGestureRecognizerDelegate {

    
    var storeName: String = "" {
        didSet {
            storeNameLab.text = storeName
        }
    }
    
    var amount: String = "" {
        didSet {
            s_numberLab.text = amount
            numberLab.text = amount
        }
    }
    
    var timeStr: String = "" {
        didSet {
            timeLab.text = timeStr
        }
    }
    
    var shareUrlStr = "" {
        didSet {
            linkLab.text = shareUrlStr
            let str_H = shareUrlStr.getTextHeigh(BFONT(12), S_W - 90) + 50
            linkBackView.snp.updateConstraints {
                $0.height.equalTo(str_H)
            }
        }
        
    }
    
    
    private var H: CGFloat = bottomBarH + 450

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Gift voucher information"
        return lab
    }()

    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("alert_close"), for: .normal)
        return but
    }()

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 450), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("giftback")
        img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card 1")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFE5C1"), BFONT(6), .left)
        lab.text = "Gift voucher"
        return lab
    }()



    private let s_numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFE5C1"), BFONT(14), .left)
        lab.text = "555"
        return lab
    }()


    private let storeNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    private let tImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(12), .left)
        lab.text = "555"
        return lab
    }()

    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(12), .left)
        lab.text = "555"
        return lab
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "SHARE LINK"
        return lab
    }()
    
    
    private let linkBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderColor = MAINCOLOR.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let linkLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(12), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let copyBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Copy Share Link", FONTCOLOR, BFONT(16), MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        backView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        
        backImg.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backImg.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(titLab)
            $0.right.equalToSuperview().offset(-15)
        }

        backImg.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 70))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(80)
        }
        
        cardImg.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        cardImg.addSubview(s_numberLab)
        s_numberLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(2)
        }
        
        
        cardImg.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.left.equalTo(sImg)
            $0.top.equalTo(sImg.snp.bottom).offset(2)
        }
        
        
        backImg.addSubview(storeNameLab)
        storeNameLab.snp.makeConstraints {
            $0.top.equalTo(cardImg).offset(-2)
            $0.left.equalTo(cardImg.snp.right).offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backImg.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalTo(cardImg.snp.right).offset(28)
            $0.top.equalTo(storeNameLab.snp.bottom).offset(12)
        }
        
        backImg.addSubview(tImg)
        tImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.left.equalTo(cardImg.snp.right).offset(15)
            $0.centerY.equalTo(numberLab)
        }
        
        backImg.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalTo(cardImg.snp.right).offset(15)
            $0.top.equalTo(numberLab.snp.bottom).offset(8)
        }
        
        backImg.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalTo(cardImg)
            $0.top.equalTo(cardImg.snp.bottom).offset(35)
        }

        backImg.addSubview(linkBackView)
        linkBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(cardImg.snp.bottom).offset(75)
            $0.height.equalTo(100)
        }
        
        linkBackView.addSubview(linkLab)
        linkLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        backImg.addSubview(copyBut)
        copyBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        copyBut.addTarget(self, action: #selector(clickCopyAction), for: .touchUpInside)
        
    }
    
    @objc private func clickCopyAction() {
        PJCUtil.wishSeed(str: shareUrlStr)
        disAppearAction()
    }
    
    
    @objc private func clickCloseAction() {
        disAppearAction()
    }
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    
    
    
}
