//
//  MenuDishMoreAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit

class MenuDishMoreFourAlert: UIView, UIGestureRecognizerDelegate {
    
    var clickBlock: VoidStringBlock?
    
    ///点击位置高度
    var tap_H: CGFloat = 0 {
        didSet {
            self.backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 170, height: 125))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H + 20)
            }
        }
    }
        
    private let backView: UIImageView = {
        let view = UIImageView()
        view.image = LOIMG("dish_more_alert")
        view.isUserInteractionEnabled = true
        view.frame.size = CGSize(width: 170, height: 125)
        return view
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()


    
    
    private let editeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let kucunBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let discountBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let editeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Edit the detailed"
        return lab
    }()
    
    private let kucunLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Edit stock"
        return lab
    }()
    
    private let discountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Edit discount"
        return lab
    }()


    
    
    private let deleteLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F75E5E"), BFONT(11), .left)
        lab.text = "Remove item"
        return lab
    }()

    


    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)

        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(40)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line1.snp.bottom).offset(25)
        }
        
        backView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line2.snp.bottom).offset(25)
        }

        backView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(30)
        }
        
        backView.addSubview(kucunBut)
        kucunBut.snp.makeConstraints {
            $0.left.right.equalTo(editeBut)
            $0.top.equalTo(line1.snp.bottom)
            $0.bottom.equalTo(line2.snp.top)
        }
        
        backView.addSubview(discountBut)
        discountBut.snp.makeConstraints {
            $0.left.right.equalTo(editeBut)
            $0.top.equalTo(line2.snp.bottom)
            $0.bottom.equalTo(line3.snp.top)
        }
        
        

        backView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(line3.snp.bottom)
            $0.height.equalTo(30)
        }

        editeBut.addSubview(editeLab)
        editeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview().offset(2)
        }

        kucunBut.addSubview(kucunLab)
        kucunLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }

        deleteBut.addSubview(deleteLab)
        deleteLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview().offset(-2)
        }
        
        discountBut.addSubview(discountLab)
        discountLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }


        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
        editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
        kucunBut.addTarget(self, action: #selector(clickKuCunAction), for: .touchUpInside)
        discountBut.addTarget(self, action: #selector(clickDiscountAction), for: .touchUpInside)
    }
    
    
    @objc private func clickEditeAction() {
        self.clickBlock?("ed")
        self.disAppearAction()
    }
    
    
    @objc private func clickDeleteAction() {
        self.clickBlock?("de")
        self.disAppearAction()
    }
    
    @objc private func clickKuCunAction() {
        self.clickBlock?("kc")
        self.disAppearAction()
    }
    
    @objc private func clickDiscountAction() {
        self.clickBlock?("yh")
        self.disAppearAction()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        self.removeFromSuperview()
    }
     
     
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: self.backView))! {
             return false
         }
         return true
     }
     
    
}





import UIKit

class MenuDishMoreTwoAlert: UIView, UIGestureRecognizerDelegate {
    
    var clickBlock: VoidStringBlock?
    
    ///点击位置高度
    var tap_H: CGFloat = 0 {
        didSet {
            self.backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 170, height: 77))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H + 20)
            }
        }
    }
        
    private let backView: UIImageView = {
        let view = UIImageView()
        view.image = LOIMG("dish_more_alert-1")
        view.isUserInteractionEnabled = true
        view.frame.size = CGSize(width: 170, height: 77)
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    private let editeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let editeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Edit the detailed"
        return lab
    }()
    
    
    
    private let deleteLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F75E5E"), BFONT(11), .left)
        lab.text = "Remove item"
        return lab
    }()

    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)

        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(42)
            $0.height.equalTo(0.5)
        }
        

        backView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(line.snp.top)
            $0.height.equalTo(30)
        }
        

        

        backView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(line.snp.bottom)
            $0.height.equalTo(30)
        }

        editeBut.addSubview(editeLab)
        editeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview().offset(2)
        }

        deleteBut.addSubview(deleteLab)
        deleteLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview().offset(-2)
        }

        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
        editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
    }
    
    
    @objc private func clickEditeAction() {
        self.clickBlock?("ed")
        self.disAppearAction()
    }
    
    
    @objc private func clickDeleteAction() {
        self.clickBlock?("de")
        self.disAppearAction()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        self.removeFromSuperview()
    }
     
     
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: self.backView))! {
             return false
         }
         return true
     }
     
    
}

