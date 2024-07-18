//
//  EditeBaleTypeView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/15.
//

import UIKit
import RxSwift


class EditeBaleTypeView: UIView, UIGestureRecognizerDelegate {

    private var oldStatus: String = ""

    private var curStatus: String = "" {
        didSet {
            if curStatus == "2" {
                yesImg.image = LOIMG("busy_sel_b")
                noImg.image = LOIMG("busy_unsel_b")
            } else {
                yesImg.image = LOIMG("busy_unsel_b")
                noImg.image = LOIMG("busy_sel_b")
            }
        
        }
    }
    
    private var dishesID: String = ""
    
    
    private let bag = DisposeBag()
    
    private var H: CGFloat = bottomBarH + 270
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 270), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Special offer"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Special offer"
        return lab
    }()
    
    private let yesBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let noBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let yesImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_sel_b")
        return img
    }()
    
    private let noImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let yeslab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Enable"
        return lab
    }()
    
    
    private let nolab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Disable"
        return lab
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
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(35)
        }
        
        backView.addSubview(yesBut)
        yesBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
            $0.top.equalTo(tlab.snp.bottom).offset(6)
        }
        
        yesBut.addSubview(yesImg)
        yesImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        yesBut.addSubview(yeslab)
        yeslab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(yesImg.snp.right).offset(10)
        }
        
        backView.addSubview(noBut)
        noBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
            $0.top.equalTo(tlab.snp.bottom).offset(6)
        }
        
        noBut.addSubview(noImg)
        noImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        
        noBut.addSubview(nolab)
        nolab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(noImg.snp.right).offset(10)
        }
        
        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        yesBut.addTarget(self, action: #selector(clickYesAction), for: .touchUpInside)
        noBut.addTarget(self, action: #selector(clickNoAction), for: .touchUpInside)

    }
    
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()

     }
    
    @objc private func clickSaveAction() {
        if oldStatus != curStatus {
            setGiveFreeOne_Net()
        }
        
    }
    
    @objc private func clickYesAction() {
        if curStatus != "2" {
            curStatus = "2"
        }
    }
    
    @objc private func clickNoAction() {
        if curStatus != "1" {
            curStatus = "1"
        }
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
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    
    func setAlertData(type: String, dishId: String) {
        oldStatus = type
        curStatus = type
        dishesID = dishId
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private  func setGiveFreeOne_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.doBaleType(id: dishesID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dishList"), object: nil)
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    

}
