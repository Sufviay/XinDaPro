//
//  TableMoreAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit

class TableMoreAlert: UIView, UIGestureRecognizerDelegate {
    
    
    var clickBlock: VoidBlock?
    
    ///点击位置高度
    var tap_H: CGFloat = 0 {
        didSet {
            self.backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 115, height: 100))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H + 10)
            }
        }
    }
    
    var status: String = "" {
        didSet {
            if status == "1" {
                //启用
                tlab1.text = "Off"
            } else {
                //禁用
                tlab1.text = "On"
            }
        }
    }
       
    
    private let backView: UIImageView = {
        let view = UIImageView()
        view.image = LOIMG("dish_more_alert")
        view.isUserInteractionEnabled = true
        view.frame.size = CGSize(width: 115, height: 100)
        return view
    }()
    
    
    private let openBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let editBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
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

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Open"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "Edit"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F75E5E"), BFONT(11), .left)
        lab.text = "Delete"
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
        
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview().offset(-32)
        }
        
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.height.equalTo(line2)
            $0.bottom.equalTo(line2.snp.top).offset(-28)
        }
        
        
        backView.addSubview(openBut)
        openBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(line1.snp.top)
            $0.height.equalTo(28)
        }
        
        backView.addSubview(editBut)
        editBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line1.snp.bottom)
            $0.bottom.equalTo(line2.snp.top)
        }
        
        backView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line2.snp.bottom)
            $0.height.equalTo(28)
        }
        
        
        openBut.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        
        editBut.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        deleteBut.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }

        openBut.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
        editBut.addTarget(self, action: #selector(clickEditAction), for: .touchUpInside)
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickOpenAction() {
        disAppearAction()
        clickBlock?("open")
    }
    
    @objc private func clickEditAction() {
        disAppearAction()
        clickBlock?("edit")
    }
    
    @objc private func clickDeleteAction() {
        disAppearAction()
        clickBlock?("delete")
        
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
