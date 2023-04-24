//
//  OpeningTimeMoreAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit

class OpeningTimeMoreAlert: UIView, UIGestureRecognizerDelegate {

    var clickBlock: VoidStringBlock?
    
    ///点击位置高度
    var tap_H: CGFloat = 0 {
        didSet {
            self.backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 140, height: 180))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H + 20)
            }
        }
    }
    
    var status: String = "" {
        didSet {
            if status == "1" {
                //启用
                self.deleteBut.isHidden = true
                self.canUseBut.setTitle("Disable", for: .normal)
            } else {
                self.deleteBut.isHidden = false
                self.canUseBut.setTitle("Enable", for: .normal)
            }
        }
    }
    
    
    private let backView: UIImageView = {
        let view = UIImageView()
        view.image = LOIMG("dish_more_alert")
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleToFill
        view.frame.size = CGSize(width: 140, height: 180)
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

    
    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    private let detailBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Detail", FONTCOLOR, BFONT(12), .clear)
        return but
    }()

    private let editBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Edit", FONTCOLOR, BFONT(12), .clear)
        return but
    }()
    
    private let editDishBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Edit dishes", FONTCOLOR, BFONT(12), .clear)
        return but
    }()
    
    private let canUseBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Enable/Disable", FONTCOLOR, BFONT(12), .clear)
        return but
    }()

    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delete", HCOLOR("#F75E5E"), BFONT(12), .clear)
        return but
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
            $0.height.equalTo(0.5)
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(line1.snp.bottom).offset(30)
        }
        
        backView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(line2.snp.bottom).offset(30)
        }

        
        backView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(line3.snp.bottom).offset(30)
        }
        
        backView.addSubview(detailBut)
        detailBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(30)
        }
        
        backView.addSubview(editBut)
        editBut.snp.makeConstraints {
            $0.left.right.height.equalTo(detailBut)
            $0.bottom.equalTo(line2.snp.top)
        }
        
        backView.addSubview(editDishBut)
        editDishBut.snp.makeConstraints {
            $0.left.right.height.equalTo(detailBut)
            $0.bottom.equalTo(line3.snp.top)
        }
        
        backView.addSubview(canUseBut)
        canUseBut.snp.makeConstraints {
            $0.left.right.height.equalTo(detailBut)
            $0.bottom.equalTo(line4.snp.top)
        }
        
        
        backView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.left.right.height.equalTo(detailBut)
            $0.top.equalTo(line4.snp.bottom)
        }
        
        
        detailBut.addTarget(self, action: #selector(clickDetailAction), for: .touchUpInside)
        editBut.addTarget(self, action: #selector(clickEditAction), for: .touchUpInside)
        editDishBut.addTarget(self, action: #selector(clickEditDishAction), for: .touchUpInside)
        canUseBut.addTarget(self, action: #selector(clickCanUseAction), for: .touchUpInside)
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickDetailAction() {
        clickBlock?("detail")
        disAppearAction()
    }
    
    @objc private func clickEditAction() {
        clickBlock?("edit")
        disAppearAction()
    }
    
    @objc private func clickEditDishAction() {
        clickBlock?("edit dish")
        disAppearAction()
    }
    
    @objc private func clickCanUseAction() {
        clickBlock?("canUse")
        disAppearAction()
    }
    
    @objc private func clickDeleteAction() {
        clickBlock?("delete")
        disAppearAction()
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
