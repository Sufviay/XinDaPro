//
//  EditeClassifyView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit

class EditeClassifyView: UIView, UIGestureRecognizerDelegate {

    var clickBlock: VoidStringBlock?
    
    private var H: CGFloat = bottomBarH + 235

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 235), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Edit dishes category"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    private let editeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Detail", HCOLOR("#080808"), BFONT(17), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delete", HCOLOR("#F75E5E"), BFONT(17), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.layer.cornerRadius = 7
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
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
                
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(7)
        }
        
        backView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(80)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.left.right.height.equalTo(editeBut)
            $0.top.equalTo(editeBut.snp.bottom).offset(15)
        }


        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        
        self.editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
        self.deleteBut.addTarget(self, action: #selector(clickDeleteAciton), for: .touchUpInside)
    }
    
    
    @objc private func clickDeleteAciton() {
        clickBlock?("delete")
        self.disAppearAction()
    }
    
    @objc private func clickEditeAction() {
        clickBlock?("edite")
        self.disAppearAction()
    }
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()
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
                     
       UIApplication.shared.keyWindow?.endEditing(true)
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
