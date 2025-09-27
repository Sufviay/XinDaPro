//
//  LanguageAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/19.
//

import UIKit
import RxSwift

class LanguageAlert: UIView, UIGestureRecognizerDelegate {
    
    private let bag = DisposeBag()
    
    private var languageType: String = ""
    
    private var H: CGFloat = bottomBarH + 350
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 350), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Change language".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    

    private let c_but: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        return but
    }()
    
    private let e_but: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        return but
    }()

    private let c_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "繁體中文"
        return lab
    }()
    
    private let e_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "English"
        return lab
    }()

    private let c_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("select_b")
        img.isHidden = false
        return img
    }()
    
    private let e_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("select_b")
        img.isHidden = true
        return img
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
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 40)
            $0.height.equalTo(50)
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
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(line.snp.bottom).offset(75)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.top.equalTo(line1.snp.bottom).offset(55)
        }
        
        backView.addSubview(c_but)
        c_but.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalTo(line1.snp.top)
        }
        
        backView.addSubview(e_but)
        e_but.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(c_but)
            $0.bottom.equalTo(line2.snp.top)
        }
        
        c_but.addSubview(c_lab)
        c_lab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        e_but.addSubview(e_lab)
        e_lab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        c_but.addSubview(c_img)
        c_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 11))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-35)
        }

        e_but.addSubview(e_img)
        e_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 11))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-35)
        }
    
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        c_but.addTarget(self, action: #selector(clickChineseAction), for: .touchUpInside)
        e_but.addTarget(self, action: #selector(clickEnglishAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickCloseAction() {
        disAppearAction()
    }
    
    @objc private func clickChineseAction() {
        if c_img.isHidden {
            c_img.isHidden = false
            e_img.isHidden = true
            
            //切換中文
            languageType = "Ch"
            
        }
    }
    
    @objc private func clickEnglishAction() {
        if e_img.isHidden {
            e_img.isHidden = false
            c_img.isHidden = true
            //切換英文
            languageType = "En"
//            MyLanguageManager.saveLanguage()
//            HUD_MB.loading("设置中...".local, onView: self)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
//                HUD_MB.showSuccess("设置成功！".local, onView: PJCUtil.getWindowView())
//                disAppearAction()
// 
//                PJCUtil.currentVC()?.navigationController?.setViewControllers([BossFirstController()], animated: true)
//            }

        }
        
        
    }
    
    
    
    @objc private func clickSaveAction() {
        
        if languageType == "Ch" {
            MyLanguageManager.shared.language = .Chinese
        }
        if languageType == "En" {
            MyLanguageManager.shared.language = .English
        }        
        MyLanguageManager.saveLanguage()
        
        HUD_MB.loading("设置中...".local, onView: PJCUtil.getWindowView())
        
        HTTPTOOl.setLanguage().subscribe(onNext:{ [unowned self] (json) in
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                HUD_MB.showSuccess("设置成功！".local, onView: PJCUtil.getWindowView())
                disAppearAction()
                PJCUtil.currentVC()?.navigationController?.setViewControllers([BossFirstController()], animated: true)
            }
        
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
        }).disposed(by: bag)
        
        

    }
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    private func setLanguage() {
        
        if MyLanguageManager.currentLanguage() == .Chinese {
            c_img.isHidden = false
            e_img.isHidden = true
            languageType = "Ch"
        }
        if MyLanguageManager.currentLanguage() == .English {
            c_img.isHidden = true
            e_img.isHidden = false
            languageType = "En"
        }
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
       setLanguage()
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
    
}
