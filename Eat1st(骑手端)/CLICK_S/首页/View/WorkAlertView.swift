//
//  WorkAlertView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/3/1.
//

import UIKit

class WorkAlertView: UIView, UIGestureRecognizerDelegate {
    
    var clickBlock: VoidBlock?
    
    private let clickBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("work_on"), for: .normal)
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .center)
        lab.text = "The current status is offline"
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(18), .center)
        lab.text = "OFF\nDUTY"
        lab.numberOfLines = 0
        return lab
    }()

    
    
    private var H: CGFloat = bottomBarH + 370
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 370), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
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
        
        backView.addSubview(clickBut)
        clickBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 164, height: 164))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
        }
        
        clickBut.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.top.equalTo(clickBut.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
        }
        
        clickBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    
   @objc func clickAction() {
       self.disAppearAction()
       self.clickBlock?("")
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
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }



    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setWorkStatus(type: String) {
        if type == "1" {
            //工作中
            self.tlab.text = "The current status is Online"
            self.statusLab.text = "OFF\nDUTY"
            self.clickBut.setImage(LOIMG("work_on"), for: .normal)
            
        }
        if type == "2" {
            //休息中
            self.tlab.text = "The current status is offline"
            self.statusLab.text = "GO TO\nWORK"
            self.clickBut.setImage(LOIMG("work_off"), for: .normal)
        }
    }
    
    

}
