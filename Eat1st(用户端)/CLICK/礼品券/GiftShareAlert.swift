//
//  GiftShareAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/9.
//

import UIKit

class GiftShareAlert: UIView {


//    private let closeBut: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("alert_close"), for: .normal)
//        return but
//    }()
//    
//    
//    private let backView: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#F7F7F7")
//        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + SET_H(450, 375)), byRoundingCorners: [.topLeft, .topRight], radii: 10)
//        return view
//    }()
//    
//    
//    private let backImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("")
//        img.contentMode = .scaleToFill
//        img.isUserInteractionEnabled = true
//        return img
//    }()
//    
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        self.frame = S_BS
//        self.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
//
//        self.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(H)
//            $0.height.equalTo(H)
//        }
//
//        
//        backView.addSubview(closeBut)
//        closeBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 40, height: 40))
//            $0.centerY.equalTo(titLab)
//            $0.right.equalToSuperview().offset(-15)
//        }
//
//        
//        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
//        
//        
//    }
//    
//    
//    @objc func clickCloseAction() {
//        disAppearAction()
//    }
//    
//    @objc private func tapAction() {
//        disAppearAction()
//    }
//    
//    
//    private func addWindow() {
//        PJCUtil.getWindowView().addSubview(self)
//        self.layoutIfNeeded()
//        UIView.animate(withDuration: 0.3) {
//            self.backView.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.bottom.equalToSuperview().offset(0)
//                $0.height.equalTo(self.H)
//            }
//            ///要加这个layout
//            self.layoutIfNeeded()
//        }
//    }
//    
//    
//    private func addWindow() {
//        PJCUtil.getWindowView().addSubview(self)
//        self.layoutIfNeeded()
//        UIView.animate(withDuration: 0.3) {
//            self.backView.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.bottom.equalToSuperview().offset(0)
//                $0.height.equalTo(self.H)
//            }
//            ///要加这个layout
//            self.layoutIfNeeded()
//        }
//    }
//    
//    func appearAction() {
//        addWindow()
//    }
//    
//    func disAppearAction() {
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.backView.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.bottom.equalToSuperview().offset(self.H)
//                $0.height.equalTo(self.H)
//            }
//            self.layoutIfNeeded()
//        }) { (_) in
//            self.removeFromSuperview()
//        }
//    }
//
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    
    
}
